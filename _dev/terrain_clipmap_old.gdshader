shader_type spatial;
//render_mode diffuse_toon, specular_toon;

group_uniforms heightmaps;
uniform sampler2D heightmap;
uniform sampler2D heightmap_normals;
uniform float heightmap_normals_intensity : hint_range(0.0, 1.0);

uniform float heightmap_scale = 1.0;
uniform float heightmap_height_scale = 40.0;

group_uniforms textures;
uniform sampler2D flat_albedo : source_color;
uniform sampler2D flat_normal : hint_normal;
uniform float flat_uv_scale = 1.0;
uniform float flat_normal_scale : hint_range(0.0, 1.0);


varying vec2 world_position;
varying float world_height;
varying vec3 vert_normal;

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

	float height = texture(heightmap, world_position).r;
	VERTEX.y += height * heightmap_height_scale;

	world_height = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;

	vec3 normal_map = unpack_normalmap(texture(heightmap_normals, world_position));
	vert_normal = mix(vec3(0.5, 0.5, 1.0), normal_map, heightmap_normals_intensity);
	NORMAL = vert_normal;
}



//
//vec3 get_triplanarized_map(sampler2D sampler, vec4 projected_coords, vec3 normal_weights, float uv_scale) {
	//vec3 texX = texture(sampler, projected_coords.zy * uv_scale).rgb;
	//vec3 texY = texture(sampler, projected_coords.xz * uv_scale).rgb;
	//vec3 texZ = texture(sampler, projected_coords.xy * uv_scale).rgb;
	//return texX * normal_weights.x + texY * normal_weights.y + texZ * normal_weights.z;
//}
//
//void fragment() {
	//vec4 projected_coords = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	//vec3 world_normal = abs(INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	//vec3 normal_weights = world_normal / (world_normal.x + world_normal.y + world_normal.z);
	//
	////vec3 triplanarized_flat_albedo = get_triplanarized_map(flat_albedo, projected_coords, normal_weights, flat_uv_scale * 0.01);
	////vec3 triplanarized_flat_normal = get_triplanarized_map(flat_normal, projected_coords, normal_weights, flat_uv_scale * 0.01);
	////
	////vec3 flat_color = vec3(triplanarized_flat_albedo.r);
	////ALBEDO = flat_color;
	//
	//
	//vec4 albedo_tex = texture(flat_albedo, UV * 12.0);
    //ALBEDO = albedo_tex.rgb;
	//
	//// Called for every pixel the material is visible on.
//}

//void fragment() {
    //vec4 tex = texture(albedo_texture, UV);
    //ALBEDO = tex.rgb;
    //ALPHA = tex.a;
//}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
