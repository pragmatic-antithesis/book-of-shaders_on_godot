shader_type canvas_item;

uniform vec4 background_colors: source_color;
uniform vec4 base_colors: source_color = vec4(0.0, 1.0 , 0.0, 1.0);
uniform float gradient_distribution = 1.0;
uniform float smoothstep_1 = 0.02;
uniform float smoothstep_2 = 0.0;
uniform int exercise: hint_enum("A: 0", "B:1", "C:2", "D:3") = 0;
group_uniforms exercise_a;
uniform float gradient = 1.0;
uniform bool use_dropdown = false;
uniform int dropdown_gradient: hint_enum("none: 0", "quarter:1" , "half:2", "three-quarters:3", "full:4") = 0;
group_uniforms;

group_uniforms exercise_b;
uniform float pow_exponent = 5.0;
group_uniforms;

group_uniforms exercise_c;
uniform float stepper = 0.5;
group_uniforms;

group_uniforms exercise_d;
uniform int mode: hint_enum("1:0", "2:1");
uniform float d1_low_step = 0.1;
uniform float d1_high_step = 0.9;
uniform float d2_left_low_step = 0.2;
uniform float d2_left_high_step = 0.5;
uniform float d2_right_low_step = 0.5;
uniform float d2_right_high_step = 0.8;
group_uniforms;

void vertex() {
	//VERTEX += vec2(cos(TIME)*100.0, sin(TIME)*100.0);
	// Called for every vertex the material is visible on.
}

// Plot a line on Y using a value between 0.0-1.0
float plot(const vec2 st) {
	//godot exclusive due to axis Y inversion:
	const float inverted_y = 1.0 - st.y;
	return smoothstep(smoothstep_1, smoothstep_2, abs(inverted_y - st.x));
	//return step(smoothstep_1, abs(inverted_y - st.x)); //-> this "inverts" the line placement
}

float plot(const vec2 st, const float pct){
	const float inverted_y = 1.0 - st.y;
	return  smoothstep( pct - smoothstep_1, pct, inverted_y) - smoothstep( pct, pct+smoothstep_2 + 0.02, inverted_y);
}

vec3 first_exercise(const vec2 st, inout vec3 book_color) {
	float divider = 0.0;

	switch(dropdown_gradient) {
		case 0:
			divider = 0.0;
			break;
		case 1:
			divider = 0.25;
			break;
		case 2:
			divider = 0.5;
			break;
		case 3:
			divider = 0.75;
			break;
		case 4:
			divider = 1.0;
			break;
	}

	if (!use_dropdown)
		divider = gradient;

	float y = st.x / divider;
	book_color = vec3(y);

	// Plot a line
	float pct = plot(st);
	return (gradient_distribution - pct) * book_color + pct * vec3(base_colors.rgb);
}

vec3	second_exercise(const vec2 st, inout vec3 book_color) {
	float y = pow(st.x, pow_exponent);
	book_color = vec3(y);
	float pct = plot(st,y);
	return (gradient_distribution - pct) * book_color+pct * vec3(base_colors.rgb);
}

vec3 third_exercise(const vec2 st, inout vec3 book_color) {
	float y = step(stepper,st.x);
	book_color = vec3(y);

	float pct = plot(st,y);
	return (gradient_distribution - pct) * book_color+pct * vec3(base_colors.rgb);
}

vec3 fourth_exercise(const vec2 st, inout vec3 book_color) {
	float y = 0.0;
	switch(mode) {
		case 0:
			y = smoothstep(d1_low_step, d1_high_step, st.x);
			break;
		case 1:
			y = smoothstep(d2_left_low_step,d2_left_high_step,st.x) - smoothstep(d2_right_low_step,d2_right_high_step,st.x);
			break;
	}
	vec3 color = vec3(y);
	float pct = plot(st,y);
	return (gradient_distribution - pct) * book_color+pct * vec3(base_colors.rgb);
}

void fragment() {
	vec3 book_color = background_colors.rgb;
	vec2 st = UV;
	switch(exercise) {
		case 0:
			book_color = first_exercise(st, book_color);
			break;
		case 1:
			book_color = second_exercise(st, book_color);
			break;
		case 2:
			book_color = third_exercise(st, book_color);
			break;
		case 3:
			book_color = fourth_exercise(st, book_color);
			break;
	}
	COLOR = vec4(book_color, base_colors.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
