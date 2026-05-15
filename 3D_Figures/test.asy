import three;

// 1. Automatically loads the interactive camera view saved from your GUI
include outcamera; 

// 2. Extract specific vector elements from your interactive position
triple cam_pos = currentprojection.camera;
triple target_pos = currentprojection.target;

// 3. Perform calculations relative to the interactive camera view
triple view_direction = unit(target_pos - cam_pos); 
real distance_to_origin = abs(cam_pos);

// 4. Output or draw your calculated geometry
write("Interactive Camera Position: ", cam_pos);
write("Vector Direction: ", view_direction);
write("Distance to World Center: ", distance_to_origin);

// Example: Draw an object that is always positioned 2 units in front of your camera view
triple object_pos = cam_pos + 2 * view_direction;
draw(shift(object_pos) * unitsphere, red);
