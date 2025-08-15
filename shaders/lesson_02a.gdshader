shader_type canvas_item;

uniform vec4 base_colors: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 shader_color = base_colors;
	shader_color.r = abs(sin(TIME));
//	shader_color.g = abs(sin(TIME));
//	shader_color.b = abs(cos(TIME));
	COLOR = shader_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
