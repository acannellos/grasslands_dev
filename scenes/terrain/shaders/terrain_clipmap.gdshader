shader_type spatial;

group_uniforms heightmaps;
uniform sampler2D heightmap;
uniform sampler2D normalmap;
uniform float height_scale = 40.0;

group_uniforms color;
uniform sampler2D color_gradient : source_color;

varying vec2 uv_map_coords;
varying float height;


void vertex() {
	float tex_size = float(textureSize(heightmap, 0).x);
	float pixel_size = 1.0 / tex_size;

	uv_map_coords = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz * pixel_size + vec2(0.5);

	height = texture(heightmap, uv_map_coords).r;
	VERTEX.y += height * height_scale;
}

void fragment() {
	NORMAL_MAP = texture(normalmap, uv_map_coords).rgb;

	float t_height = clamp(height, 0.01, 0.99);
	vec3 grad_color = texture(color_gradient, vec2(t_height, 0.5)).rgb;
	ALBEDO = grad_color;
}
