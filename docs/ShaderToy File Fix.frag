//SHADERTOY PORT FIX (thx bb)
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//SHADERTOY PORT FIX
// Fork of "20151110_VHS" by FMS_Cat. https://shadertoy.com/view/XtBXDt
// 2020-03-25 02:11:48
