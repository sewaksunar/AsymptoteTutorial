import graph;

unitsize(0.055cm);

// ── physical parameters ────────────────────────────────────────
real S     = 50;
real N     = 100;
real omega = 2*pi*N/60;      // = 10π/3 rad/s

real beta_out = 90*pi/180;   // π/2
real beta_ret = 60*pi/180;   // π/3

// a_max = ω² · (S/2) · (π/β)²
real amax_out = omega^2 * S/2 * (pi/beta_out)^2;   // = 10000π²/9  ≈ 10966 mm/s²
real amax_ret = omega^2 * S/2 * (pi/beta_ret)^2;   // = 2500π²     ≈ 24674 mm/s²

// ── layout ────────────────────────────────────────────────────
real xA=0, xS=90, xR=120, xP=180, xX=360;

real plotH = 55;
real yZ    = plotH;
real asc   = plotH / amax_ret;   // scale: mm/s² → plot units

// amax_out in plot units
real y_ao = amax_out * asc;   // ≈ (4/9)·plotH ≈ 24.4

// ── axes ──────────────────────────────────────────────────────
draw((xA, 0)--(xA, 2*plotH+10), black, Arrow(3));
draw((xA, yZ)--(xX+10, yZ),     black, Arrow(3));

label("$O$",      (xA, yZ),     SW, fontsize(8));
label("$\theta$", (xX+10, yZ),   E, fontsize(8));
label(rotate(90)*"Acceleration (mm/s$^2$)", (-28, yZ), fontsize(8));

for(real xv : new real[]{xS,xR,xP,xX})
    draw((xv, 0)--(xv, 2*plotH), gray+dashed+0.5pt);

// ── acceleration curves & discontinuity jumps ──────────────────
int m = 80;

// 1) Outstroke: a = amax_out · cos(π θ / 90°)
//    θ=0  → +amax_out  (starts at top)
//    θ=90° → −amax_out (ends at bottom)
pair[] a1;
for(int i = 0; i <= m; ++i) {
    real th = xS*i/m;
    a1.push((th, yZ + amax_out*cos(pi*i/m)*asc));
}
draw(operator..(...a1), red+2pt);

// Jump at θ=0 (coming from base dwell a=0 → outstroke a=+amax_out)
draw((xA, yZ)--(xA, yZ + y_ao), red+dashed+1pt);

// Jump at θ=90° (outstroke end a=−amax_out → outer dwell a=0)
draw((xS, yZ - y_ao)--(xS, yZ), red+dashed+1pt);

// 2) Outer dwell: a = 0
draw((xS, yZ)--(xR, yZ), red+2pt);

// Jump at θ=120° (outer dwell a=0 → return start a=−amax_ret)
draw((xR, yZ)--(xR, yZ - plotH), red+dashed+1pt);

// 3) Return stroke: a = −amax_ret · cos(π θ' / 60°)
//    θ'=0   → −amax_ret  (starts at bottom)
//    θ'=60° → +amax_ret  (ends at top)
pair[] a2;
for(int i = 0; i <= m; ++i) {
    real th = xR + (xP-xR)*i/m;
    a2.push((th, yZ - amax_ret*cos(pi*i/m)*asc));
}
draw(operator..(...a2), red+2pt);

// Jump at θ=180° (return end a=+amax_ret → base dwell a=0)
draw((xP, yZ + plotH)--(xP, yZ), red+dashed+1pt);

// 4) Base dwell: a = 0
draw((xP, yZ)--(xX, yZ), red+2pt);

// Jump at θ=360° (base dwell end a=0 → next outstroke start a=+amax_out)
draw((xX, yZ)--(xX, yZ + y_ao), red+dashed+1pt);

// ── horizontal dashed reference lines at max values ────────────
draw((xA, yZ + y_ao)  --(xS, yZ + y_ao),   dashed+gray(0.5));   // +amax_out
draw((xA, yZ - y_ao)  --(xS, yZ - y_ao),   dashed+gray(0.5));   // -amax_out
draw((xR, yZ - plotH) --(xP, yZ - plotH),   dashed+gray(0.5));   // -amax_ret
draw((xR, yZ + plotH) --(xP, yZ + plotH),   dashed+gray(0.5));   // +amax_ret

// ── y-axis tick dots ──────────────────────────────────────────
for(real yv : new real[]{yZ+y_ao, yZ-y_ao, yZ+plotH, yZ-plotH})
    dot((xA, yv), gray+linewidth(2));

// ── dimension arrows on right ──────────────────────────────────
// show amax_out
draw((xX+12, yZ)--(xX+12, yZ+y_ao), black+0.7pt, Arrows(4));
label("$f_1{=}"+format("%.0f",amax_out)+"$", (xX+30, yZ+y_ao/2),     fontsize(5.5));
label("mm/s$^2$",                             (xX+30, yZ+y_ao/2-4.5), fontsize(5.5));

// show amax_ret
draw((xX+20, yZ)--(xX+20, yZ-plotH), black+0.7pt, Arrows(4));
label("$f_2{=}"+format("%.0f",amax_ret)+"$", (xX+38, yZ-plotH/2),     fontsize(5.5));
label("mm/s$^2$",                             (xX+38, yZ-plotH/2-4.5), fontsize(5.5));

// ── +/- axis markers ──────────────────────────────────────────
label("$+$", (xA-5, yZ+plotH),  fontsize(7));
label("$-$", (xA-5, yZ-plotH),  fontsize(7));

// ── segment arrows below ───────────────────────────────────────
real brY = -8;
for(real xv : new real[]{xA,xS,xR,xP,xX})
    draw((xv, 0)--(xv, brY), dashed+gray);

draw((xA,brY+2.5)--(xS,brY+2.5), red+0.7pt,       Arrows(4));
draw((xS,brY+2.5)--(xR,brY+2.5), deepgreen+0.7pt,  Arrows(4));
draw((xR,brY+2.5)--(xP,brY+2.5), orange+0.7pt,     Arrows(4));
draw((xP,brY+2.5)--(xX,brY+2.5), purple+0.7pt,     Arrows(4));

label("$90^\circ$ (Outstroke)", ((xA+xS)/2, brY-2), red+fontsize(7));
label("$30^\circ$ (Dwell)",     ((xS+xR)/2, brY-2), deepgreen+fontsize(7));
label("$60^\circ$ (Return)",    ((xR+xP)/2, brY-2), orange+fontsize(7));
label("$180^\circ$ (Dwell)",    ((xP+xX)/2, brY-2), purple+fontsize(7));

label("Angular displacement of cam (degrees)", (xX/2, brY-9), fontsize(8));

label("{\bf Acceleration Diagram -- SHM Follower ($N = 100$ rpm, Stroke $= 50$ mm)}",
      (xX/2, 2*plotH+14), fontsize(9));
