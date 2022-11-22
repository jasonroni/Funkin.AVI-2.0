#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform float amount = 0.0;
void mainImage()
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    amount = (1.0 + sin(iTime*24.0)) * 0.2;
    amount *= 1.0 + sin(iTime*64.0) * 0.2;
    amount *= 1.0 + sin(iTime*76.0) * 0.2;
    amount *= 1.0 + sin(iTime*108.0) * 0.2;
    amount = pow(amount, 1.0);

    amount *= 0.05;
    
    vec3 col;
    col.r = texture( iChannel0, vec2(uv.x+amount,uv.y) ).r;
    col.g = texture( iChannel0, uv ).g;
    col.b = texture( iChannel0, vec2(uv.x-amount,uv.y) ).b;

    col *= (1.0 - amount * 0.5);
    
    fragColor = vec4(col,1.0);
}