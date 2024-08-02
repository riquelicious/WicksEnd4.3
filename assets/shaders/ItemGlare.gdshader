shader_type canvas_item;
render_mode unshaded;

uniform vec4 shine_color : source_color = vec4( 1.0, 1.0, 1.0, 1.0 );
uniform float cycle_interval : hint_range(0.5, 5.0) = 1.0;
uniform float shine_speed : hint_range(1.0, 5.0) = 3.0;
uniform float shine_width : hint_range(1.0, 1000.0) = 3.0;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
    vec2 vertex = FRAGCOORD.xy;
    float width = shine_width * 0.001 * cycle_interval;
	float frequency = floor( sin( vertex.x * cycle_interval + TIME * shine_speed * cycle_interval ) + width );
    COLOR.rgb = shine_color.rgb;
    COLOR.a = clamp( frequency * shine_color.a, 0.0, previous_color.a );
}
