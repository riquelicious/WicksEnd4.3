shader_type canvas_item;

uniform vec2 resolution; // The resolution of the screen
uniform float amplitude; // The amplitude of the wave
uniform float frequency; // The frequency of the wave
uniform float speed; // The speed of the wave
uniform sampler2D noiseTexture; // The noise texture

void fragment() {
    vec2 uv = FRAGCOORD.xy / resolution.xy; // Normalize pixel coordinates (0 to 1)

    // Sample the noise texture
    vec4 noise = texture(noiseTexture, uv);

    // Calculate the wave distortion using noise
    float wave = sin(UV.y * frequency + TIME * speed + noise.r * 10.0) * amplitude;

    // Apply the wave distortion to the texture coordinates
    vec2 distortedUV = UV + vec2(wave, 0.0);

    // Sample the main texture with the distorted coordinates
    vec4 color = texture(TEXTURE, distortedUV);

    // Set the final color of the fragment
    COLOR = color;
}
