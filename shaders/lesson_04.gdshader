shader_type canvas_item;

uniform int exercise: hint_enum("A: 0", "B:1", "C:2", "D:3") = 0;

group_uniforms exercise_a;
uniform vec3 colorA = vec3(0.149,0.141,0.912);
uniform vec3 colorB = vec3(1.000,0.833,0.224);
group_uniforms;

group_uniforms exercise_b;
uniform bool module = false;
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
	if (!module)
		return pct;
	pct.r = smoothstep(0.0,1.0, stx);
	pct.g = sin(stx*PI);
	pct.b = pow(stx,0.5);
	return pct;
}

vec3 second_exercise(vec2 st) {
	//gl_FragCoord.xy/u_resolution.xy;
	vec3 color = vec3(0.0);
	vec3 pct = second_exercise_module(st.x);

	color = mix(colorA, colorB, pct);

	// Plot transition lines for each channel
	color = mix(color,vec3(1.0,0.0,0.0),plot(st,pct.r));
	color = mix(color,vec3(0.0,1.0,0.0),plot(st,pct.g));
	color = mix(color,vec3(0.0,0.0,1.0),plot(st,pct.b));

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
