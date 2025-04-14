shader_type canvas_item;

uniform float uv_scale = 1.0;
uniform vec4 color_1: source_color = vec4(0.5,0.5,0.5,1);
uniform vec4 color_2: source_color = vec4(1);
uniform vec4 color_tint: source_color = vec4(1);
uniform vec2 uv_scroll = vec2(1,1);
uniform sampler2D noise: repeat_enable;
uniform float noise_speed = 1.0;
uniform float distortion_str = 0.1;
uniform float frame_time:hint_range(0.0, 1.0, 0.01) = 0.25;




void fragment() {

	//posterize time
	float rounded_time = round(TIME/ frame_time) * frame_time;

	//distort UVs by posterized time
	vec2 base_uv = UV * uv_scale + TIME * uv_scroll;
	vec2 noise_uv = UV + noise_speed * rounded_time;
	float noise_tex = texture(noise, noise_uv).r;
	vec2 distorted_uv = base_uv + noise_tex * distortion_str;

	vec4 mask = texture(TEXTURE, distorted_uv);

vec4 final_color = mix(color_1, color_2, mask);

	COLOR = final_color * color_tint;
}
