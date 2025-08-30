shader_type spatial;

uniform float height_scale = 40.0;
uniform sampler2D heightmap;
uniform sampler2D normalmap;
uniform sampler2D color_gradient : source_color;

varying vec2 position;

void vertex() {
	float heightmap_size = float(textureSize(heightmap, 0).x);
	position = VERTEX.xz / heightmap_size + 0.5;
	
	float height = texture(heightmap, position).x;
	
	VERTEX.y += height * height_scale;
}

void fragment() {
  NORMAL_MAP = texture(normalmap, position).xyz;
}