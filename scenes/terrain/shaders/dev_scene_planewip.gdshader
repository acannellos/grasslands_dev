shader_type spatial;
//render_mode unshaded;
render_mode diffuse_toon;

group_uniforms heightmap;
uniform sampler2D heightmap : source_color;
//uniform sampler2D normalmap : source_color;
uniform sampler2D vignette : source_color;
uniform float height = 40.0;

group_uniforms gradient;
uniform sampler2D gradient : source_color;
uniform int band_count = 8;
uniform float gradient_warp : hint_range(-1.0, 1.0) = 0.0;

uniform float texel_size = 0.001953125; // 1.0 / 512.0; // 1 / texture resolution

varying float t;
varying float gradient_noise_sample;
varying vec2 heightmap_uv;

void vertex() {
	float heightmap_size = float(textureSize(heightmap, 0).x);
	heightmap_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / heightmap_size + vec2(0.5);

	float height_test = texture(heightmap, VERTEX.xz / 2.0 + 0.5).x;

	//heightmap_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / (heightmap_size * heightmap_scale) + vec2(0.5);
	//heightmap_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / (heightmap_size * heightmap_scale) + vec2(0.5);
	float heightmap_sample = texture(heightmap, heightmap_uv).r;

	float vignette_size = float(textureSize(vignette, 0).x);
	vec2 vignette_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / vignette_size + vec2(0.5);
	float vignette_sample = texture(vignette, vignette_uv).r;

	t = mix(0.0, heightmap_sample, vignette_sample);

	VERTEX.y += t * height;
	//VERTEX.y += heightmap_sample;
}

vec3 get_stepped_color(float t_input) {
    float step_size = 1.0 / float(band_count);
    float band_index = floor(clamp(t_input, 0.01, 0.99) / step_size);
    float stepped_t = (band_index + 0.5) * step_size;
    return texture(gradient, vec2(stepped_t, 0.5)).rgb;
}

void fragment() {

	float t_mixed = mix(t, 1.0, gradient_warp);

	ALBEDO = get_stepped_color(t_mixed);

    vec2 uv = UV;

    // Sample neighboring heights
    float hL = texture(heightmap, uv + vec2(-texel_size, 0.0)).r * height;
    float hR = texture(heightmap, uv + vec2(texel_size, 0.0)).r * height;
    float hD = texture(heightmap, uv + vec2(0.0, -texel_size)).r * height;
    float hU = texture(heightmap, uv + vec2(0.0, texel_size)).r * height;

    // Derive slope
    vec3 dx = vec3(2.0 * texel_size, 0.0, hR - hL);
    vec3 dy = vec3(0.0, 2.0 * texel_size, hU - hD);

    // Cross product gives the normal
    vec3 normal = normalize(cross(dx, dy));

    //NORMAL = normal;
	NORMAL = normalize((VIEW_MATRIX * vec4(normal, 0.0)).xyz);

	ROUGHNESS = 0.0;

	//ALBEDO = normal;

}
