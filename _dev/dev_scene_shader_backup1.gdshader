shader_type spatial;
//render_mode unshaded;
//render_mode diffuse_toon;

group_uniforms heightmap;
uniform sampler2D heightmap : source_color;
uniform sampler2D normalmap : source_color;
uniform sampler2D vignette : source_color;
uniform float heightmap_scale = 1.0;
uniform float height = 40.0;

group_uniforms gradient;
uniform sampler2D gradient : source_color;
uniform int band_count = 8;
uniform float gradient_warp : hint_range(-1.0, 1.0) = 0.0;


uniform bool WorldSpace = true; // toggle between world and local space
uniform bool RemapRange = false; // remap from -1..1 to 0..1

varying float t;
varying float gradient_noise_sample;
varying vec2 heightmap_uv;
varying vec2 normalmap_uv;
varying vec3 normalmap_sample_pass;

vec3 unpack_normalmap(vec4 rgba) {
	vec3 n = rgba.xzy * 2.0 - vec3(1.0);
	n.z *= -1.0;
	return n;
}

vec3 calculate_normal(vec2 uv) {
    float step = 1.0 / float(textureSize(heightmap, 0).x);

    float hL = texture(heightmap, uv + vec2(-step, 0.0)).r * height;
    float hR = texture(heightmap, uv + vec2( step, 0.0)).r * height;
    float hD = texture(heightmap, uv + vec2(0.0, -step)).r * height;
    float hU = texture(heightmap, uv + vec2(0.0,  step)).r * height;

    vec3 dx = vec3(2.0 * step * heightmap_scale, hR - hL, 0.0);
    vec3 dz = vec3(0.0, hU - hD, 2.0 * step * heightmap_scale);

    return normalize(cross(dz, dx));
}

void vertex() {
	float heightmap_size = float(textureSize(heightmap, 0).x);
	heightmap_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / (heightmap_size * heightmap_scale) + vec2(0.5);
	float heightmap_sample = texture(heightmap, heightmap_uv).r;
	
	float vignette_size = float(textureSize(vignette, 0).x);
	vec2 vignette_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / vignette_size + vec2(0.5);
	float vignette_sample = texture(vignette, vignette_uv).r;
	
	float normalmap_size = float(textureSize(normalmap, 0).x);
	normalmap_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / (normalmap_size * heightmap_scale) + vec2(0.5);
	
	t = mix(0.0, heightmap_sample, vignette_sample);
		
	VERTEX.y += t * height;

	vec3 normalmap_sample = unpack_normalmap(texture(normalmap, normalmap_uv));
	NORMAL = normalmap_sample;
	normalmap_sample_pass = normalmap_sample;
}

vec3 get_stepped_color(float t_input) {
    float step_size = 1.0 / float(band_count);
    float band_index = floor(clamp(t_input, 0.01, 0.99) / step_size);
    float stepped_t = (band_index + 0.5) * step_size;
    return texture(gradient, vec2(stepped_t, 0.5)).rgb;
}

void fragment() {
	//vec2 uv = UV * heightmap_scale; // scale if needed
	//vec3 normal_sample = texture(normalmap, heightmap_uv_new).rgb;
	//NORMAL_MAP = normal_sample;
	
	
	//NORMAL_MAP = texture(normalmap, heightmap_uv).rgb;
	//vec3 test_n = texture(normalmap, normalmap_uv).rgb;
	
	float t_mixed = mix(t, 1.0, gradient_warp);
	
	ALBEDO = get_stepped_color(t_mixed);
	ALBEDO = normalmap_sample_pass;
	
	//ALBEDO = test_n;
	//ALBEDO = vec3(t);
	//
    //// World space normal
    //vec4 Wn = INV_VIEW_MATRIX * vec4( NORMAL, 0.0 );
    //if ( WorldSpace == false ) // Local space normal
    //{
        //Wn = inverse( MODEL_MATRIX ) * Wn;
    //}
    //if ( RemapRange == true )
    //{
        //ALBEDO = ( Wn.rgb + 1.0 )/2.0;
    //}
    //else
    //{
        //ALBEDO = Wn.rgb;
    //}
	
	
	
}
