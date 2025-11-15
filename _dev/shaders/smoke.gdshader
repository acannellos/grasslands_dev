shader_type spatial;
render_mode depth_prepass_alpha;

uniform vec4 color: source_color;
uniform sampler2D color_gradiant: source_color;
uniform sampler2D vor_noise: source_color;
uniform sampler2D alpha_curve: source_color;

uniform float fernal_power;
uniform float vor_scale = 3.0;
uniform float vor_speed = 1.0;
uniform float emmision_power = 1.0;
uniform float alpha_clip: hint_range(0.0, 1.0, 0.02) = 1.0;

void fragment() {
	vec2 move_uv = fract(UV + TIME * vor_speed);
	vec4 sample_vor_noise = texture(vor_noise, move_uv * vor_scale);
	vec4 gradiant_color = texture(color_gradiant,vec2(COLOR.a, COLOR.a));
	
	
	ALBEDO = color.rgb * gradiant_color.rgb;
	ALPHA_SCISSOR_THRESHOLD = COLOR.a;
	ALPHA = texture(alpha_curve, vec2(sample_vor_noise.r,0.0)).r * clamp(color.a, 0.01, 0.99);
	EMISSION = emmision_power * color.rgb * gradiant_color.rgb;
}

void light(){

}