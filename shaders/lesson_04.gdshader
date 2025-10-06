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
group_uniforms;


void vertex() {
	// Called for every vertex the material is visible on.
}

float plot (vec2 st, float pct) {
	float y = 1.0 - st.y; // flip Godot's UV.y to match GLSL
	//y = st.y;
	return  smoothstep( pct-0.01, pct, y) -
	        smoothstep( pct, pct+0.01, y);
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

uniform vec3 sun = vec3(0.988, 0.552, 0.235);
uniform vec3 sky = vec3(0.670, 0.125, 0.447);
uniform vec3 sea = vec3(0.137, 0.231, 0.623);
uniform float arch_start = 0.4; //works sort of as intended, but the beginning of the wave is really sharp and there is no color mixing
uniform float arch_width = 0.5; // is this the best way? seems like I need to tweak both the start and the width for a different placement
uniform float arch_amp = 0.75;
uniform float arch_soft_low = 0.1; // this increments in a very weird way, but it works a bit
uniform float arch_soft_high = 0.03; // this increments poorly, there is leak from the top of the screen on the faintest adjustment
uniform float arch_shape = 0.4; // works, but the more I increase it, the more it becomes sharp and less mixed

vec3 exercise_turner(vec2 st) {
    vec3 base = sun;

    float x = (st.x - arch_start) / arch_width;
    x = clamp(x, 0.0, 1.0);
    float s = sin(x * PI);
    s = pow(s, arch_shape);
    float wave = s * arch_amp;

    // mask around the wave (controls how sharp/soft the visible band is)
    float mask = smoothstep(wave - arch_soft_low, wave + arch_soft_high, st.y);

    // vertical gradient for warm->cool blending
    vec3 grad = mix(sky, sea, st.y);

    // blend base and grad using the wave mask
    vec3 color = mix(base, grad, mask);

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
