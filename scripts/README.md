# Repository Migration Scripts

## Overview

These scripts help you manage your GitHub repository by providing tools to:

1. Back up your current repository
2. Delete the current repository (with confirmation)
3. Create a new repository
4. Push the backup to the new repository

## Available Scripts

- `repo-migration.sh` - For macOS/Linux users
- `repo-migration-windows.bat` - For Windows users

## Prerequisites

- Git installed and configured
- GitHub CLI (optional but recommended) - https://cli.github.com/
- GitHub account with appropriate permissions

## Usage Instructions

### For macOS/Linux Users

1. Make the script executable:
   ```bash
   chmod +x scripts/repo-migration.sh
   ```

2. Run the script:
   ```bash
   ./scripts/repo-migration.sh
   ```

### For Windows Users

1. Open Command Prompt or PowerShell

2. Navigate to your project directory

3. Run the script:
   ```cmd
   scripts\repo-migration-windows.bat
   ```

## What the Scripts Do

### 1. Backup Creation

The script creates a complete backup of your repository, including all files and Git history, in a directory outside your current project.

### 2. Repository Deletion

With your confirmation (you must type the repository name), the script will delete your current GitHub repository. This step can be skipped if desired.

### 3. New Repository Creation

The script will help you create a new GitHub repository with your specified settings (name, visibility, description).

### 4. Code Migration

Finally, the script pushes your backed-up code to the new repository, preserving your commit history.

## Safety Features

- Confirmation required before deleting repositories
- Complete backup created before any destructive actions
- Error handling for common issues

## After Migration

After running the script, you should:

1. Update any deployment settings in Netlify or other services
2. Update any GitHub Actions or workflow settings
3. Verify that everything is working correctly
4. Delete the backup directory if no longer needed

## Troubleshooting

If you encounter issues:

1. Check that you have the necessary permissions for your GitHub repositories
2. Ensure Git is properly configured with your credentials
3. If using GitHub CLI, verify you're properly authenticated

For manual steps (if automation fails):

1. Create a new repository on GitHub.com
2. Add it as a new remote to your local repository
3. Push your code to the new repository
