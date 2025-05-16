@echo off
REM This script creates a fresh Git repository with only the current state of the codebase
REM It skips backup and removes all Git history

echo Removing Git history...
rmdir /S /Q .git

echo Cleaning up repository before initialization...
REM Remove duplicate files and unnecessary directories
echo Removing unnecessary storyboard files...
rmdir /S /Q src\tempobook\storyboards
mkdir src\tempobook\storyboards
rmdir /S /Q src\tempobook\dynamic
mkdir src\tempobook\dynamic

echo Removing Supabase migration files...
if exist supabase\migrations rmdir /S /Q supabase\migrations
if exist supabase mkdir supabase\migrations

echo Removing MagicLinks related files...
for /r %%i in (*MagicLink*) do del /q "%%i"

echo Initializing new Git repository...
git init
git add .
git commit -m "Initial commit - Clean repository state"

REM Create main branch (default is now main in newer Git versions)
git branch -M main

REM Create master branch as well
git checkout -b master

REM Switch back to main
git checkout main

echo Repository has been cleaned and initialized with main and master branches.
echo To push to your remote repository, use:
echo git remote add origin YOUR_REPOSITORY_URL
echo git push -u --force origin main
echo git push -u --force origin master
