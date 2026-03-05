import fontsize;
import patterns;

// layout settings
settings.outformat = "pdf";

// hatch patterns used throughout
add("hatch", hatch());
add("hatchback", hatch(3mm, NW));
add("crosshatch", crosshatch(2mm));

// prepare separate pictures for output
picture sp, velp, accp;

// -----------------------------------------------------------
//  Primary geometry
// -----------------------------------------------------------
currentpicture = sp; // draw geometry into space picture

pair origin = (0,0);
pair pointA = (0,400);
real lengthAB = 150;
real lengthOC = 700;
pair pointB = pointA + lengthAB*dir(135); // 45° left from vertical

// fill to right of OA
fill(origin--(20,0)--(20,400)--pointA--cycle, pattern("hatch"));
draw(origin--pointA);
draw(pointB--pointA);

// mark reference points
for(pair p : new pair[]{origin, pointA, pointB}) {
    dot(p, blue+3pt);
}
label("$O$", origin, SW);
label("$A$", pointA, NE);

// horizontal auxiliary line above A
pair horizon = pointA + (0,300);
draw(horizon + (-80,0) -- horizon + (80,0), dashdotted);

// point C on OB direction with specified length
pair pointC = lengthOC * unit(pointB);
draw(origin--pointC, red);
dot(pointC, blue+3pt);
label("$C$", pointC, NE);

// locate D on horizontal line through horizon so that CD = 200
guide horizSeg = horizon + (-100,0) -- horizon + (20,0);
guide circleC = circle(pointC,200);
pair[] Dpts = intersectionpoints(circleC, horizSeg);
pair pointD;
if (Dpts.length>0) pointD = Dpts[0];
else pointD = horizon;

draw(pointC--pointD, green);
dot(pointD, blue+3pt);
label("$D$", pointD, S);

// rectangle at B oriented along OC
pair dirOC = unit(pointC - origin);
pair perpOC = rotate(90)*dirOC;
real rectB_w = 60, rectB_h = 40;
pair[] Brect = new pair[4];
Brect[0] = pointB - (rectB_w/2)*dirOC - (rectB_h/2)*perpOC;
Brect[1] = pointB + (rectB_w/2)*dirOC - (rectB_h/2)*perpOC;
Brect[2] = pointB + (rectB_w/2)*dirOC + (rectB_h/2)*perpOC;
Brect[3] = pointB - (rectB_w/2)*dirOC + (rectB_h/2)*perpOC;
path rectB = Brect[0] -- Brect[1] -- Brect[2] -- Brect[3] -- cycle;
fill(rectB, lightcyan+opacity(0.4));
draw(rectB);
dot(pointB, red+2pt);
label("$B$", pointB, SW);

// rectangle at D axis-aligned
pair horiz = (1,0), vert = (0,1);
real rectD_w = 60, rectD_h = 40;
pair[] Drect = new pair[4];
Drect[0] = pointD - (rectD_w/2)*horiz - (rectD_h/2)*vert;
Drect[1] = pointD + (rectD_w/2)*horiz - (rectD_h/2)*vert;
Drect[2] = pointD + (rectD_w/2)*horiz + (rectD_h/2)*vert;
Drect[3] = pointD - (rectD_w/2)*horiz + (rectD_h/2)*vert;
path rectD = Drect[0] -- Drect[1] -- Drect[2] -- Drect[3] -- cycle;
fill(rectD, lightred+opacity(0.4));
draw(rectD);
dot(pointD, red+2pt);
label("$D$", pointD, S);

// hatch areas on D rectangle
add("hatchback", hatch(1mm, NW));
path hatchArea1 = Drect[0]+(-20,0) -- Drect[1]+(20,0) -- Drect[1]+(20,-10) -- Drect[0]+(-20,-10) -- cycle;
fill(hatchArea1, pattern("hatchback"));
add("hatchback", hatch(1mm, SE));
path hatchArea2 = Drect[2]+(20,0) -- Drect[3]+(-20,0) -- Drect[3]+(-20,10) -- Drect[2]+(20,10) -- cycle;
fill(hatchArea2, pattern("hatchback"));

// finish space diagram and export without opening viewer
shipout("space", sp, Portrait, "pdf", false, false);

// -----------------------------------------------------------
// Velocity diagram
// -----------------------------------------------------------
currentpicture = velp;

real vScale = 100;
pair vel_origin = origin + (-200,100);
dot("$o, a$", vel_origin);

pair vecBA = pointB - pointA;
pair normalBA = unit(rotate(90)*vecBA);
real velBA_len = 12.57 * 0.15 * vScale;
pair vel_b = vel_origin + velBA_len * normalBA;
draw(vel_origin--vel_b, gray, Arrow(8));
dot("$b$", vel_b, SW);

pair vecOB = pointB - origin;
pair normalOB = unit(rotate(90)*vecOB);
real velOC_temp_len = 300;
pair vel_c_temp = vel_origin + velOC_temp_len * normalOB;
draw(vel_origin--vel_c_temp, gray+dashed);

pair normalBBp = unit(rotate(-90)*(vel_c_temp - vel_origin));
real velBBp_len = 200;
pair vel_b1_temp = vel_b + velBBp_len * normalBBp;
draw(vel_b--vel_b1_temp, gray+dashed);

pair vel_b1 = intersectionpoint(vel_origin--vel_c_temp, vel_b--vel_b1_temp);
dot(vel_b1, blue+3pt);
label("$b1$", vel_b1, NW);
draw(vel_b--vel_b1, gray, Arrow(8));

real len_bb1 = length(vel_b1 - vel_b);
draw(vel_origin--vel_b1, gray, Arrow(8));

pair dirOBp = unit(vel_b1 - vel_origin);
real vel_c_len = (length(pointC-origin)/length(pointB-origin))*length(vel_b1-vel_origin);
pair vel_c = vel_origin + vel_c_len * dirOBp;
draw(vel_origin--vel_c, gray, Arrow(8));
dot("$c$", vel_c, SW);

pair normalCD = unit(rotate(90)*(vel_origin - vel_c));
real velCD_len = 100;
pair vel_d_temp = vel_c + velCD_len * normalCD;
draw(vel_c--vel_d_temp, gray+dashed);

pair vel_d2 = vel_origin - (300,0);
draw(vel_origin--vel_d2, gray+dashed);

pair vel_d = intersectionpoint(vel_c--vel_d_temp, vel_origin--vel_d2);
dot(vel_d, blue+3pt);
label("$d$", vel_d, SW);
draw(vel_c--vel_d, gray, Arrow(8));
draw(vel_origin--vel_d, gray, Arrow(8));

write("$v_{B/B'}=$", len_bb1/vScale);
write("$v_{D}=$", length(vel_origin-vel_d)/vScale);
write("$v_{D/C}=$", length(vel_d-vel_c)/vScale);
write("$v_{C/O}=$", length(vel_c-vel_origin)/vScale);

// export velocity diagram without opening viewer
shipout("velocity", velp, Portrait, "pdf", false, false);

// -----------------------------------------------------------
// Acceleration diagram
// -----------------------------------------------------------
currentpicture = accp;

pair acc_origin = (-400,400);
dot("$o, a$", acc_origin);

real aScale = 10;

pair vecBA_acc = pointB - pointA;
pair unitBA_acc = unit(vecBA_acc);
real aBA_len = 23.7 * aScale;
pair acc_b = acc_origin - aBA_len * unitBA_acc;
draw(acc_origin--acc_b, red, Arrow(8));
dot("$b$", acc_b);
write(acc_b);

pair vecBb = vel_b1 - vel_b;
pair unitCor = unit(rotate(90) * vecBb);
real aCor_len = 6.45 * aScale;
pair acc_x = acc_b + aCor_len * unitCor;
draw(acc_x--acc_b, gray+dashed);
draw(acc_x--acc_b, gray, Arrow(8));
dot("$x$", acc_x, SW);

pair vec_rad = acc_b - acc_x;
pair unit_rad = unit(rotate(90) * vec_rad);
real aRad_len = 20 * aScale;
pair acc_b1 = acc_x + aRad_len * unit_rad;
draw(acc_x--acc_b1, gray+dashed);

pair unitBO = unit(pointB - origin);
real aB1_rad_len = 4.62 * aScale;
pair acc_y = acc_origin - aB1_rad_len * unitBO;
draw(acc_origin--acc_y, gray, Arrow(8));
dot("$y$", acc_y);

pair unit_y = unit(rotate(90) * (acc_y - acc_origin));
real aTang_len = 100;
pair acc_p = acc_y + aTang_len * unit_y;
draw(acc_y--acc_p, gray+dashed);

pair acc_b2 = intersectionpoint(acc_x--acc_b1, acc_y--acc_p);
dot("$b_2$", acc_b2);
draw(acc_y--acc_b2, gray, Arrow(8));

draw(acc_origin--acc_b2, gray);
draw(acc_b2--acc_b, red, Arrow(8));
draw(acc_b2--acc_x, gray, Arrow(8));

pair dir_acc = unit(acc_b2 - acc_origin);
real acc_c_len = (length(pointC-origin)/length(pointB-origin))*length(acc_b2-acc_origin);
pair acc_c = acc_origin + acc_c_len * dir_acc;
dot("$c$", acc_c);
draw(acc_origin--acc_c, gray, Arrow(8));

pair unit_CD = unit(pointC - pointD);
real acc_z_len = 1.01 * aScale;
pair acc_z = acc_c + acc_z_len * unit_CD;
draw(acc_c--acc_z, gray+dashed, Arrow(8));

pair unit_norm = unit(rotate(90) * (acc_z - acc_c));
real acc_d1_len = 50;
pair acc_d1 = acc_z - acc_d1_len * unit_norm;
draw(acc_z--acc_d1, gray+dashed);

pair unit_horiz = unit(rotate(-90) * (pointD + (30,0)));
real acc_d_line_len = 100;
pair acc_d_line = acc_origin + acc_d_line_len * unit_horiz;
draw(acc_origin--acc_d_line, gray+dashed);

pair acc_d = intersectionpoint(acc_z--acc_d1, acc_origin--acc_d_line);
dot("$d$", acc_d);

write(length(acc_y - acc_b2)/aScale);

// export acceleration diagram without opening viewer
shipout("acceleration", accp, Portrait, "pdf", false, false);

