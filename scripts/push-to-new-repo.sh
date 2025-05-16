#!/bin/bash

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${YELLOW}PayNomad Capital New Repository Setup${NC}"
echo "This script will help you push your code to a new GitHub repository."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: Git is not installed. Please install Git first.${NC}"
    exit 1
fi

# Get repository information
echo -e "\n${GREEN}Step 1: New Repository Information${NC}"
read -p "Enter your new repository URL (e.g., https://github.com/username/repo): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}Error: Repository URL cannot be empty.${NC}"
    exit 1
fi

# Add the remote and push
echo -e "\n${GREEN}Step 2: Adding remote repository...${NC}"
git remote add origin "$REPO_URL"

echo -e "\n${GREEN}Step 3: Pushing to remote repository...${NC}"
git push -u origin main || git push -u origin master

echo -e "\n${GREEN}Done! Your code has been pushed to the new repository.${NC}"
