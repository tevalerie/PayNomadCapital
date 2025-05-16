@echo off
setlocal enabledelayedexpansion

rem Repository Migration Script for Windows
rem This script will:
rem 1. Back up your current repository
rem 2. Delete the current repository (with confirmation)
rem 3. Create a new repository
rem 4. Push the backup to the new repository

echo ===== PayNomad Capital Repository Migration Tool =====
echo.

rem Check for required tools
where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: git is not installed. Please install git and try again.
    exit /b 1
)

where gh >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Warning: GitHub CLI (gh) is not installed. We'll use manual GitHub API calls instead.
    echo For better experience, consider installing GitHub CLI: https://cli.github.com/
    echo.
    set USE_GH_CLI=false
) else (
    set USE_GH_CLI=true
    rem Check if logged in to GitHub CLI
    gh auth status >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo You need to log in to GitHub CLI first.
        gh auth login
    )
)

rem Get current repository information
for /f "tokens=*" %%a in ('git config --get remote.origin.url 2^>nul') do set CURRENT_REMOTE=%%a

if "!CURRENT_REMOTE!"=="" (
    echo No remote repository detected. Is this a git repository?
    set /p INIT_REPO=Do you want to initialize a new git repository? (y/n): 
    if /i "!INIT_REPO!"=="y" (
        git init
        echo Repository initialized.
    ) else (
        echo Cannot proceed without a git repository. Exiting.
        exit /b 1
    )
) else (
    rem Extract owner and repo name from remote URL
    echo !CURRENT_REMOTE! | findstr /C:"github.com" >nul
    if %ERRORLEVEL% equ 0 (
        echo !CURRENT_REMOTE! | findstr /C:"https://" >nul
        if %ERRORLEVEL% equ 0 (
            for /f "tokens=4,5 delims=/" %%a in ("!CURRENT_REMOTE!") do (
                set CURRENT_OWNER=%%a
                set CURRENT_REPO=%%b
            )
            set CURRENT_REPO=!CURRENT_REPO:.git=!
        ) else (
            for /f "tokens=2 delims=:" %%a in ("!CURRENT_REMOTE!") do set REPO_INFO=%%a
            for /f "tokens=1,2 delims=/" %%a in ("!REPO_INFO!") do (
                set CURRENT_OWNER=%%a
                set CURRENT_REPO=%%b
            )
            set CURRENT_REPO=!CURRENT_REPO:.git=!
        )
        
        echo Current repository: !CURRENT_OWNER!/!CURRENT_REPO!
    ) else (
        echo Non-GitHub repository detected: !CURRENT_REMOTE!
        set /p CURRENT_OWNER=Enter the GitHub owner name for the new repository: 
        set /p CURRENT_REPO=Enter the GitHub repository name for the new repository: 
    )
)

rem Create timestamp for backup directory
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set DATE=%%c%%a%%b
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set BACKUP_DIR=..\repo_backup_%DATE%_%TIME%

rem Step 1: Create backup
echo.
echo Step 1: Creating backup of the current repository

rem Create backup directory
mkdir "%BACKUP_DIR%"

rem Copy all files (including .git for history)
echo Copying repository files to %BACKUP_DIR%...
xcopy /E /I /H /Y /EXCLUDE:node_modules;.DS_Store;.env .\* "%BACKUP_DIR%"

echo Backup created successfully at: %BACKUP_DIR%

rem Step 2: Delete current repository (with confirmation)
echo.
echo Step 2: Delete current repository

if not "!CURRENT_REMOTE!"=="" (
    echo WARNING: This will delete the remote repository: !CURRENT_OWNER!/!CURRENT_REPO!
    echo This action CANNOT be undone!
    set /p CONFIRM_DELETE=Type the repository name (!CURRENT_REPO!) to confirm deletion: 
    
    if not "!CONFIRM_DELETE!"=="!CURRENT_REPO!" (
        echo Repository name doesn't match. Skipping deletion.
    ) else (
        if "!USE_GH_CLI!"=="true" (
            echo Deleting repository using GitHub CLI...
            gh repo delete "!CURRENT_OWNER!/!CURRENT_REPO!" --yes
        ) else (
            echo To delete the repository, please go to:
            echo https://github.com/!CURRENT_OWNER!/!CURRENT_REPO!/settings
            echo Scroll to the bottom and click 'Delete this repository'
            pause
        )
        echo Repository deleted.
    )
) else (
    echo No remote repository to delete. Skipping this step.
)

rem Step 3: Create new repository
echo.
echo Step 3: Create new repository

set /p NEW_REPO=Enter new repository name (default: !CURRENT_REPO!): 
if "!NEW_REPO!"=="" set NEW_REPO=!CURRENT_REPO!

set /p MAKE_PRIVATE=Make repository private? (y/n, default: y): 
if "!MAKE_PRIVATE!"=="" set MAKE_PRIVATE=y

if /i "!MAKE_PRIVATE!"=="y" (
    set VISIBILITY=--private
    set VISIBILITY_API=private
) else (
    set VISIBILITY=--public
    set VISIBILITY_API=public
)

set /p REPO_DESC=Enter repository description (optional): 

if "!USE_GH_CLI!"=="true" (
    echo Creating new repository using GitHub CLI...
    gh repo create "!CURRENT_OWNER!/!NEW_REPO!" !VISIBILITY! --description "!REPO_DESC!" --source="!BACKUP_DIR!" --push
    
    if %ERRORLEVEL% neq 0 (
        echo Failed to create repository with GitHub CLI. Trying manual creation...
        set USE_GH_CLI=false
    ) else (
        echo Repository created and code pushed successfully!
        set NEW_REPO_URL=https://github.com/!CURRENT_OWNER!/!NEW_REPO!
    )
)

if "!USE_GH_CLI!"=="false" (
    echo Please create a new repository manually at: https://github.com/new
    echo Use these settings:
    echo   - Repository name: !NEW_REPO!
    if "!VISIBILITY_API!"=="private" (
        echo   - Visibility: Private
    ) else (
        echo   - Visibility: Public
    )
    echo   - Description: !REPO_DESC!
    echo   - Do NOT initialize with README, .gitignore, or license
    
    pause
    set /p NEW_REPO_URL=Enter the new repository URL: 
    
    rem Step 4: Push backup to new repository
    echo.
    echo Step 4: Pushing backup to new repository
    
    cd "!BACKUP_DIR!"
    
    rem Configure git if needed
    git config user.name >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        set /p GIT_USERNAME=Enter your Git username: 
        git config user.name "!GIT_USERNAME!"
    )
    
    git config user.email >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        set /p GIT_EMAIL=Enter your Git email: 
        git config user.email "!GIT_EMAIL!"
    )
    
    rem Update remote URL
    git remote remove origin 2>nul
    git remote add origin "!NEW_REPO_URL!"
    
    rem Push to new repository
    echo Pushing code to new repository...
    git push -u origin main 2>nul || git push -u origin master 2>nul
    
    if %ERRORLEVEL% neq 0 (
        echo Initial push failed. Trying to push to 'main' branch...
        git checkout -b main
        git add .
        git commit -m "Initial commit"
        git push -u origin main
    )
)

rem Final instructions
echo.
echo Repository migration completed!
echo New repository URL: !NEW_REPO_URL!
echo.
echo Next steps:
echo 1. Update any deployment settings in Netlify or other services
echo 2. Update any GitHub Actions or workflow settings
echo 3. Verify that everything is working correctly
echo 4. If you're satisfied with the migration, you can delete the backup directory:
echo    rmdir /S /Q "!BACKUP_DIR!"

echo.
echo Thank you for using the PayNomad Capital Repository Migration Tool!

endlocal
