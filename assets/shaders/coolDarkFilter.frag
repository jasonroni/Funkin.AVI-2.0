#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

float noise(float x) {
 
    return fract(sin(x) * 100000.);
    
}

float tape(vec2 uv) {
 
	float t = iTime / 4.;
    vec3 tex = texture(iChannel1, vec2(uv.x, uv.y - t)).xyz;
    
    float nx = (tex.x + tex.y + tex.z) / 3.;
    vec3 amn = tex * noise(uv.y + t);
    
    return (amn.x + amn.y + amn.z) / 3.;
    
}

void mainImage(  )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    float t = tape(uv) * tape(-uv);
	vec3 noise = vec3(t) * 1.;
                      
 	fragColor = mix(texture(iChannel0, uv), vec4(noise,1.), .45);
}