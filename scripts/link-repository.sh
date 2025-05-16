#!/bin/bash

# Script to link an existing repository to Tempo Labs

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${YELLOW}PayNomad Capital Repository Linking Tool${NC}"
echo "This script will help you link your repository to Tempo Labs."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: Git is not installed. Please install Git first.${NC}"
    exit 1
 fi

# Check if GitHub CLI is installed (optional but recommended)
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}Warning: GitHub CLI is not installed. Some features may be limited.${NC}"
    echo "Consider installing GitHub CLI for better integration: https://cli.github.com/"
fi

# Get repository information
echo -e "\n${GREEN}Step 1: Repository Information${NC}"
read -p "Enter your repository URL (e.g., https://github.com/username/repo): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}Error: Repository URL cannot be empty.${NC}"
    exit 1
fi

# Extract repo name from URL
REPO_NAME=$(basename "$REPO_URL" .git)

echo -e "\n${GREEN}Step 2: Linking Repository${NC}"
echo "Would you like to:"
echo "1. Clone the repository and set up Tempo Labs integration"
echo "2. Link an existing local repository to Tempo Labs"
read -p "Enter your choice (1 or 2): " CHOICE

case $CHOICE in
    1)
        # Clone the repository
        echo -e "\nCloning repository $REPO_URL..."
        git clone "$REPO_URL" "$REPO_NAME-tempo"
        cd "$REPO_NAME-tempo" || exit 1
        
        # Set up Tempo Labs integration
        echo -e "\n${GREEN}Setting up Tempo Labs integration...${NC}"
        echo "Adding tempo-devtools package..."
        npm install tempo-devtools --save-dev
        
        # Create tempo config file
        echo -e "\nCreating tempo configuration..."
        cat > tempo.config.json << EOL
{
  "projectName": "$REPO_NAME",
  "version": "1.0.0"
}
EOL
        
        echo -e "\n${GREEN}Repository successfully linked to Tempo Labs!${NC}"
        echo "Next steps:"
        echo "1. Open the project in Tempo Labs"
        echo "2. Configure any additional settings in the Tempo Labs dashboard"
        ;;
    2)
        # Link existing repository
        read -p "Enter the path to your local repository: " LOCAL_REPO_PATH
        
        if [ ! -d "$LOCAL_REPO_PATH" ]; then
            echo -e "${RED}Error: Directory does not exist.${NC}"
            exit 1
        fi
        
        cd "$LOCAL_REPO_PATH" || exit 1
        
        # Check if it's a git repository
        if [ ! -d ".git" ]; then
            echo -e "${RED}Error: Not a git repository.${NC}"
            exit 1
        fi
        
        # Set up Tempo Labs integration
        echo -e "\n${GREEN}Setting up Tempo Labs integration...${NC}"
        echo "Adding tempo-devtools package..."
        npm install tempo-devtools --save-dev
        
        # Create tempo config file
        echo -e "\nCreating tempo configuration..."
        cat > tempo.config.json << EOL
{
  "projectName": "$REPO_NAME",
  "version": "1.0.0"
}
EOL
        
        echo -e "\n${GREEN}Repository successfully linked to Tempo Labs!${NC}"
        echo "Next steps:"
        echo "1. Open the project in Tempo Labs"
        echo "2. Configure any additional settings in the Tempo Labs dashboard"
        ;;
    *)
        echo -e "${RED}Invalid choice. Please run the script again and select 1 or 2.${NC}"
        exit 1
        ;;
esac

echo -e "\n${YELLOW}Important:${NC}"
echo "To complete the linking process, you'll need to:"
echo "1. Log in to your Tempo Labs account"
echo "2. Go to 'Projects' and select 'Import Repository'"
echo "3. Select your repository and follow the on-screen instructions"

echo -e "\n${GREEN}Done!${NC}"
