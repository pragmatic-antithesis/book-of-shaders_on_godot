shader_type canvas_item;

uniform int exercise: hint_enum("A: 0", "B:1", "C:2", "D:3") = 0;

group_uniforms exercise_a;
uniform vec3 colorA = vec3(0.149,0.141,0.912);
uniform vec3 colorB = vec3(1.000,0.833,0.224);
group_uniforms;

group_uniforms exercise_b;
uniform int module: hint_enum("Default: 0", "Lines25-27:1", "Turner:2", "D:3") = 0;
uniform bool line25 = false;
uniform float l25low = 0.0;
uniform float l25high = 1.0;
uniform bool line26n27 = false;
uniform float l26pi_multiplier = 1.0;
uniform float l27pow_exponent = 0.5;
uniform vec3 sunsetA = vec3(0.988, 0.552, 0.235);
uniform vec3 sunsetB = vec3(0.670, 0.125, 0.447);
uniform vec3 sunsetC = vec3(0.137, 0.231, 0.623);
uniform float turner_rightsmoothlow = 0.05;
uniform float turner_rightsmoothigh = 0.8;
uniform float turner_midsmoothlow = 0.3;
uniform float turner_midsmoothigh = 0.5;
uniform float sunset_mask_constrain = 0.05;
uniform float sunset_mask_min = 0.0;
uniform float sunset_mask_max = 1.0;
uniform float sunset_vert_l_smooth_low = 0.0;
uniform float sunset_vert_l_smooth_high = 0.5;
uniform float sunset_vert_r_smooth_low = 0.6;
uniform float sunset_vert_r_smooth_high = 0.85;
uniform float sunset_vert_inverter = 1.5;
group_uniforms;


void vertex() {
	// Called for every vertex the material is visible on.
}

float plot (vec2 st, float pct) {
  return  smoothstep( pct-0.01, pct, st.y) -
          smoothstep( pct, pct+0.01, st.y);
}

vec3 first_exercise() {
	vec3 color = vec3(0.0);
    float pct = abs(sin(TIME));
    color = mix(colorA, colorB, pct);
	return color;
}

vec3 second_exercise_module(float stx) {
	vec3 pct = vec3(stx);
	if (module == 0)
		return pct;
	if (module == 1) {
		if (line25)
			pct.r = smoothstep(l25low,l25high, stx);
		if (line26n27) {
			pct.g = sin(stx*PI*l26pi_multiplier);
			pct.b = pow(stx,l27pow_exponent);
		}
	}
	return pct;
}

//vec3 exercise_turner(vec2 st) {
	//float t = st.y;
	//vec3 color = mix(sunsetA, sunsetB, t);
	//color = mix(color, sunsetC, t*t);
	//return color;
//}

vec3 exercise_turner(vec2 st) {
	float x = st.x;
	float y = st.y;

	vec3 color = sunsetC;

	float rightBand   = smoothstep(turner_rightsmoothlow, turner_rightsmoothigh, x);
	float midBand     = smoothstep(turner_midsmoothlow,turner_midsmoothigh, x);
	float sunsetMask  = clamp(rightBand + sunset_mask_constrain * midBand, sunset_mask_min, sunset_mask_max);

	float vertical = smoothstep(sunset_vert_l_smooth_low, sunset_vert_l_smooth_high, y) * (sunset_vert_inverter - smoothstep(sunset_vert_r_smooth_low, sunset_vert_r_smooth_high, y));

	float mask = sunsetMask * vertical;

	vec3 grad = mix(sunsetA, sunsetB, y * y);
	color = mix(color, grad, mask);

	return color;
}



vec3 second_exercise(vec2 st) {
	vec3 color = vec3(0.0);
	vec3 pct = second_exercise_module(st.x);

	color = mix(colorA, colorB, pct);

	color = mix(color,vec3(1.0,0.0,0.0),plot(st,pct.r));
	color = mix(color,vec3(0.0,1.0,0.0),plot(st,pct.g));
	color = mix(color,vec3(0.0,0.0,1.0),plot(st,pct.b));
	if (module == 2)
		return exercise_turner(st);
	return color;
}

vec3 get_exercise(vec2 uv) {
	switch(exercise) {
		case 0:
			return first_exercise();
		case 1:
			return second_exercise(uv);
	}
}

void fragment() {
	vec3 color = get_exercise(UV);
	COLOR = vec4(color,1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
