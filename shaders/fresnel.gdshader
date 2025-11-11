shader_type spatial;
render_mode unshaded, blend_add;

uniform vec3 base_color: source_color;
uniform vec3 fresnel_color: source_color = vec3(1.0);
uniform float fresnel_intensity: hint_range(0.1, 10.0, 0.01) = 1.0;
uniform float fresnel_thickness: hint_range(0.1, 10.0, 0.01) = 4.0;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	//vec3 base_color = vec3(0.5, 0.2, 0.9);
	//vec3 fresnel_color = vec3(0.0, 0.7, 0.9);
	vec3 fresnel = fresnel_glow(fresnel_thickness, fresnel_intensity, fresnel_color, NORMAL, VIEW);
	ALBEDO = base_color + fresnel;
}
//
//
//void fragment() {
	//vec3 base_color = vec3(0.0);
	//float basic_fresnel = fresnel(outline_thickness, NORMAL, VIEW);
	//ALBEDO = base_color + basic_fresnel;
	//ALPHA = basic_fresnel;
//}
