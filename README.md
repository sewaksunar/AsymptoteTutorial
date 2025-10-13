# AsymptoteTutorial
A student-led exploration of 2D and 3D graphics, mathematical figures, and animations using Asymptote. This repository documents my personal learning journey and aims to help other students and educators understand how to create clear, scalable diagrams for math, science, and technical communication.

# File Strucures / Diretrix
AsymptoteTutorial/
|--- README.md                  # Project overview and usage instructions
|---LICENSE.md                   # Licensing information (e.g., CC BY-NC 4.0)
|--- Reference              # Reference for drawing shapes or for cloning
|---2D_Figures/              # Basic and annotated 2D diagrams
│   |--- 1-1.asy
│   |--- 1-2.asy
│   |--- ...
├── 2D_Graphs/                # Function plots and parametric curves
│   ├── function_plots.asy
│   ├── parametric_curves.asy
│   └── ...
├── 3D_Figures/               # Solid shapes and projections
│   ├── solids.asy
│   ├── projections.asy
│   └── ...
├── 3D_Graphs/                # Surface plots and contour diagrams
│   ├── surfaces.asy
│   ├── contour_plots.asy
│   └── ...
├── Animations/               # Dynamic visualizations and shape morphing
│   ├── rotating_cube.asy
│   ├── morphing_shapes.asy
│   └── ...
└── assets/                   # Supporting media files
    ├── images/
    └── gifs/

# Build

## Simple way to compile Asymptote file is:

```
asy figname.asy //or simply figname
```

## To export as ```html``` or ```svg``` or etc. 

```
asy -f html filename
```