shader_type canvas_item;
uniform float shake_speed : hint_range(1.0, 100.0, 1.0) = 50.0;
uniform float intensity : hint_range(1.0, 20.0, 1.0) = 5.0;
uniform bool shake_active = false;



void vertex() {
	if (shake_active) {
		VERTEX.y += sin(TIME * shake_speed) * intensity;
	}
}

void fragment() {

}
