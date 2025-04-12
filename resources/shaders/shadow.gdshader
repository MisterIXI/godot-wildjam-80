shader_type canvas_item;

uniform vec4 color_tint:source_color = vec4(1);
uniform float alpha:hint_range(0.0, 1.0, 0.01) = 1.0;
uniform vec4 drop_shadow_color : source_color = vec4(vec3(0), float(0.5));
uniform vec2 shadow_offset = vec2(float(0), float(0.1));

uniform sampler2D noise:repeat_enable,filter_linear_mipmap;
uniform float distortion_str = 0.1;
uniform float frame_time = 0.2;

varying vec2 uv;

void vertex() {
	float max_offset = abs(shadow_offset.x);
	if (abs(shadow_offset.y) > abs(shadow_offset.x)) {
		max_offset = abs(shadow_offset.y);
	}
	VERTEX *= float(1) + float(2) * max_offset;
}
vec4 sample_texture(sampler2D texture, vec2 tex_uv)  {
	if ((tex_uv.x < 0.0 || tex_uv.x > 1.0) || (tex_uv.y < 0.0 || tex_uv.y > 1.0))  {
		return vec4(0.0);
	} else {
		return texture(texture, tex_uv);
	}
}
vec4 mixcolor(vec4 colA, vec4 colB)  {
	return vec4((colA.rgb + colB.a * (colB.rgb - colA.rgb)), colA.a + colB.a);
}
void fragment()  {
	
	//posterize time
	float rounded_time = round(TIME/ frame_time) * frame_time;
	
	
	
	float max_offset = abs(shadow_offset.x);
	if (abs(shadow_offset.y) > abs(shadow_offset.x)) {
		max_offset = abs(shadow_offset.y);
	}
	uv = UV * float(float(1) + float(2) * max_offset) - vec2(max_offset);
	
	vec2 noise_uv = UV * vec2(1.0) + 3.0 * rounded_time;
	float noise_tex = texture(noise, noise_uv).r;
	vec2 distorted_uv = uv + noise_tex * distortion_str;
	
	
	vec4 original_color = sample_texture(TEXTURE, distorted_uv)  * color_tint;
	original_color = mix(original_color,vec4(original_color.rgb,alpha),original_color.a);
	vec4 shadow_color = vec4(drop_shadow_color.rgb, sample_texture(TEXTURE, distorted_uv - shadow_offset).a * drop_shadow_color.a);
	if (shadow_color.a > float(0)) {
		COLOR = mixcolor(shadow_color, original_color);
	} else {
		COLOR = original_color;
	}
}