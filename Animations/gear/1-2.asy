// include "config.asy";

import animation;
import graph;

unitsize(1cm);
size(10cm, 10cm);

string ssign(int d) {
	return d > 0 ? "+" : "-";
}

// Rename identifiers that start with digits to valid names: O_R and O_r
transform T1(real phi, pair O_R) { // (2)
	return rotate(angle=phi, z=O_R);
}

transform T2(real phi, int sign, real k, pair O_r) { // (4)
	return rotate(angle=sign*phi/k, z=O_r);
}

pen BigCircle = blue;
pen littleCircle = deepgreen;
pen curve = red;

int sign = -1; // (6)
real R = 4.0;
real r = 2.0;
real d = 2.0;
real k = r/R;
int N = 100; // (8)
pair O_R = (0, 0);
int turns = 1; // (10)
usersetting(); // (12)

pair O_r = O_R + polar(R + sign * r, 0); // (14)
pair P = O_r + polar(d, 0); // (16)
pair Q = O_r - sign * polar(r, 0); // (18)

guide xcycloid = origin--origin; // initialize a guide/path
transform T;

animation A; // (20)
A.global = true;

draw(circle(c=O_R, r=R), p=BigCircle); // (22)
dot(O_R, p=BigCircle);

for(real phi: uniform(0, 360*turns, N) ) {
	// build nothing here - main loop below handles frames
}

for(real phi: uniform(0, 360*turns, N) ) {
	save(); // (24)
	T = T1(phi, O_R) * T2(phi, sign, k, O_r); // (26)
	xcycloid = xcycloid -- T*P; // (28)
	draw(xcycloid, p=1bp+curve); // (30)
	dot(T*P, L=Label("P", align=NW)); // (32)
	draw(O_R -- T*O_r, L=Label("R"+ssign(sign)+"r")); //(34)
	draw(T*O_r -- T*P, L=Label("d"));
	draw(circle(c=T*O_r, r=r), p=littleCircle); // (36)
	dot(T*O_r, p=littleCircle);
	dot(T1(phi, O_R)*Q, p=littleCircle); // (38)

	include "../2D_Figures/texput.aux"; // include axes or helper (adjusted path)

	A.add(); //(42)
	restore(); // (44)
}

A.movie(); // (46)
currentpicture.erase();
