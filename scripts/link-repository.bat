@echo off
setlocal enabledelayedexpansion

echo PayNomad Capital Repository Linking Tool
echo This script will help you link your repository to Tempo Labs.

:: Check if git is installed
git --version > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: Git is not installed. Please install Git first.
    exit /b 1
)

:: Check if GitHub CLI is installed (optional but recommended)
gh --version > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Warning: GitHub CLI is not installed. Some features may be limited.
    echo Consider installing GitHub CLI for better integration: https://cli.github.com/
)

:: Get repository information
echo.
echo Step 1: Repository Information
set /p REPO_URL=Enter your repository URL (e.g., https://github.com/username/repo): 

if "!REPO_URL!"=="" (
    echo Error: Repository URL cannot be empty.
    exit /b 1
)

:: Extract repo name from URL
for %%i in (!REPO_URL!) do set REPO_NAME=%%~ni

echo.
echo Step 2: Linking Repository
echo Would you like to:
echo 1. Clone the repository and set up Tempo Labs integration
echo 2. Link an existing local repository to Tempo Labs
set /p CHOICE=Enter your choice (1 or 2): 

if "%CHOICE%"=="1" (
    :: Clone the repository
    echo.
    echo Cloning repository !REPO_URL!...
    git clone "!REPO_URL!" "!REPO_NAME!-tempo"
    cd "!REPO_NAME!-tempo"
    
    :: Set up Tempo Labs integration
    echo.
    echo Setting up Tempo Labs integration...
    echo Adding tempo-devtools package...
    npm install tempo-devtools --save-dev
    
    :: Create tempo config file
    echo.
    echo Creating tempo configuration...
    (
        echo {
        echo   "projectName": "!REPO_NAME!",
        echo   "version": "1.0.0"
        echo }
    ) > tempo.config.json
    
    echo.
    echo Repository successfully linked to Tempo Labs!
    echo Next steps:
    echo 1. Open the project in Tempo Labs
    echo 2. Configure any additional settings in the Tempo Labs dashboard
) else if "%CHOICE%"=="2" (
    :: Link existing repository
    set /p LOCAL_REPO_PATH=Enter the path to your local repository: 
    
    if not exist "!LOCAL_REPO_PATH!" (
        echo Error: Directory does not exist.
        exit /b 1
    )
    
    cd "!LOCAL_REPO_PATH!"
    
    :: Check if it's a git repository
    if not exist ".git" (
        echo Error: Not a git repository.
        exit /b 1
    )
    
    :: Set up Tempo Labs integration
    echo.
    echo Setting up Tempo Labs integration...
    echo Adding tempo-devtools package...
    npm install tempo-devtools --save-dev
    
    :: Create tempo config file
    echo.
    echo Creating tempo configuration...
    (
        echo {
        echo   "projectName": "!REPO_NAME!",
        echo   "version": "1.0.0"
        echo }
    ) > tempo.config.json
    
    echo.
    echo Repository successfully linked to Tempo Labs!
    echo Next steps:
    echo 1. Open the project in Tempo Labs
    echo 2. Configure any additional settings in the Tempo Labs dashboard
) else (
    echo Invalid choice. Please run the script again and select 1 or 2.
    exit /b 1
)

echo.
echo Important:
echo To complete the linking process, you'll need to:
echo 1. Log in to your Tempo Labs account
echo 2. Go to 'Projects' and select 'Import Repository'
echo 3. Select your repository and follow the on-screen instructions

echo.
echo Done!

endlocal
