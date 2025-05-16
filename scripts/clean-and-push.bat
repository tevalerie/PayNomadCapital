@echo off
echo 🧹 Starting repository cleanup...

:: Remove storyboard files
echo Removing storyboard files...
if exist src\tempobook\storyboards rmdir /s /q src\tempobook\storyboards
if exist src\tempobook\dynamic rmdir /s /q src\tempobook\dynamic

:: Remove Supabase migration files
echo Removing Supabase migration files...
if exist supabase\migrations rmdir /s /q supabase\migrations

:: Remove MagicLinks-related files (Windows doesn't have a direct equivalent to find)
echo Removing MagicLinks-related files...
for /r %%i in (*MagicLink*) do del "%%i"

:: Add remote repository if it doesn't exist
echo Adding remote repository...
git remote add origin https://github.com/tevalerie/PayNomad-Capital-Ltd-Final 2>nul

:: Stage all changes
echo Staging changes...
git add .

:: Commit changes
echo Committing changes...
git commit -m "Clean repository for deployment"

:: Push to remote repository
echo Pushing to remote repository...
git push -u origin main

echo ✅ Repository cleaned and pushed to remote!
