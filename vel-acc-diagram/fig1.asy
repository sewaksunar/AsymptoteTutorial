import fontsize;
import patterns;

// define hatch patterns for later use
add("hatch",hatch());
// hatch takes (spacing, direction) so supply 3mm then NW
add("hatchback",hatch(3mm, NW));
add("crosshatch",crosshatch(2mm));

settings.outformat="pdf";

pair O = (0,0);
pair A = (0,400);
real ab = 150;
real oc = 700;
pair B = A + ab*dir(45+90);

// vertical radius from O to A
// fill the region to the right of OA with a hatch pattern
// (choose a reasonable horizontal extent for visualization)
fill(O--(20,0)--(20,400)--A--cycle, pattern("hatch"));
draw(O--A);
// draw AB which is at 45° to AO on the left side (starting from A)
draw(B--A);

// mark and label points
for(pair P : new pair[]{O,A,B}) {
    dot(P, blue+3pt);
}
label("$O$", O, SW);
label("$A$", A, NE);

// horizontal dashed line 300 units long ending at A
pair H = A + (0, 300);      // the line has constant y = H.y
draw(H+(-80, 0)--H+(80, 0), dashdotted);

// --- new material ----------------------------------------------
// C is on the ray from O through B; OC has length 700
pair C = oc*unit(B);         // unit(B) is the direction of OB
// draw the radius OC
draw(O--C, red);

dot(C, blue+3pt);
label("$C$", C, NE);

// find a point D on the horizontal line through H such that CD = 200
guide L = H+(-100,0) -- H+(20,0);         // the dashed horizontal segment
guide circ = circle(C, 200);              // circle centered at C, radius 200
pair[] Ds = intersectionpoints(circ, L);  // intersection(s) of the circle with L

pair D;
if (Ds.length > 0) {
    // pick the first intersection; you can choose Ds[1] if you prefer the other
    D = Ds[0];
} else {
    // no intersection (the circle does not meet the segment); fall back
    D = H;
}

draw(C--D, green);          // crank CD
dot(D, blue+3pt);
label("$D$", D, S);

// optional: draw the circle for reference
// draw(circ, dashed+white);

// place rectangle parallel to OC centred at B
// direction along OC and a perp‑direction
pair u = unit(C - O);            // same as unit(C) since O=(0,0)
pair v = rotate(90)*u;

// size of the little rectangle (full lengths)
real rw = 60;                    // length parallel to OC
real rh = 40;                    // length perpendicular to OC

// compute four corners centered at B
pair P1 = B - (rw/2)*u - (rh/2)*v;
pair P2 = B + (rw/2)*u - (rh/2)*v;
pair P3 = B + (rw/2)*u + (rh/2)*v;
pair P4 = B - (rw/2)*u + (rh/2)*v;

path rect = P1 -- P2 -- P3 -- P4 -- cycle;

fill(rect, lightcyan+opacity(0.4));
draw(rect);
// mark centre for clarity
dot(B, red+2pt);
label("$B$", B, SW);

// ---------- rectangle at D parallel to horizontal ----------
// horizontal direction and vertical perp
pair uH = (1,0);
pair vH = (0,1);

real rw2 = 60;   // width along horizontal
real rh2 = 40;   // height vertical

pair Q1 = D - (rw2/2)*uH - (rh2/2)*vH;
pair Q2 = D + (rw2/2)*uH - (rh2/2)*vH;
pair Q3 = D + (rw2/2)*uH + (rh2/2)*vH;
pair Q4 = D - (rw2/2)*uH + (rh2/2)*vH;

path rect2 = Q1 -- Q2 -- Q3 -- Q4 -- cycle;
fill(rect2, lightred+opacity(0.4)); draw(rect2);
// label D center
dot(D, red+2pt);
label("$D$", D, S);
add("hatchback",hatch(1mm, NW));
path rectt = Q1+(-20, 0) -- Q2 +(20, 0) -- Q2+(20, -10) -- Q1+(-20, -10)--cycle;
fill(rectt, pattern("hatchback"));
add("hatchback",hatch(1mm, SE));
path rectt = Q3+(20, 0) -- Q4+(-20, 0) -- Q4+(-20, 10) -- Q3+(20, 10)--cycle;
fill(rectt, pattern("hatchback"));


// #########
// Velocity diagram
//#############

real scale = 100;
// polar point
pair o = O + (-200, 100);
dot("$o, a$", o);

// vBA , oa liine
pair v = B - A;
pair n = unit(rotate(90)*v);
real len =  12.57 * 0.15 * scale; //velocity V_BA = omega * AB
pair b = o + len*n;
draw(o -- b, gray, Arrow(8));
dot("$b$", b, SW);

//// ob construction 
pair v = B - O;
pair n = unit(rotate(90)*v);
real len = 300; // velocity VCO = omegaB'O * OC
pair c = o + len*n;
draw(o -- c, gray+dashed);

// VBB', bb'
pair v = c-o;
pair n = unit(rotate(-90)*v);
real len = 200; //say
pair b1 = b + len*n;
draw(b--b1, gray+dashed);

// find intersection of oc and bb1 line
pair b1 = intersectionpoint(o--c, b--b1);
dot(b1, blue+3pt);
label("$b'$", b1, NW);
draw(b--b1, gray, Arrow(8));


// find the length of bb' line
real len_bb1 = length(b1 - b);

// vB'O, ob line 
draw(o -- b1, gray, Arrow(8));

// oc
pair v = b1-o;
pair n = unit(v);
real len =  (700/length(O-B))*length(b1-o);///oc = OC/OB' * ob'
pair c = o + len*n;
draw(o--c, gray, Arrow(8));
dot("$c$", c, SW);

// cd construciton
pair v = o-c;
pair n = unit(rotate(90)*v);
real len = 100;
pair d1 = c + len*n;
draw(c--d1, gray+dashed);

// od construxtion
pair v = o;
real len = 300;
pair d2 = v - (len, 0);
draw(o--d2, gray+dashed);


// find intersection of od and cd
pair d = intersectionpoint(c--d1, o--d2);
dot(d, blue+3pt);
label("$d$", d, SW);

draw(c--d, gray, Arrow(8));
draw(o--d, gray, Arrow(8));

write("$v_{B/B'}=$", len_bb1/scale);
write("$v_{D}=$", length(o-d)/scale);
write("$v_{D/C}=$", length(d-c)/scale);
write("$v_{C/O}=$", length(c-o)/scale);




/// Acccleration diagram
//polar point
pair o = (-400,400);
dot("$o, a$", o);

scale = 10;

// normal component of VB/A
pair v = B - A;
pair u = unit(v);
real len =  23.7*scale;
pair a_b = o - len*u;
draw(o--a_b, red, Arrow(8));
dot("$b$", a_b);
write(a_b);

// The acceleration of slider 𝐵 relative to coincident point 𝐵′ on link 𝑂𝐶 has two
//perpendicular components
// bx corolis component
pair v = b1 -b;
pair n = unit(rotate(90)*v);
real len =  6.45 * scale;
pair x = a_b + len*n;
draw(x -- a_b, gray+dashed);
draw(x--a_b, gray, Arrow(8));
dot("$x$", x, SW);

//radia component 
pair v = a_b - x ;
pair n = unit(rotate(90)*v);
real len =  20 * scale;
pair a_b1 = x + len*n;
draw(x -- a_b1, gray+dashed);

//acceleration of coincident point 𝐵′ with respect to 𝑂 
// radia comp
pair v = B - O;
pair u = unit(v);
real len = 4.62 * scale;
pair y = o - len*u;
draw(o--y, gray, Arrow(8));
dot("$y$", y);

// tangential comp
pair v = y -o;
pair n = unit(rotate(90)*v);
real len = 100;
pair p =y+len*n;
draw(y--p, gray+dashed);

// locate a_b1
pair a_b1 = intersectionpoint(x--a_b1, y--p);
dot("$b_2$", a_b1);
draw(y--a_b1, gray, Arrow(8));

// draw
draw(o--a_b1, gray);

draw(a_b1--a_b, red, Arrow(8));

draw(a_b1--x, gray, Arrow(8));

// locate c
pair v = a_b1 - o;
pair u = unit(v);
real len = (length(C-O)/length(B-O))*length(a_b1 - o);
pair c = o + len * u;
dot("$c$", c);
draw(o--c, gray, Arrow(8));

//locating z: acceleration of ram 𝐷 relative to 𝐶 has two perpendicular components:

//raida comp
pair v = C - D;
pair u = unit(v);
real len = 1.01 * scale;
pair z = c + len*u;
draw(c--z,  gray+dashed, Arrow(8));

//normal 
pair v = z - c;
pair n = unit(rotate(90)*v);
real len = 50;
pair d1 = z - len * n;
draw(z--d1, gray+dashed);

// acceleration of D
pair v = D + (30, 0);
pair u = unit(rotate(-90)*v);
real len = 100;
pair d = o + len*u;
draw(o--d, gray+dashed);

pair d = intersectionpoint(z--d1, o--d);
dot("$d$", d);

// tangential component of the acceleration of coincident point 𝐵′ with respect to 𝑂  = yb1
write(length(y-a_b1)/scale);