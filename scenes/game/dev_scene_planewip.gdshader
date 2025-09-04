shader_type spatial;

group_uniforms heightmap;
uniform sampler2D heightmap : source_color;
uniform float heightmap_scale = 1.0;
uniform float height = 40.0;
uniform sampler2D vignette : source_color;

group_uniforms gradient;
uniform sampler2D gradient : source_color;
uniform int band_count = 8;
uniform sampler2D gradient_noise : source_color;
uniform float gradient_noise_intensity : hint_range(0.0, 1.0) = 0.0;


varying float t;
varying float gradient_noise_sample;

void vertex() {
	float heightmap_size = float(textureSize(heightmap, 0).x);
	vec2 heightmap_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / (heightmap_size * heightmap_scale) + vec2(0.5);
	float heightmap_sample = texture(heightmap, heightmap_uv).r;
	
	float vignette_size = float(textureSize(vignette, 0).x);
	vec2 vignette_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / vignette_size + vec2(0.5);
	float vignette_sample = texture(vignette, vignette_uv).r;
	
	t = mix(0.0, heightmap_sample, vignette_sample);
		
	VERTEX.y += t * height;
	
	float gradient_noise_size = float(textureSize(gradient_noise, 0).x);
	vec2 gradient_noise_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / gradient_noise_size + vec2(0.5);
	gradient_noise_sample = texture(gradient_noise, gradient_noise_uv).r;
	
	//TODO normals
}

vec3 get_stepped_color(float t_input) {
    float step_size = 1.0 / float(band_count);
    float band_index = floor(clamp(t_input, 0.01, 0.99) / step_size);
    float stepped_t = (band_index + 0.5) * step_size;
    return texture(gradient, vec2(stepped_t, 0.5)).rgb;
}

void fragment() {

	
	float t_mixed = mix(t, gradient_noise_sample, gradient_noise_intensity);
	
	ALBEDO = get_stepped_color(t_mixed);
	//ALBEDO = vec3(t);
}
