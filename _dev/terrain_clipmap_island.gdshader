shader_type spatial;
render_mode diffuse_toon, specular_toon;

// HEIGHTMAPS
group_uniforms heightmaps;
uniform sampler2D heightmap;
uniform sampler2D heightmap_normals;
uniform float heightmap_normals_intensity : hint_range(0.0, 1.0);
uniform sampler2D splatmap;
uniform float heightmap_scale = 1.0;
uniform float heightmap_height_scale = 40.0;

// COLORS
group_uniforms height_colors;
uniform float height_edge_1 : hint_range(0.0, 1.0) = 0.1;
uniform float height_edge_2 : hint_range(0.0, 1.0) = 0.2;
uniform float height_edge_3 : hint_range(0.0, 1.0) = 0.3;
uniform float height_edge_4 : hint_range(0.0, 1.0) = 0.5;
uniform float height_edge_5 : hint_range(0.0, 1.0) = 0.6;
uniform float height_edge_6 : hint_range(0.0, 1.0) = 0.8;
uniform float height_edge_7 : hint_range(0.0, 1.0) = 0.9;

uniform vec3 height_color_1 : source_color = vec3(0.0, 0.1, 0.3);
uniform vec3 height_color_2 : source_color = vec3(0.2, 0.4, 0.6);
uniform vec3 height_color_3 : source_color = vec3(0.7, 0.6, 0.4);
uniform vec3 height_color_4 : source_color = vec3(0.4, 0.6, 0.3);
uniform vec3 height_color_5 : source_color = vec3(0.2, 0.4, 0.1);
uniform vec3 height_color_6 : source_color = vec3(0.5, 0.5, 0.5);
uniform vec3 height_color_7 : source_color = vec3(0.8, 0.8, 0.8);
uniform vec3 height_color_8 : source_color = vec3(1.0, 1.0, 1.0);

// FLAT TEXTURE MAPPING
group_uniforms textures;
uniform sampler2D flat_albedo : hint_default_white;
uniform sampler2D flat_normal : hint_normal;
uniform float flat_uv_scale = 1.0;
uniform float flat_normal_scale : hint_range(0.0, 1.0);

// FLAT PROPERTIES
group_uniforms properties;
uniform float flat_specular : hint_range(0.0, 1.0);
uniform float flat_roughness : hint_range(0.0, 1.0);
uniform float flat_metallic : hint_range(0.0, 1.0);
uniform float flat_normal_intensity : hint_range(0.0, 1.0);

// VIGNETTE
group_uniforms vignette;
uniform float vignette_radius : hint_range(0.0, 1.0) = 0.3;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 1.0;
uniform float vignette_noise_scale : hint_range(0.0, 10.0) = 0.0;
uniform float vignette_noise_strength : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D vignette_noise_texture;

// VARYINGS
varying vec2 world_position;
varying vec3 vert_normal;
varying float world_height;
varying float vignette_factor;

// UTILS
vec3 unpack_normalmap(vec4 rgba) {
	vec3 n = rgba.xzy * 2.0 - vec3(1.0);
	n.z *= -1.0;
	return n;
}

void vertex() {
	float heightmap_size = float(textureSize(heightmap, 0).x);
	float pixel_size = 1.0 / heightmap_size;
	vec2 half_pixel = vec2(pixel_size) * 0.5;

	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz / (heightmap_size * heightmap_scale) + vec2(0.5) + half_pixel;

	vec2 centered_uv = world_position - vec2(0.5);
	float dist = length(centered_uv);

	// Sample noise from texture
	vec2 noise_uv = world_position * vignette_noise_scale;
	float noise_sample = texture(vignette_noise_texture, noise_uv).r;
	dist += (noise_sample - 0.5) * vignette_noise_strength;

	float vignette = smoothstep(vignette_radius, 1.0, 1.0 - dist);
	vignette_factor = mix(1.0 - vignette_intensity, 1.0, vignette);

	float height = texture(heightmap, world_position).r;
	VERTEX.y += height * heightmap_height_scale * vignette_factor;

	world_height = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;

	vec3 normal_map = unpack_normalmap(texture(heightmap_normals, world_position));
	vert_normal = mix(vec3(0.5, 0.5, 1.0), normal_map, heightmap_normals_intensity);
	NORMAL = vert_normal;
}

vec3 get_height_color(float h) {
	float b1 = step(h, height_edge_1);
	float b2 = step(height_edge_1, h) * step(h, height_edge_2);
	float b3 = step(height_edge_2, h) * step(h, height_edge_3);
	float b4 = step(height_edge_3, h) * step(h, height_edge_4);
	float b5 = step(height_edge_4, h) * step(h, height_edge_5);
	float b6 = step(height_edge_5, h) * step(h, height_edge_6);
	float b7 = step(height_edge_6, h) * step(h, height_edge_7);
	float b8 = step(height_edge_7, h);

	return
		b1 * height_color_1 +
		b2 * height_color_2 +
		b3 * height_color_3 +
		b4 * height_color_4 +
		b5 * height_color_5 +
		b6 * height_color_6 +
		b7 * height_color_7 +
		b8 * height_color_8;
}

void fragment() {
	float height_value = texture(heightmap, world_position).r;

	// Apply vignette darkening to height-based color
	float forced_height = mix(0.0, height_value, vignette_factor);
	vec3 color = get_height_color(forced_height);

	ALBEDO = color;
	//ALBEDO = vec3(forced_height);
	SPECULAR = flat_specular;
	ROUGHNESS = flat_roughness;
	METALLIC = flat_metallic;

	vec3 normal_map = unpack_normalmap(texture(flat_normal, world_position * flat_uv_scale * 0.01));
	NORMAL_MAP = mix(vec3(0.5, 0.5, 1.0), normal_map, flat_normal_scale);
	NORMAL_MAP_DEPTH = flat_normal_intensity;
}
