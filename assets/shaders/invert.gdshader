shader_type canvas_item;
uniform bool active = false;

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	if (active) {
		COLOR = vec4(1.0 - color.rgb, color.a);
	}
}