@echo off
REM This script creates a fresh Git repository with only the current state of the codebase
REM It preserves your current files but removes all Git history

echo Creating backup of current files...
mkdir ..\temp_repo_backup
xcopy /E /I .\* ..\temp_repo_backup\

echo Removing Git history...
rmdir /S /Q .git

echo Initializing new Git repository...
git init
git add .
git commit -m "Initial commit - Clean repository state"

echo Repository has been cleaned. Old files are backed up in ..\temp_repo_backup
echo You can now push this to a new or existing remote repository.
echo To push to an existing repository, use:
echo git remote add origin YOUR_REPOSITORY_URL
echo git push -u --force origin main
