#!/bin/bash

# Clean and Push Script for PayNomad Capital Ltd
# This script cleans the repository and pushes to the specified remote

echo "🧹 Starting repository cleanup..."

# Remove storyboard files
echo "Removing storyboard files..."
rm -rf src/tempobook/storyboards/*
rm -rf src/tempobook/dynamic/*

# Remove Supabase migration files
echo "Removing Supabase migration files..."
rm -rf supabase/migrations/*

# Remove MagicLinks-related files
echo "Removing MagicLinks-related files..."
find . -type f -name "*MagicLink*" -delete

# Add remote repository if it doesn't exist
if ! git remote | grep -q origin; then
  echo "Adding remote repository..."
  git remote add origin https://github.com/tevalerie/PayNomad-Capital-Ltd-Final
fi

# Stage all changes
echo "Staging changes..."
git add .

# Commit changes
echo "Committing changes..."
git commit -m "Clean repository for deployment"

# Push to remote repository
echo "Pushing to remote repository..."
git push -u origin main

echo "✅ Repository cleaned and pushed to remote!"
