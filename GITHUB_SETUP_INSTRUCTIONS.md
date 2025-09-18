# GitHub Repository Setup Instructions

Follow these steps to complete the GitHub setup for your Sitara777 Admin Panel:

## Step 1: Create a New Repository on GitHub

1. Go to https://github.com and log in to your account
2. Click the "+" icon in the top right corner and select "New repository"
3. Enter the repository name: `sitara777`
4. Choose public or private as desired
5. **Important**: Leave all checkboxes unchecked (no README, no .gitignore, no license)
6. Click "Create repository"

## Step 2: Note Your Repository URL

After creating the repository, you'll see a page with setup instructions. Note your repository URL, which will look like:
```
https://github.com/YOUR_USERNAME/sitara777.git
```

## Step 3: Update Remote Origin (if needed)

If your username is different from "yourusername", update the remote origin:

```bash
git remote set-url origin https://github.com/YOUR_USERNAME/sitara777.git
```

## Step 4: Push to GitHub

Push your local repository to GitHub:

```bash
git push -u origin main
```

## Step 5: Verify the Push

Visit your repository on GitHub to verify that all files have been uploaded successfully.

## Step 6: Deploy to Render

Once your code is on GitHub, you can deploy to Render:

1. Go to https://dashboard.render.com
2. Click "New" and select "Blueprint"
3. Connect your GitHub repository
4. Select the `render.yaml` file from the backend directory
5. Click "Apply" to deploy both services

## Troubleshooting

### Authentication Issues
If you encounter authentication issues:
1. Use GitHub CLI: `gh auth login`
2. Or use a Personal Access Token instead of password

### Remote Already Exists
If you get an error about remote already existing:
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/sitara777.git
```

### Branch Name Issues
This repository uses "main" as the default branch. If you need to change it:
```bash
git branch -M main
```

## Next Steps

After successfully pushing to GitHub:
1. Set up auto-deployment on Render
2. Configure environment variables in Render dashboard
3. Update the JWT_SECRET with a strong secret key
4. Test your deployed application

For detailed deployment instructions, refer to `AUTOMATIC_DEPLOYMENT_GUIDE.md`.