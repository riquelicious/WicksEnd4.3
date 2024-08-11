shader_type canvas_item;

uniform float invert_amount = 1;
uniform float black_threshold : hint_range(0.0, 1.0) = 0.1; 
uniform float white_threshold : hint_range(0.0, 1.0) = 0.5;
void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec4 final_color = color;
    if (color.rgb.r < black_threshold && color.rgb.g < black_threshold && color.rgb.b < black_threshold && color.a == 1.0) {
        vec4 invert_color = vec4(1.0 - color.rgb, color.a);
        final_color = mix(color, invert_color, invert_amount);
    }
    else if (color.rgb.r > white_threshold && color.rgb.g > white_threshold && color.rgb.b > white_threshold) {
        vec4 invert_color = vec4(1.0 - color.rgb, color.a);
        final_color = mix(color, invert_color, invert_amount);
    }
    COLOR = final_color;
}
