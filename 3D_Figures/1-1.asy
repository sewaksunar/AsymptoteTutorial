settings.outformat = "html";
settings.prc = false;
size(5cm);
import three;
// set a camera so the 3D scene is well-defined
currentprojection = orthographic(camera=(5,4,2));
draw(unitsphere);
// explicitly ship out the current picture to ensure a PDF is written
shipout();
shipout();