# Building Documentation Locally

This documentation is built using **Sphinx** with the Read the Docs theme. All LaTeX equations render perfectly using MathJax.

## Prerequisites

- Python 3.8+
- pip (Python package manager)

## Setup Instructions

### 1. Install Dependencies

```bash
pip install -r docs/requirements.txt
```

### 2. Build HTML Documentation

Navigate to the docs folder and build:

```bash
cd docs
sphinx-build -b html . _build/html
```

### 3. View Documentation

Open the built documentation in your browser:

```bash
# Windows
start _build/html/index.html

# macOS
open _build/html/index.html

# Linux
xdg-open _build/html/index.html
```

## Automatic Rebuilding

For development, you can use `sphinx-autobuild` to automatically rebuild when files change:

```bash
pip install sphinx-autobuild
sphinx-autobuild . _build/html
```

Then visit `http://localhost:8000` in your browser.

## File Structure

```
docs/
├── conf.py              # Sphinx configuration
├── index.md             # Main page
├── chapter1.md          # Chapter 1: Non-Linear Equations
├── chapter2.md          # Chapter 2: Linear Systems
├── chapter3.md          # Chapter 3: Interpolation
├── requirements.txt     # Python dependencies
└── .nojekyll           # GitHub Pages configuration
```

## GitHub Pages Deployment

When you push to GitHub (main/master branch), a GitHub Actions workflow automatically:

1. Builds the documentation with Sphinx
2. Deploys it to GitHub Pages
3. Makes it available at `https://<username>.github.io/<repo>/`

Enable GitHub Pages in your repository settings (if not already enabled).

## Adding New Chapters

1. Create a new `.md` file in the `docs/` folder
2. Add it to the `toctree` in `index.md`:

```markdown
```{toctree}
:maxdepth: 2
:caption: Course Content

chapter1
chapter2
chapter3
chapter4  # New chapter
```
```

3. Push to trigger automatic rebuild

## Troubleshooting

**Issue:** Sphinx can't find myst_parser  
**Solution:** Make sure you installed `myst-parser`: `pip install myst-parser`

**Issue:** Math equations not rendering  
**Solution:** The MathJax CDN link is in `conf.py`. Ensure you have internet connectivity.

**Issue:** `.md` files not converting properly  
**Solution:** Check file format in `conf.py` - ensure `source_suffix` includes `.md: 'markdown'`

---

For more Sphinx documentation, visit: https://www.sphinx-doc.org/
