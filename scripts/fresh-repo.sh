#!/bin/bash

# This script creates a fresh Git repository with only the current state of the codebase
# It skips backup and removes all Git history

echo "Removing Git history..."
rm -rf .git

echo "Cleaning up repository before initialization..."
# Remove duplicate files and unnecessary directories
echo "Removing unnecessary storyboard files..."
rm -rf src/tempobook/storyboards/*
rm -rf src/tempobook/dynamic/*

echo "Removing Supabase migration files..."
rm -rf supabase/migrations/*

echo "Removing MagicLinks related files..."
find . -type f -name "*MagicLink*" -delete

echo "Initializing new Git repository..."
git init
git add .
git commit -m "Initial commit - Clean repository state"

# Create main branch (default is now main in newer Git versions)
git branch -M main

# Create master branch as well
git checkout -b master

# Switch back to main
git checkout main

echo "Repository has been cleaned and initialized with main and master branches."
echo "To push to your remote repository, use:"
echo "git remote add origin YOUR_REPOSITORY_URL"
echo "git push -u --force origin main"
echo "git push -u --force origin master"
