shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.2, 1.0, 0.3, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float glow_size : hint_range(1.0, 40.0) = 12.0;

void fragment()
{
    vec2 uv = UV;

    float d = min(
        min(uv.x, 1.0 - uv.x),
        min(uv.y, 1.0 - uv.y)
    );

    float border = smoothstep(
        glow_size / 100.0,
        0.0,
        d
    );

    float glow = border * strength;

    COLOR = vec4(glow_color.rgb, glow);
}