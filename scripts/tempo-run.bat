@echo off
setlocal enabledelayedexpansion

echo PayNomad Capital - Tempo Labs Runner
echo This script helps Tempo Labs run the project from its terminal.

:: Check if npm is installed
npm --version > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: npm is not installed. Please install Node.js and npm first.
    exit /b 1
)

:: Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo.
    echo Installing dependencies...
    npm install
    if %ERRORLEVEL% neq 0 (
        echo Error: Failed to install dependencies.
        exit /b 1
    )
)

:: Set environment variables for Tempo
set VITE_TEMPO=true
set TEMPO=true

:: Start the development server
echo.
echo Starting development server...
npm run dev
