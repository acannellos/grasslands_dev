shader_type spatial;
render_mode cull_disabled;

uniform sampler2D gradient : source_color; // gradient texture
uniform float wind_strength : hint_range(0.0, 1.0) = 0.1;
uniform float wind_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wind_scale : hint_range(0.0, 5.0) = 1.5;

// estimated vertical range of the particle system
uniform float height_range = 4.0; // adjust to your particle emitter’s spread
uniform float base_height = 0.0;   // emitter's lowest Y in world space

varying float world_y;

void vertex() {
    vec4 world_pos = MODEL_MATRIX * vec4(VERTEX, 1.0);
    world_y = world_pos.y;

    float sway_x = sin(TIME * wind_speed + VERTEX.x * wind_scale) * wind_strength * VERTEX.y;
    float sway_z = cos(TIME * wind_speed + VERTEX.z * wind_scale) * wind_strength * VERTEX.y;

    VERTEX.x += sway_x;
    VERTEX.z += sway_z;
}

void fragment() {
    // normalize world_y based on base_height + height_range
    float t = clamp((world_y - base_height) / height_range, 0.0, 1.0);
    // flip to sample gradient right-to-left
    ALBEDO = texture(gradient, vec2(t, 0.5)).rgb;
}
