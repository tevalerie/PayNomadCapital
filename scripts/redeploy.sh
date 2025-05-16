#!/bin/bash

# Script to clear out repository and redeploy from TempoLabs

echo "Starting repository cleanup and redeployment process..."

# Step 1: Create a temporary directory for the current code
echo "Creating temporary backup of current code..."
TEMP_DIR="./temp_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$TEMP_DIR"
cp -r ./* "$TEMP_DIR" 2>/dev/null
echo "Backup created at $TEMP_DIR"

# Step 2: Initialize a new repository
echo "Reinitializing repository..."
rm -rf .git
git init

# Step 3: Add all files and make initial commit
echo "Adding all files to new repository..."
git add .
git commit -m "Initial commit from TempoLabs environment"

# Step 4: Add GitHub remote (user will need to provide their GitHub URL)
echo "Please enter your GitHub repository URL (e.g., https://github.com/username/repo.git):"
read GITHUB_URL

if [ -z "$GITHUB_URL" ]; then
  echo "Error: GitHub URL is required."
  exit 1
fi

git remote add origin "$GITHUB_URL"

# Step 5: Force push to master branch
echo "Force pushing to master branch..."
git push -f origin master

echo "Repository has been cleared and redeployed successfully!"
echo "The current TempoLabs code is now on the master branch of your GitHub repository."
echo "A backup of your files was created at $TEMP_DIR"
