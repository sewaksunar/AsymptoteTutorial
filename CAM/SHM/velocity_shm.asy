import graph;

unitsize(0.055cm);

// ── physical parameters ────────────────────────────────────────
real S     = 50;             // stroke, mm
real N     = 100;            // rpm
real omega = 2*pi*N/60;      // angular velocity of cam shaft, rad/s  (= 10π/3)

real beta_out = 90*pi/180;   // outstroke cam angle in rad  (π/2)
real beta_ret = 60*pi/180;   // return stroke cam angle in rad  (π/3)

// v_max = ω · (S/2) · (π/β)
real vmax_out = omega * S/2 * pi/beta_out;   // = 500π/3  ≈ 523.6 mm/s
real vmax_ret = omega * S/2 * pi/beta_ret;   // = 250π    ≈ 785.4 mm/s

// ── x (degrees) and y (velocity) axis layout ──────────────────
real xA=0, xS=90, xR=120, xP=180, xX=360;

real plotH = 55;          // half-height in plot units
real yZ    = plotH;       // y-coordinate of the zero line
real vsc   = plotH / vmax_ret;   // scale: mm/s → plot units

// ── axes ──────────────────────────────────────────────────────
draw((xA, 0)--(xA, 2*plotH+10), black, Arrow(3));
draw((xA, yZ)--(xX+10, yZ),     black, Arrow(3));

label("$O$",         (xA, yZ),          SW, fontsize(8));
label("$\theta$",    (xX+10, yZ),        E, fontsize(8));
label(rotate(90)*"Velocity (mm/s)", (-25, yZ), fontsize(8));

// vertical segment boundaries
for(real xv : new real[]{xS,xR,xP,xX})
    draw((xv, 0)--(xv, 2*plotH), gray+dashed+0.5pt);

// ── velocity curves ────────────────────────────────────────────
int m = 80;

// 1) Outstroke: v = v_max_out · sin(π θ / 90°)  → positive half-sine arch
pair[] v1;
for(int i = 0; i <= m; ++i) {
    real th = xS*i/m;
    v1.push((th, yZ + vmax_out*sin(pi*i/m)*vsc));
}
draw(operator..(...v1), red+2pt);

// 2) Outer dwell: v = 0
draw((xS, yZ)--(xR, yZ), red+2pt);

// 3) Return stroke: v = −v_max_ret · sin(π θ' / 60°)  → negative half-sine arch
pair[] v2;
for(int i = 0; i <= m; ++i) {
    real th = xR + (xP-xR)*i/m;
    v2.push((th, yZ - vmax_ret*sin(pi*i/m)*vsc));
}
draw(operator..(...v2), red+2pt);

// 4) Base dwell: v = 0
draw((xP, yZ)--(xX, yZ), red+2pt);

// ── dashed reference lines at peak velocities ──────────────────
draw((xA,  yZ + vmax_out*vsc)--(xS,  yZ + vmax_out*vsc), dashed+gray(0.5));
draw((xR,  yZ - vmax_ret*vsc)--(xP,  yZ - vmax_ret*vsc), dashed+gray(0.5));

// y-axis tick dots and primed labels
dot((xA, yZ + vmax_out*vsc), gray+linewidth(2));
dot((xA, yZ - vmax_ret*vsc), gray+linewidth(2));

// ── dimension arrows on right ──────────────────────────────────
draw((xX+12, yZ)--(xX+12, yZ + vmax_out*vsc), black+0.7pt, Arrows(4));
label("$v_1 = "+format("%.1f",vmax_out)+"$", (xX+28, yZ + vmax_out*vsc/2), fontsize(6));
label("mm/s", (xX+28, yZ + vmax_out*vsc/2 - 4), fontsize(6));

draw((xX+12, yZ)--(xX+12, yZ - vmax_ret*vsc), black+0.7pt, Arrows(4));
label("$v_2 = "+format("%.1f",vmax_ret)+"$", (xX+28, yZ - vmax_ret*vsc/2), fontsize(6));
label("mm/s", (xX+28, yZ - vmax_ret*vsc/2 - 4), fontsize(6));

// small + / - axis markers
label("$+$", (xA-4, yZ + vmax_out*vsc), fontsize(7));
label("$-$", (xA-4, yZ - vmax_ret*vsc), fontsize(7));

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

label("{\bf Velocity Diagram -- SHM Follower ($N = 100$ rpm, Stroke $= 50$ mm)}",
      (xX/2, 2*plotH+14), fontsize(9));
