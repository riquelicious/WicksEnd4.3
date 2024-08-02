/*
	炎シェーダー by あるる（きのもと 結衣）
	Fire Shader by Yui Kinomoto @arlez80

	MIT License
*/
shader_type spatial;
render_mode depth_draw_opaque, unshaded, shadows_disabled;

uniform sampler2D noise_tex : hint_default_white;
uniform vec4 root_color : source_color = vec4( 1.0, 0.75, 0.3, 1.0 );
uniform vec4 tip_color : source_color = vec4( 1.0, 0.03, 0.001, 1.0 );

uniform float fire_alpha : hint_range( 0.0, 1.0 ) = 1.0;
uniform vec2 fire_speed = vec2( 0.0, 1.0 );
uniform float fire_aperture : hint_range( 0.0, 3.0 ) = 0.0;
uniform float fire_percentage : hint_range(0.0, 100.0) = 100.0;
uniform float glow : hint_range(0.0 , 1.0) = 0.05;
uniform bool is_on_bottom = false;

uniform float base_amplitude : hint_range(0, 10) = 0.1;
uniform float base_frequency : hint_range(0, 10) = 1.0;
uniform float edge_thickness : hint_range(0, 1) = 0.65;  // Thickness of the area where wave effect is applied

//void vertex() {
	//float uv_distance = length(UV - vec2(0.5, 0.5));
	//float distance_factor = smoothstep(0.0, edge_thickness, 1.0 - uv_distance);
  	//float amplitude = base_amplitude * (0.5 + 0.5 * sin(TIME * 2.0));
    //float frequency = base_frequency * (0.5 + 0.5 * sin(TIME * 1.5));
    //float wave = distance_factor * amplitude * sin(VERTEX.y * frequency + TIME) * cos(VERTEX.z * frequency + TIME);
    //VERTEX.x += wave;
//}

void fragment( ) {
	vec2 shifted_uv = UV + TIME * fire_speed; //?makes fire move?
	float fire_noise = texture( noise_tex, shifted_uv ).r; //?gets fire noise
	float noise; 
	if (is_on_bottom){
		noise = (fire_noise) * 100.0 ;
	}
	else {
		noise = UV.y * ( ( ( UV.y + fire_aperture ) * fire_noise - fire_aperture ) * fire_percentage );
	}
	//float intensity = abs(sin(TIME * 1.0));
	vec4 fire_color = mix( tip_color, root_color, noise * glow  );
	ALPHA = clamp( noise, 0.0, 1.0 ) * fire_alpha;
	ALBEDO = fire_color.rgb;
}