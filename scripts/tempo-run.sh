#!/bin/bash

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${YELLOW}PayNomad Capital - Tempo Labs Runner${NC}"
echo "This script helps Tempo Labs run the project from its terminal."

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm is not installed. Please install Node.js and npm first.${NC}"
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo -e "\n${GREEN}Installing dependencies...${NC}"
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to install dependencies.${NC}"
        exit 1
    fi
fi

# Set environment variables for Tempo
export VITE_TEMPO="true"
export TEMPO="true"

# Start the development server
echo -e "\n${GREEN}Starting development server...${NC}"
npm run dev
