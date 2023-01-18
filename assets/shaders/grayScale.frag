#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
#define fragColor gl_FragColor
#define mainImage main

	void mainImage() {
		vec4 color = texture2D(bitmap, openfl_TextureCoordv);
		float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		fragColor = vec4(vec3(gray), color.a);
	}