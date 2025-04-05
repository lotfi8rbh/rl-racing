shader_type spatial;
render_mode cull_disabled;

uniform sampler2D tex : source_color;

void fragment() {
	ALBEDO = texture(tex, UV*vec2(1,.8)).rgb;
}