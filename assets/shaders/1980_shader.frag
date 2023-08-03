#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define iChannel2 bitmap
#define iChannelResolution bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform float uTime;
uniform vec4 iMouse;

#define V vec2(0.,1.)
#define PI 3.14159265
#define HUGE 1E9
#define VHSRES vec2(1280.0,720.0)
#define saturate(i) clamp(i,0.,1.)
#define lofi(i,d) floor(i/d)*d
#define validuv(v) (abs(v.x-0.5)<0.5&&abs(v.y-0.5)<0.5)

float v2random( vec2 uv ) {
  return texture( iChannel1, mod( uv, vec2( 1.0 ) ) ).x;
}

mat2 rotate2D( float t ) {
  return mat2( cos( t ), sin( t ), -sin( t ), cos( t ) );
}

vec3 rgb2yiq( vec3 rgb ) {
  return mat3( 0.299, 0.596, 0.211, 0.587, -0.274, -0.523, 0.114, -0.322, 0.312 ) * rgb;
}

vec3 yiq2rgb( vec3 yiq ) {
  return mat3( 1.000, 1.000, 1.000, 0.956, -0.272, -1.106, 0.621, -0.647, 1.703 ) * yiq;
}

#define SAMPLES 6

vec3 vhsTex2D( vec2 uv, float rot ) {
  if ( validuv( uv ) ) {
    vec3 yiq = vec3( 0.0 );
    for ( int i = 0; i < SAMPLES; i ++ ) {
      yiq += (
        rgb2yiq( texture( iChannel0, uv - vec2( float( i ), 0.0 ) / VHSRES ).xyz ) *
        vec2( float( i ), float( SAMPLES - 1 - i ) ).yxx / float( SAMPLES - 1 )
      ) / float( SAMPLES ) * 2.0;
    }
    if ( rot != 0.0 ) { yiq.yz = rotate2D( rot ) * yiq.yz; }
    return yiq2rgb( yiq );
  }
  return vec3( 0.1, 0.1, 0.1 );
}

void mainImage(  ) {
  vec2 uv = fragCoord.xy / VHSRES;
  float time = iTime;

  vec2 uvn = uv;
  vec3 col = vec3( 0.0, 0.0, 0.0 );

  // tape wave
  uvn.x += ( v2random( vec2( uvn.y / 10.0, time / 10.0 ) / 1.0 ) - 0.5 ) / VHSRES.x * 1.0;
  uvn.x += ( v2random( vec2( uvn.y, time * 10.0 ) ) - 0.5 ) / VHSRES.x * 1.0;

  // tape crease
  float tcPhase = smoothstep( 0.9, 0.96, sin( uvn.y * 8.0 - ( time + 0.14 * v2random( time * vec2( 0.67, 0.59 ) ) ) * PI * 1.2 ) );
  float tcNoise = smoothstep( 0.3, 1.0, v2random( vec2( uvn.y * 4.77, time ) ) );
  float tc = tcPhase * tcNoise;
  uvn.x = uvn.x - tc / VHSRES.x * 8.0;

  // switching noise
  float snPhase = smoothstep( 6.0 / VHSRES.y, 0.0, uvn.y );
  uvn.y += snPhase * 0.3;
  uvn.x += snPhase * ( ( v2random( vec2( uv.y * 100.0, time * 10.0 ) ) - 0.5 ) / VHSRES.x * 24.0 );

  // fetch
  col = vhsTex2D( uvn, tcPhase * 0.2 + snPhase * 2.0 );

  // crease noise
  float cn = tcNoise * ( 0.3 + 0.7 * tcPhase );
  if ( 0.29 < cn ) {
    vec2 uvt = ( uvn + V.yx * v2random( vec2( uvn.y, time ) ) ) * vec2( 0.1, 1.0 );
    float n0 = v2random( uvt );
    float n1 = v2random( uvt + V.yx / VHSRES.x );
    if ( n1 < n0 ) {
      col = mix( col, 2.0 * V.yyy, pow( n0, 10.0 ) );
    }
  }

  // ac beat
  col *= 1.0 + 0.1 * smoothstep( 0.4, 0.6, v2random( vec2( 0.0, 0.1 * ( uv.y + time * 0.2 ) ) / 10.0 ) );

  // color noise
  col *= 0.9 + 0.1 * texture( iChannel1, mod( uvn * vec2( 1.0, 1.0 ) + time * vec2( 5.97, 4.45 ), vec2( 1.0 ) ) ).xyz;
  col = saturate( col );

  // yiq
  col = rgb2yiq( col );
  col = vec3( 0.1, -0.1, 0.0 ) + vec3( 0.9, 1.1, 1.5 ) * col;
  col = yiq2rgb( col );

  fragColor = vec4( col, 1.0 );
}