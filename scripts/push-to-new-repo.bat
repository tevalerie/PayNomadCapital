@echo off
setlocal enabledelayedexpansion

echo PayNomad Capital New Repository Setup
echo This script will help you push your code to a new GitHub repository.

:: Check if git is installed
git --version > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: Git is not installed. Please install Git first.
    exit /b 1
)

:: Get repository information
echo.
echo Step 1: New Repository Information
set /p REPO_URL=Enter your new repository URL (e.g., https://github.com/username/repo): 

if "!REPO_URL!"=="" (
    echo Error: Repository URL cannot be empty.
    exit /b 1
)

:: Add the remote and push
echo.
echo Step 2: Adding remote repository...
git remote add origin "!REPO_URL!"

echo.
echo Step 3: Pushing to remote repository...
git push -u origin main || git push -u origin master

echo.
echo Done! Your code has been pushed to the new repository.

endlocal
