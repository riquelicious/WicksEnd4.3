shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0,1.0);
uniform bool active = true;
uniform bool shake_active = false;
uniform float strength : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float shake_speed : hint_range(1.0, 100.0, 1.0) = 50.0;
uniform float intensity : hint_range(1.0, 20.0, 1.0) = 5.0;

void fragment() {
	if (active) {
		COLOR += color * UV.x * strength;
	}
}

void vertex() {
	if (shake_active) {
		VERTEX.y += sin(TIME * shake_speed) * intensity;
	}
}