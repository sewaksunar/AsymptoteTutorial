import animate;
size(200,100);

animation a;

int n = 30; // number of frames
real dx = 0.3;

for (int i = 0; i < n; ++i) {
    picture pic;
    draw(pic, (-1,0)--(10,0), Arrow);
    dot(pic, (i*dx, 0), red);
    label(pic, "$x$", (10.2, 0));
    a.add(pic);
}

// Correct syntax:
save(a, "motion.mp4", fps=10);
