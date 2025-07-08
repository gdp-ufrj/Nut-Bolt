shader_type canvas_item;

uniform float speed = 0.0005;
uniform float step_interval = 0.2;
varying float t;

void vertex() {
	// Called for every vertex the material is visible on.
	t = floor(TIME /step_interval);
	UV.x += (t * speed);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
