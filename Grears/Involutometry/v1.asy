settings.outformat = "pdf";
import fontsize;
import geometry;


path bountry = square((0,0), 20cm);
draw(bountry, dashed+gray);

pair center = (10 cm, 10 cm);
real radius = 5 cm;
draw(circle(center, radius), black+1.5pt);
dot("$O$", center, S);

pair ptA = center + radius*dir(45);
dot("$A$", ptA, W);

// vertical from O
pair ptV = center + 2*radius*dir(90);
dot("$V$", ptV, N);
draw(center--ptV, black+1.5pt+dashed);


// tangent from A to circle
pair perpAO = unit(center - ptA)*dir(90);
pair ptT = ptA - 1.5*radius*perpAO;
dot("$T$", ptT, N);
draw(ptA--ptT, black+1.5pt);
