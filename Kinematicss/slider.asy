size(5cm);

real W = 1.4;
real H = 0.7;
real r = 0.12;
real offset = 0.08;
pair O = (0, H/2 + offset);

pen thk   = linewidth(1.2pt);
pen thin  = linewidth(0.8pt);
pen hatch = linewidth(0.7pt);



path box = (-W/2,offset)--(W/2,offset)--(W/2,H+offset)--(-W/2,H+offset)--cycle;
path pin = circle(O, r);
fill(box, rgb(0.8, 0.92, 1.0));
draw(box, thk);
fill(pin, white);
draw(pin, thk);


fill((-1.6,-0.35)--(1.6,-0.35)--(1.6,0)--(-1.6,0)--cycle, lightgray);
draw((-1.6,0)--(1.6,0), thk);
for(int i=-5; i<=4; ++i)
    draw((i*0.32, 0)--((i+1)*0.32, -0.32), hatch);

for(int j=-2; j<=2; ++j)
    fill(circle((j*0.3, offset/2), 0.025), red);


