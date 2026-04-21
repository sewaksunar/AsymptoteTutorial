size(5cm);

real R = 0.7;
real r = 0.12;
pair O = (0, R-r);

pen thk   = linewidth(1.2pt);
pen thin  = linewidth(0.8pt);
pen hatch = linewidth(0.7pt);


path dome = arc(O, R, 0, 180)--(-R,0)--(R,0)--cycle;
fill(dome, rgb(0.8, 0.92, 1.0));

path dome_outline = arc(O, R, 0, 180) -- (-R,0) -- (R,0) -- cycle;
draw(dome_outline, thk);

path pin = circle(O, r);
fill(pin, white);
draw(pin, thk);

// draw((-1.2,0)--(1.2,0), thk);
// for(int i=-4; i<=3; ++i)
// draw((i*0.3, 0)--((i+1)*0.3, -0.3), hatch);
// draw("Fixed Joint", (0, -0.5), fontsize(10pt));

fill((-1.6,-0.35)--(1.6,-0.35)--(1.6,0)--(-1.6,0)--cycle, lightgray);
draw((-1.6,0)--(1.6,0), thk);
for(int i=-5; i<=4; ++i)
    draw((i*0.32, 0)--((i+1)*0.32, -0.32), hatch);