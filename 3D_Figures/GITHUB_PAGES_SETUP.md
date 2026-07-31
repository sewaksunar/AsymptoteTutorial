# GitHub Pages Setup Guide

This project is configured to automatically publish documentation to GitHub Pages using Sphinx and GitHub Actions.

## Step 1: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages** (left sidebar)
3. Under "Build and deployment":
   - Source: Select **GitHub Actions**
4. That's it! The workflow will deploy automatically on next push

## Step 2: Update README

Replace the placeholder URLs in `README.md`:

```markdown
**👉 [Read the Course Notes](https://YOUR-USERNAME.github.io/REPOSITORY-NAME/)**
```

With your actual GitHub username and repository name. For example:
```markdown
**👉 [Read the Course Notes](https://john-doe.github.io/numerical-methods/)**
```

## Step 3: First Deployment

1. Commit and push your changes:
```bash
git add .
git commit -m "Set up Sphinx documentation with GitHub Pages"
git push
```

2. Check **Actions** tab on GitHub to see the build process
3. Once complete, your docs will be live at the URL from Step 2

## What Happens Automatically

Every time you push to `main` or `master` branch:
1. GitHub Actions runs the workflow (`.github/workflows/docs.yml`)
2. Sphinx builds the HTML documentation
3. Pages are deployed to GitHub Pages
4. Equations render perfectly with MathJax ✨

## Adding New Content

1. Add or edit `.md` files in the `docs/` folder
2. Update `docs/index.md` to add new pages to the navigation
3. Commit and push
4. Your site updates automatically! 

## Local Testing

Before pushing, test locally:

```bash
cd docs
pip install -r requirements.txt
sphinx-build -b html . _build/html
start _build/html/index.html  # Windows
```

---

**That's it!** Your course notes are now professionally published with proper equation rendering. 🎉
