import geometry;
size(7cm,0);
settings.tex="pdflatex";
import math;


// Define triangle points
pair A = (0,0);
pair B = (3,0);
pair P = (2,3);

// Draw points and labels
dot(A); label("$A$", A, SW, red);
dot(B); label("$B$", B, SE, red);
dot(P); label("$P$", P, N, red);

// Draw triangle sides
draw(A--P, black+1bp);
draw(B--P, black+1bp);

// -------- Perpendicular bisectors --------
// Midpoints of sides
pair M1 = (A + P)/2; // midpoint of AP
pair M2 = (B + P)/2; // midpoint of BP

// Directions perpendicular to the sides
pair dir1 = rotate(90)*(A - P); // perpendicular to AP
pair dir2 = rotate(90)*(P - B); // perpendicular to BP

// Intersection = circumcenter C
pair C = extension(M1, M1 + dir1, M2, M2 + dir2);

// Draw circumcenter
dot(C); label("$C$", C, NE, blue);

// draw perpendicular bisectors for visualization
draw(M1--(M1 + dir1), dashed + gray);
draw(M2--(M2 + dir2), dashed + gray);

// Draw circumcircle
real r = abs(C - A);
draw(circle(C, r), heavygreen);

draw(A--C--B);
// -------- Angle bisector angle
real arcRadius = 0.2;
draw(arc(P, arcRadius, 180+degrees(P-A), 180+degrees(P-B)), blue);
label("$\alpha$", P + 0.3*dir(180+(degrees(P-A)+degrees(P-B))/2), blue);

draw(arc(C, arcRadius, 180+degrees(C-A), 180+degrees(C-B)), blue);
label("$2\alpha$", C + 0.3*dir(180+(degrees(C-A)+degrees(C-B))/2), blue);


class TriangleGeometry(Scene):
    def construct(self):
        # Define points
        A = np.array([0, 0, 0])
        B = np.array([3, 0, 0])
        P = np.array([2, 3, 0])

        # Draw triangle sides
        triangle = Polygon(A, B, P, color=WHITE)
        self.play(Create(triangle))

        # Draw and label points
        A_dot = Dot(A, color=RED)
        B_dot = Dot(B, color=RED)
        P_dot = Dot(P, color=RED)
        labels = VGroup(
            Tex("$A$").next_to(A, DOWN+LEFT, buff=0.1).set_color(RED),
            Tex("$B$").next_to(B, DOWN+RIGHT, buff=0.1).set_color(RED),
            Tex("$P$").next_to(P, UP, buff=0.1).set_color(RED),
        )

        self.play(FadeIn(A_dot, B_dot, P_dot), Write(labels))
        self.wait(0.5)