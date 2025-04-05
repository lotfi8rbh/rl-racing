shader_type spatial;

uniform sampler2D tex: source_color;

void fragment() {
	ALBEDO = texture(tex, UV).rgb;
}