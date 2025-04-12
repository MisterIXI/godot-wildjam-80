shader_type canvas_item;

uniform float uv_scale = 1.0;
uniform vec4 line_color: source_color = vec4(1);
uniform vec4 color_tint: source_color = vec4(1);
uniform vec4 shadow_color: source_color = vec4(0,0,0,1);
uniform float shadow_blur = 1.0;
uniform bool draw_line = true;
uniform float line_thickness: hint_range(0, 50) = 1.0;
uniform sampler2D noise: repeat_enable;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float noise_speed = 1.0;
uniform float distortion_str = 0.1;
uniform float frame_time:hint_range(0.0, 1.0, 0.01) = 0.25;

varying float max_offset;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1),
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};



void fragment() {

	//posterize time
	float rounded_time = round(TIME/ frame_time) * frame_time;

	//distort UVs by posterized time
	vec2 base_uv = UV * uv_scale;
	vec2 noise_uv = UV * vec2(1.) + noise_speed * rounded_time;
	float noise_tex = texture(noise, noise_uv).r;
	vec2 distorted_uv = base_uv + noise_tex * distortion_str;

	vec4 color = texture(TEXTURE, distorted_uv) * color_tint;
	vec4 screen = texture(screen_texture, SCREEN_UV, shadow_blur);

	// create outline
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness / 2.0;
	float inline = 1.0;
	float outline = 0.0;
	for (int i = 0; i < OFFSETS.length(); i++) {
		float sample = texture(TEXTURE, distorted_uv + size * OFFSETS[i]).a;
		outline += sample;
		inline *= sample;
	}
	outline = min(1.0, outline) - color.a;
	inline = (1.0 - inline) * color.a;


	vec4 outline_color = mix(line_color,color, color.a);
	float alpha = ((outline + inline) * float(draw_line)) + color.a;

	vec4 final_color = vec4(outline_color.r, outline_color.g, outline_color.b, alpha);
	vec4 drop_shadow = vec4(shadow_color.r, shadow_color.g, shadow_color.b, alpha);
	vec4 blurred_shadow = drop_shadow * screen;

	COLOR = final_color;
}
