#!/bin/bash

# Repository Migration Script
# This script will:
# 1. Back up your current repository
# 2. Delete the current repository (with confirmation)
# 3. Create a new repository
# 4. Push the backup to the new repository

set -e

# Text formatting
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

echo -e "${BOLD}${BLUE}===== PayNomad Capital Repository Migration Tool =====${RESET}\n"

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for required tools
if ! command_exists git; then
  echo -e "${RED}Error: git is not installed. Please install git and try again.${RESET}"
  exit 1
}

if ! command_exists gh; then
  echo -e "${YELLOW}Warning: GitHub CLI (gh) is not installed. We'll use manual GitHub API calls instead.${RESET}"
  echo -e "${YELLOW}For better experience, consider installing GitHub CLI: https://cli.github.com/${RESET}\n"
  USE_GH_CLI=false
else
  USE_GH_CLI=true
  # Check if logged in to GitHub CLI
  if ! gh auth status &>/dev/null; then
    echo -e "${YELLOW}You need to log in to GitHub CLI first.${RESET}"
    gh auth login
  fi
fi

# Get current repository information
CURRENT_REMOTE=$(git config --get remote.origin.url || echo "")

if [ -z "$CURRENT_REMOTE" ]; then
  echo -e "${YELLOW}No remote repository detected. Is this a git repository?${RESET}"
  read -p "Do you want to initialize a new git repository? (y/n): " INIT_REPO
  if [[ $INIT_REPO == "y" || $INIT_REPO == "Y" ]]; then
    git init
    echo -e "${GREEN}Repository initialized.${RESET}"
  else
    echo -e "${RED}Cannot proceed without a git repository. Exiting.${RESET}"
    exit 1
  fi
else
  # Extract owner and repo name from remote URL
  if [[ $CURRENT_REMOTE == *"github.com"* ]]; then
    if [[ $CURRENT_REMOTE == *"https://"* ]]; then
      REPO_INFO=${CURRENT_REMOTE#*github.com/}
      REPO_INFO=${REPO_INFO%.git}
    else
      REPO_INFO=${CURRENT_REMOTE#*:}
      REPO_INFO=${REPO_INFO%.git}
    fi
    
    CURRENT_OWNER=${REPO_INFO%%/*}
    CURRENT_REPO=${REPO_INFO#*/}
    
    echo -e "${BLUE}Current repository: ${BOLD}$CURRENT_OWNER/$CURRENT_REPO${RESET}"
  else
    echo -e "${YELLOW}Non-GitHub repository detected: $CURRENT_REMOTE${RESET}"
    read -p "Enter the GitHub owner name for the new repository: " CURRENT_OWNER
    read -p "Enter the GitHub repository name for the new repository: " CURRENT_REPO
  fi
fi

# Backup directory
BACKUP_DIR="../repo_backup_$(date +%Y%m%d_%H%M%S)"

# Step 1: Create backup
echo -e "\n${BOLD}${BLUE}Step 1: Creating backup of the current repository${RESET}"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Copy all files (including .git for history)
echo "Copying repository files to $BACKUP_DIR..."
rsync -a --exclude node_modules --exclude .DS_Store --exclude .env ./ "$BACKUP_DIR/"

echo -e "${GREEN}Backup created successfully at: $BACKUP_DIR${RESET}"

# Step 2: Delete current repository (with confirmation)
echo -e "\n${BOLD}${BLUE}Step 2: Delete current repository${RESET}"

if [ -n "$CURRENT_REMOTE" ]; then
  echo -e "${RED}WARNING: This will delete the remote repository: $CURRENT_OWNER/$CURRENT_REPO${RESET}"
  echo -e "${RED}This action CANNOT be undone!${RESET}"
  read -p "Type the repository name ($CURRENT_REPO) to confirm deletion: " CONFIRM_DELETE
  
  if [ "$CONFIRM_DELETE" != "$CURRENT_REPO" ]; then
    echo -e "${YELLOW}Repository name doesn't match. Skipping deletion.${RESET}"
  else
    if [ "$USE_GH_CLI" = true ]; then
      echo "Deleting repository using GitHub CLI..."
      gh repo delete "$CURRENT_OWNER/$CURRENT_REPO" --yes
    else
      echo "To delete the repository, please go to:"
      echo "https://github.com/$CURRENT_OWNER/$CURRENT_REPO/settings"
      echo "Scroll to the bottom and click 'Delete this repository'"
      read -p "Press Enter once you've deleted the repository... "
    fi
    echo -e "${GREEN}Repository deleted.${RESET}"
  fi
else
  echo -e "${YELLOW}No remote repository to delete. Skipping this step.${RESET}"
fi

# Step 3: Create new repository
echo -e "\n${BOLD}${BLUE}Step 3: Create new repository${RESET}"

read -p "Enter new repository name (default: $CURRENT_REPO): " NEW_REPO
NEW_REPO=${NEW_REPO:-$CURRENT_REPO}

read -p "Make repository private? (y/n, default: y): " MAKE_PRIVATE
MAKE_PRIVATE=${MAKE_PRIVATE:-y}

if [[ $MAKE_PRIVATE == "y" || $MAKE_PRIVATE == "Y" ]]; then
  VISIBILITY="--private"
  VISIBILITY_API="private"
else
  VISIBILITY="--public"
  VISIBILITY_API="public"
fi

read -p "Enter repository description (optional): " REPO_DESC

if [ "$USE_GH_CLI" = true ]; then
  echo "Creating new repository using GitHub CLI..."
  gh repo create "$CURRENT_OWNER/$NEW_REPO" $VISIBILITY --description "$REPO_DESC" --source="$BACKUP_DIR" --push
  
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create repository with GitHub CLI. Trying manual creation...${RESET}"
    USE_GH_CLI=false
  else
    echo -e "${GREEN}Repository created and code pushed successfully!${RESET}"
    NEW_REPO_URL="https://github.com/$CURRENT_OWNER/$NEW_REPO"
  fi
fi

if [ "$USE_GH_CLI" = false ]; then
  echo "Please create a new repository manually at: https://github.com/new"
  echo "Use these settings:"
  echo "  - Repository name: $NEW_REPO"
  echo "  - Visibility: $([ "$VISIBILITY_API" == "private" ] && echo "Private" || echo "Public")"
  echo "  - Description: $REPO_DESC"
  echo "  - Do NOT initialize with README, .gitignore, or license"
  
  read -p "Press Enter once you've created the repository... "
  read -p "Enter the new repository URL: " NEW_REPO_URL
  
  # Step 4: Push backup to new repository
  echo -e "\n${BOLD}${BLUE}Step 4: Pushing backup to new repository${RESET}"
  
  cd "$BACKUP_DIR"
  
  # Configure git if needed
  if ! git config user.name > /dev/null; then
    read -p "Enter your Git username: " GIT_USERNAME
    git config user.name "$GIT_USERNAME"
  fi
  
  if ! git config user.email > /dev/null; then
    read -p "Enter your Git email: " GIT_EMAIL
    git config user.email "$GIT_EMAIL"
  fi
  
  # Update remote URL
  git remote remove origin 2>/dev/null || true
  git remote add origin "$NEW_REPO_URL"
  
  # Push to new repository
  echo "Pushing code to new repository..."
  git push -u origin main || git push -u origin master
  
  if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Initial push failed. Trying to push to 'main' branch...${RESET}"
    git checkout -b main
    git add .
    git commit -m "Initial commit"
    git push -u origin main
  fi
fi

# Final instructions
echo -e "\n${BOLD}${GREEN}Repository migration completed!${RESET}"
echo -e "${BLUE}New repository URL: ${BOLD}$NEW_REPO_URL${RESET}"
echo -e "\n${YELLOW}Next steps:${RESET}"
echo "1. Update any deployment settings in Netlify or other services"
echo "2. Update any GitHub Actions or workflow settings"
echo "3. Verify that everything is working correctly"
echo "4. If you're satisfied with the migration, you can delete the backup directory:"
echo "   rm -rf \"$BACKUP_DIR\""

echo -e "\n${BOLD}${BLUE}Thank you for using the PayNomad Capital Repository Migration Tool!${RESET}"
