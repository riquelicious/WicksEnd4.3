shader_type canvas_item;

uniform vec4 first_color : source_color = vec4(1.0);
uniform vec4 second_color : source_color = vec4(1.0);
uniform float position : hint_range(0.0, 1.0) = 0.0;
uniform float size : hint_range(0.01, 2) = 0.5;
uniform vec2 text_size; // Size of the entire text label

varying vec2 iuv;

void vertex() {
    // Calculate normalized UV coordinates based on text size
    iuv = VERTEX.xy; /// text_size;
}
 
void fragment() {
    vec2 uv = iuv / text_size;
    //vec4 color.a = texture(TEXTURE, UV).a;
    // Normalize position and clamp
    //float t = (UV.y - position) / size;
    float t = (uv.y - position) / size;
    t = clamp(t, 0.0, 1.0);

    // Calculate blend factors
    float blend1 = smoothstep(0.0, 0.5, t);
    float blend2 = smoothstep(0.5, 1.0, t);
//
    //// Define gradient colors
    vec4 gradient1 = mix(first_color, second_color, blend1);
    vec4 gradient2 = mix(second_color, first_color, blend2);
//
    //// Final color from gradient
    vec4 new_color = mix(gradient1, gradient2, blend2);

    // Check if the color is close to black
    COLOR.rgb = new_color.rgb;

}
