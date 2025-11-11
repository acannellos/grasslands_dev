shader_type spatial;
render_mode unshaded;

uniform vec4 bar_color : source_color = vec4(1.0, 0.4, 0.4, 1.0);
uniform vec4 background_color : source_color = vec4(1);
uniform vec4 blank_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);

uniform float value : hint_range(0.0, 1.0) = 1.0;
uniform float lag_value : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    float uvx = clamp(UV.x, 0.0, 1.0);

    float min_v = min(value, lag_value);
    float max_v = max(value, lag_value);

    vec4 color;

    if (uvx <= min_v) {
        color = bar_color;
    } 
    else if (uvx <= max_v) {
        color = background_color;
    } 
    else {
        color = blank_color;
    }

    ALBEDO = color.rgb;
    ALPHA = color.a;
}
