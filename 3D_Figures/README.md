<<<<<<< HEAD
<apply>
    <int/>
    <bvar>
        <ci>x</ci>
    </bvar>
    <apply>
        <root/>
        <apply>
            <power/>
            <ci>x</ci>
            <cn>-1</cn>
        </apply>
    </apply>
</apply>/
=======
# Numerical Methods - 5th Semester

Professional workspace for University Lab assignments and Lecture scripts.

## � Course Documentation

All course notes with fully rendered LaTeX equations are published on GitHub Pages:

**👉 [Read the Course Notes](https://YOUR-USERNAME.github.io/REPOSITORY-NAME/)**

The documentation includes:
- **Chapter 1:** Solution of Non-Linear Equations (Bisection, Newton-Raphson, Secant, Fixed Point)
- **Chapter 2:** System of Linear Algebraic Equations (Gaussian elimination, Iterative methods, Eigenvalues)
- **Chapter 3:** Interpolation (Lagrange, Newton's divided differences, Stirling & Bessel formulas)

> 📝 To build documentation locally, see [docs/BUILD.md](docs/BUILD.md)

---

## �🚀 Setup
This project uses **uv** for fast dependency management.
1. Install uv: `pip install uv` or `winget install uv`
2. Install dependencies: `uv pip install -r requirements.txt` or `uv sync`
3. Activate environment (if using venv): `.venv\Scripts\Activate.ps1`

## Install any package


## 📁 Structure
- `src/`: Core mathematical algorithms (Bisection, Newton-Raphson, etc.)
- `notebooks/`: Visual analysis and Calculus exploration.
- `data/`: Datasets for curve fitting and interpolation.
- `docs/`: Lab manuals and lecture notes.
```
Numerical-Method/
├── .venv/               # Isolated environment (never touch files here)
├── .vscode/             # Editor-specific settings (linter, interpreter)
├── data/                # Raw and processed datasets (CSV, JSON)
├── docs/                # Project documentation, Lab manuals, or PDFs
├── notebooks/           # Jupyter Notebooks for exploration and plotting
├── tests/               # Unit tests to ensure your math logic is correct
├── src/                 # THE ACTUAL SOURCE CODE
│   └── numerical_methods/
│       ├── __init__.py  # Makes the folder a package
│       ├── solvers/     # Reusable math algorithms
│       └── utils/       # Helper functions (plotting, logging)
├── .gitignore           # Tells Git to ignore .venv and temp files
├── poetry.lock          # Frozen library versions
├── pyproject.toml       # Project metadata and dependencies
└── README.md            # The "Face" of the project (instructions)
```

## 🛠 Tech Stack
- **Python 3.14**
- **NumPy** (Linear Algebra)
- **SciPy** (Optimization/Integration)
- **Matplotlib** (Visualization)


1. **Install uv:**
   ```powershell
   pip install uv
   ```

2. **Create environment & install deps:**
   ```powershell
   uv venv .venv
   .venv\Scripts\Activate.ps1
   uv pip install -r requirements.txt
   ```
   
   Or auto-sync from pyproject.toml:
   ```powershell
   uv sync
   ```

3. **Optional:** Delete poetry.lock (no longer needed) and create `uv.lock` (uv will generate it on first sync).

4. **Run scripts:**
   ```powershell
   python src/numerical_methods/lec3-2.py
   ```

Made changes.
>>>>>>> d3d4ea904ee47029e560e8790c309a9e88b504e2
