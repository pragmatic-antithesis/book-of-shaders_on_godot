shader_type canvas_item;

uniform int exercise: hint_enum("example: 0", "full square:1", "draw square:2") = 0;
uniform float thickness = 0.1;

group_uniforms example_one;
uniform bool top_right = false;
uniform bool bottom_left = false;
group_uniforms;
vec3 example1 (in vec2 st) {
	float pct = 0.0;

    if (top_right) {
		vec2 bl = step(vec2(thickness),st);
		pct = bl.x * bl.y;
	}
    
	if(bottom_left) {
		vec2 tr = step(vec2(thickness),1.0-st);
		pct *= tr.x * tr.y;
	}
	return vec3(pct);
}

group_uniforms filled_square;
uniform vec2 center = vec2(0.5, 0.5);   // 0-1 range (UV space)
uniform vec2 size   = vec2(0.2, 0.2);   // full-width / full-height
uniform float edge_smooth = 0.01;       // anti-alias
uniform vec4 square_color : source_color = vec4(1.0);
group_uniforms;
vec4 filled_square(in vec2 st) {
	vec2 d = abs(st - center) - size * 0.5;

	// inside the square when both components are negative
	float inside = -max(d.x, d.y);

	float alpha = smoothstep(-edge_smooth, edge_smooth, inside);
	return mix(vec4(0.0), square_color, alpha);
}

group_uniforms draw_square;
uniform float rec_x;
uniform float rec_y;
uniform float rec_z;
uniform float rec_w;
group_uniforms;
vec4 draw_square(in vec2 st) {
	// half-size and centre
	vec2 half_sz = vec2(rec_z - rec_x, rec_w - rec_y) * 0.5;
	vec2 centre  = vec2(rec_x + rec_z, rec_y + rec_w) * 0.5;

	// signed distance to nearest edge (positive outside, negative inside)
	vec2 d = abs(st - centre) - half_sz;
	float dist = max(d.x, d.y);          // distance to the box

	// keep only the pixels whose *absolute* distance is ≤ thickness
	//float pct = step(abs(dist), thickness);
	float pct = step(0.0, dist) * step(dist, thickness);
	return vec4(vec3(pct), 1.0);
}

// 's' denotes the horizontal (u-axis) and 't' the vertical (v-axis) direction of the texture
// read pct as percentage
void fragment() {
	vec4 color = vec4(0.0);

	switch(exercise) {
		case 0:
			color = vec4(example1(UV), 1.0);
			break;
		case 1:
			color = filled_square(UV);
			break;
		case 2:
			color = draw_square(UV);
			break;
	}
	COLOR = color;
}
