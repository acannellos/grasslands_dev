shader_type sky;

group_uniforms gradients;
uniform sampler2D gradient_day : source_color;
uniform sampler2D gradient_night : source_color;
uniform float daynight_mix : hint_range(0.0, 1.0) = 0.0;

group_uniforms noise;
uniform sampler2D noise : source_color;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.05;
uniform float noise_speed : hint_range(0.0, 0.2) = 0.01;

void sky() {
    // map to 0..1
    float t = EYEDIR.y * 0.5 + 0.5;
    vec2 noise_uv = EYEDIR.xz * 0.5 + 0.5;

    float n = texture(noise, noise_uv + TIME * noise_speed).r;

    // Center noise around 0, then scale it
    t += (n - 0.5) * 2.0 * noise_strength;

    // Clamp to remove artifacts at poles
    t = clamp(t, 0.01, 0.99);

    // Sample gradient with noisy vertical coordinate
	vec3 color_1 = texture(gradient_day, vec2(t, 0.5)).rgb;
	vec3 color_2 = texture(gradient_night, vec2(t, 0.5)).rgb;
	vec3 color_mix = mix(color_1, color_2, daynight_mix);

    COLOR = color_mix;
}
