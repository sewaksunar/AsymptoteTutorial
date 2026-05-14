
## Essential Windows Terminal Commands
Always run these commands inside your project directory: D:\Documents\AsymptoteTutorial\AsymptoteTutorial\3D_Figures.
## Direct Asymptote Compilation (Primary Method)

* Ultra-HD Images (Best for lighting, surfaces, shading):

asy -f pdf -noV -render=4 test.asy

* Maximum Crispness for Printing:

asy -f pdf -noV -render=8 test.asy

* Pure Mathematical Vector (Best for flat lines, math grids, text):

asy -f pdf -noV -render=0 test.asy


## High-Quality Conversions via Inkscape (Secondary Method)
If you have an existing test.eps file and want to generate perfectly sharp vector assets, use your Microsoft Store Inkscape installation:

* Convert EPS to Sharp Vector SVG:

inkscape.exe test.eps --export-filename=test.svg

* Convert EPS to Sharp Vector PDF:

inkscape.exe test.eps --export-filename=test.pdf


------------------------------
## 📂 4. Format Cheat Sheet (Export Options)

| Desired Format | Execution Command | Notes / Best Use |
|---|---|---|
| PDF | asy -f pdf -noV -render=4 test.asy | Standard high-quality document output. |
| SVG | asy -f svg -noV -render=0 test.asy | Infinite zoom vector file for modern web browsers. |
| PNG | asy -f png -noV -render=4 test.asy | High-quality image with transparent background support. |
| JPG | asy -f jpg -noV -render=4 test.asy | Standard compressed image file with smaller size. |
| HTML | asy -f html -noV test.asy | Interactive WebGL page; drag to rotate 3D object in browser. |
| PRC | asy -f prc -noV test.asy | Saves raw 3D mesh coordinates for CAD/3D software. |
| EPS | asy -f eps -noV -render=4 test.asy | Traditional vector format explicitly meant for LaTeX. |

------------------------------

