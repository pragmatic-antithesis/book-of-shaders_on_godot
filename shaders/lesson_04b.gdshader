shader_type canvas_item;

uniform bool hsb_wheel = false;
uniform float tca = 0.5;
uniform float tcb = 0.5;
uniform float rad_mult = 2.0;

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 st = 1.0 - UV.xy;
    vec3 color = vec3(0.0);

    // We map x (0.0 - 1.0) to the hue (0.0 - 1.0)
    // And the y (0.0 - 1.0) to the brightness
	if (!hsb_wheel) {
		color = hsb2rgb(vec3(st.x,tca + tcb,st.y));
	} else {
	// Use polar coordinates instead of cartesian
	    vec2 toCenter = vec2(tca, tcb)-st;
	    float angle = atan(toCenter.y,toCenter.x);
	    float radius = length(toCenter)*rad_mult;

	    // Map the angle (-PI to PI) to the Hue (from 0 to 1)
	    // and the Saturation to the radius
	    color = hsb2rgb(vec3((angle/TAU)+0.5,radius,1.0));
	}

    COLOR = vec4(color,1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
