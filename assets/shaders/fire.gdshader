shader_type spatial;
render_mode  depth_draw_always, unshaded, shadows_disabled, cull_disabled, depth_test_disabled;

// Editor
uniform bool is_active = true;
uniform bool is_blue = false;
uniform bool is_editing = true;
uniform bool is_on_bottom = false;

// Shader
uniform sampler2D noise_tex : hint_default_white;
uniform vec4 root_color1 : source_color = vec4(1.0, 0.75, 0.3, 1.0);
uniform vec4 tip_color1 : source_color = vec4(1.0, 0.03, 0.001, 1.0);
uniform vec4 root_color2 : source_color = vec4(0.572, 0.894, 0.596, 1.0);
uniform vec4 tip_color2 : source_color = vec4(0.0, 0.278, 0.671, 1.0);
uniform float fire_alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec2 fire_speed = vec2(0.0, 1.0);
uniform float fire_aperture : hint_range(0.0, 3.0) = 0.0;
uniform float fire_percentage : hint_range(0.0, 100.0) = 100.0;
uniform float glow : hint_range(0.0, 1.0) = 0.05;

// Wave
uniform float frequency : hint_range(0.0, 10.0) = 10.0;  // Frequency of the wave
uniform float amplitude : hint_range(0.0, 1.0) = 0.1;  // Amplitude of the wave

void vertex() {
    if (!is_on_bottom) {
        float wave_displacement = sin(VERTEX.x * frequency + (TIME * 20.0)) * amplitude;
        VERTEX.xz += vec2(wave_displacement, wave_displacement) * (vec2(-1.0) - VERTEX.y);
    }
}

void fragment() {
    vec2 uv = UV * vec2(3.0, 2.0);
    vec2 shifted_uv = uv + TIME * fire_speed;
    float fire_noise = texture(noise_tex, shifted_uv).r;
    float noise;
    
    if (is_on_bottom) {
        noise = fire_noise * 100.0;
    } else {
        noise = mod(uv.y, 1.0) * (((mod(uv.y, 1.0) + fire_aperture) * fire_noise - fire_aperture) * fire_percentage);
    }

    vec4 tip_color = is_blue ? tip_color2 : tip_color1;
    vec4 root_color = is_blue ? root_color2 : root_color1;
    vec4 fire_color = mix(tip_color, root_color, noise * glow);

    ALPHA = clamp(noise, 0.0, 1.0) * fire_alpha;
    ALBEDO = fire_color.rgb;

    if (uv.x < 3.0 && uv.x > 1.0 && uv.y < 2.0 && uv.y > 1.0) {
        ALPHA = 0.0;
    }
}
