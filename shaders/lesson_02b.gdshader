shader_type canvas_item;

uniform vec4 base_colors: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 st;
	vec4 shader_color = base_colors;
//	st = FRAGCOORD.xy * SCREEN_PIXEL_SIZE; //FRAGCOORD takes the whole scene as reference, UV creates a specific square
	st = UV;
	shader_color.r = st.x;
	shader_color.g = st.y;
	COLOR = shader_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
