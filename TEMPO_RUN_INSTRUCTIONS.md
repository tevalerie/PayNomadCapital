# Running PayNomad Capital in Tempo Labs

This document provides instructions for running the PayNomad Capital project from the Tempo Labs terminal.

## Prerequisites

- Node.js and npm installed
- Git installed

## Running the Project

### Option 1: Using the Provided Scripts

#### For macOS/Linux:

1. Open the Tempo Labs terminal
2. Run the following command:
   ```bash
   ./scripts/tempo-run.sh
   ```

#### For Windows:

1. Open the Tempo Labs terminal
2. Run the following command:
   ```cmd
   scripts\tempo-run.bat
   ```

### Option 2: Manual Steps

If you prefer to run the commands manually:

1. Install dependencies (if not already installed):
   ```bash
   npm install
   ```

2. Set the Tempo environment variables:
   ```bash
   # For macOS/Linux
   export VITE_TEMPO="true"
   export TEMPO="true"
   
   # For Windows
   set VITE_TEMPO=true
   set TEMPO=true
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

## Troubleshooting

If you encounter any issues:

1. Make sure all dependencies are installed correctly
2. Check that the Tempo environment variables are set
3. Verify that the development server is running on the correct port
4. Check the console for any error messages

## Additional Commands

- Build the project: `npm run build`
- Preview the built project: `npm run preview`
- Run linting: `npm run lint`
