# Repository Linking Guide for PayNomad Capital

## Overview

This guide explains how to link your PayNomad Capital repository to be managed by Tempo Labs, ensuring you have the same development experience across all your projects.

## Prerequisites

- Git installed on your machine
- Node.js and npm installed
- GitHub account with access to your repository
- Tempo Labs account

## Option 1: Using the Provided Scripts

We've created scripts to automate the linking process:

### For macOS/Linux Users:

1. Open Terminal
2. Navigate to your project directory
3. Run the script:
   ```bash
   chmod +x scripts/link-repository.sh
   ./scripts/link-repository.sh
   ```
4. Follow the on-screen instructions

### For Windows Users:

1. Open Command Prompt
2. Navigate to your project directory
3. Run the script:
   ```cmd
   scripts\link-repository.bat
   ```
4. Follow the on-screen instructions

## Option 2: Manual Setup

If you prefer to set up the integration manually:

1. **Clone your repository** (if not already done):
   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo
   ```

2. **Install Tempo devtools**:
   ```bash
   npm install tempo-devtools --save-dev
   ```

3. **Update your Vite configuration** (vite.config.ts):
   ```typescript
   import { tempo } from "tempo-devtools/dist/vite";
   
   // Add to your plugins array
   plugins: [
     // other plugins
     tempo(),
   ],
   server: {
     // @ts-ignore
     allowedHosts: process.env.TEMPO === "true" ? true : undefined
   }
   ```

4. **Initialize Tempo in your main file** (main.tsx or main.jsx):
   ```typescript
   import { TempoDevtools } from "tempo-devtools"
   TempoDevtools.init();
   ```

5. **Add error handling script** to your index.html:
   ```html
   <script src="https://api.tempo.new/proxy-asset?url=https://storage.googleapis.com/tempo-public-assets/error-handling.js"></script>
   ```

6. **Update your routing** to support Tempo storyboards:
   ```typescript
   import { useRoutes } from "react-router-dom";
   import routes from "tempo-routes";
   
   // Inside your App component
   const tempoRoutes = import.meta.env.VITE_TEMPO === "true" ? useRoutes(routes) : null;
   
   return (
     <>
       {tempoRoutes}
       <Routes>
         {/* Your routes */}
         
         {/* Add this before any catchall route */}
         {import.meta.env.VITE_TEMPO === "true" && <Route path="/tempobook/*" />}
       </Routes>
     </>
   );
   ```

7. **Update .gitignore** to exclude Tempo-specific files:
   ```
   **/tempobook/dynamic/
   **/tempobook/storyboards/
   ```

## Connecting to Tempo Labs

After setting up your repository:

1. Log in to your Tempo Labs account
2. Go to Projects and select "Import Repository"
3. Select your repository from the list
4. Follow the on-screen instructions to complete the setup

## Troubleshooting

If you encounter any issues during setup:

1. Ensure all dependencies are correctly installed
2. Check that your vite.config.ts has the correct configuration
3. Verify that your routing setup includes the Tempo routes
4. Make sure your GitHub account has the necessary permissions

For additional help, contact Tempo Labs support or ask me for assistance with specific errors.
