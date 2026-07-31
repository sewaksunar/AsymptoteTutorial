# Troubleshooting GitHub Actions Build Failures

If you see "All checks have failed" on GitHub, follow these steps:

## Step 1: Check the Build Logs

1. Go to your GitHub repository
2. Click the **Actions** tab
3. Find the failed workflow run
4. Click on it to see detailed logs
5. Look for error messages in the logs

## Step 2: Common Issues & Fixes

### Issue: "Sphinx not found" or import errors
**Solution:** Ensure `docs/requirements.txt` has all dependencies. Check that Python version is 3.10+.

### Issue: "toctree missing referenced document"
**Solution:** Make sure all files referenced in `index.md` exist:
- ✅ `docs/chapter1.md`
- ✅ `docs/chapter2.md`
- ✅ `docs/chapter3.md`

### Issue: "Unknown directive" or markdown parsing errors
**Solution:** Check that `myst-parser` is in requirements.txt and MyST extensions are enabled in `conf.py`.

### Issue: "reference target not found"
**Solution:** Some markdown links may have syntax issues. Check for:
- Missing `.md` extensions in links
- Broken cross-references

## Step 3: Test Locally First

Before pushing to GitHub, test locally:

```powershell
cd docs
pip install -r requirements.txt
sphinx-build -b html . _build/html
```

If this works locally but fails on GitHub, the issue is likely:
- Different Python version
- Missing file or typo in filenames

## Step 4: If Still Failing

Try these fixes in order:

**Option A: Simplify requirements.txt**
```
sphinx>=7.0.0
sphinx-rtd-theme>=1.3.0
myst-parser>=1.0.0
```

**Option B: Update conf.py**
- Ensure `master_doc = 'index'` is set
- Check that theme name is correct: `sphinx_rtd_theme`

**Option C: Verify index.md**
The toctree should match your filenames exactly:
```markdown
```{toctree}
:maxdepth: 2

chapter1
chapter2
chapter3
```
```

## Step 5: View Detailed Errors

Add this line to `.github/workflows/docs.yml` under "Build documentation" to see verbose output:

```yaml
sphinx-build -b html -v . _build/html
```

Then check the Actions logs again for specific error messages.

---

**Still stuck?** The error message in the GitHub Actions log is key - share that and we can diagnose further!
