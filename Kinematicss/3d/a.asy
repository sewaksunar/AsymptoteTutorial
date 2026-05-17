import three;
import graph3;

size(10cm, 0);
// Standard 3D view with Z pointing up
currentprojection = orthographic(5, 2, 3, up=Z); 

// 1. Define coordinate axes (Torque=X, Precession=Y, Spin=Z)
real axisLen = 3.5;
draw(O -- axisLen*X, Arrow3(DefaultHead2), L=Label("Torque axis ($M$)", position=EndPoint, align=W));
draw(O -- axisLen*Y, Arrow3(DefaultHead2), L=Label("Precession axis ($\Omega$)", position=EndPoint, align=E));
draw(O -- axisLen*Z, Arrow3(DefaultHead2), L=Label("Spin axis ($p$)", position=EndPoint, align=N));

// 2. Create the Rotor and Axle
// The Axle (thin cylinder along Z)
real axleH = 4;
surface axle = shift(0,0,-axleH/2) * scale(0.05, 0.05, axleH) * unitcylinder;
draw(axle, gray);

// The Rotor Disk (central disk)
real rotorR = 1.5, rotorT = 0.3;
surface rotor = shift(0,0,-rotorT/2) * scale(rotorR, rotorR, rotorT) * unitcylinder;
draw(rotor, lightgray);

// 3. Spin Velocity (p) - FIXED GEOMETRY
// The arc is centered at height z=1.8 to be in-plane with its points
triple c_spin = (0,0,1.8);
path3 spinArc = arc(c=c_spin, v1=(0, 1.2, 1.8), v2=(1.2, 0, 1.8), normal=Z);
draw("$p$", spinArc, blue, Arrow3(DefaultHead2, emissive(blue)));

// 4. Precession Velocity (Omega)
// This arc lies in the XZ plane, centered at origin, normal is Y
path3 precessArc = arc(c=O, v1=(1.8, 0, 1.2), v2=(1.2, 0, 1.8), normal=Y);
draw("$\Omega$", precessArc, heavygreen, Arrow3(DefaultHead2, emissive(heavygreen)));

// 5. Forces forming the Torque Couple (M)
real forceLen = 1.2;
triple topAxle = (0, 0, axleH/2);
triple botAxle = (0, 0, -axleH/2);

// Top Force in -Y direction, Bottom Force in +Y direction creates Moment along +X
draw(topAxle -- (topAxle - forceLen*Y), red, Arrow3, L=Label("$F$", position=EndPoint));
draw(botAxle -- (botAxle + forceLen*Y), red, Arrow3, L=Label("$F$", position=EndPoint));

// 6. Labels and Data
label("$M = \Omega \times H$", 2*X, S);

// Layering: Move annotation slightly toward camera to prevent clipping [2, 3]
label(minipage("\centering \textbf{Gyroscopic Precession}\\ $M = \text{Couple Formed by } F$"), 
      (2.5, 2.5, 2.5));