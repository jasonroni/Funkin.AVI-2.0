package base.dependency;

/**
 * hardcoded shaders fragment code
 * 
 * @see [The Shadertoy page](https://shadertoy.com)
 */
enum abstract Shaders(String) from String to String
{
    /**
     * Aberration shader
     * 
     * @param aberration aberration value
     * @param effectTime the effect time to set to the shader
     */
    var aberration =
    "
    #pragma header
    /*
    https://www.shadertoy.com/view/wtt3z2
    */

    uniform float aberration = 0.0;
    uniform float effectTime = 0.0;

    vec3 tex2D(sampler2D _tex,vec2 _p)
    {
        vec3 col=texture(_tex,_p).xyz;
        if(.5<abs(_p.x-.5)){
            col=vec3(.1);
        }
        return col;
    }

    void main() {
        vec2 uv = openfl_TextureCoordv; //openfl_TextureCoordv.xy*2. / openfl_TextureSize.xy-vec2(1.);
        vec2 ndcPos = uv * 2.0 - 1.0;
        float aspect = openfl_TextureSize.x / openfl_TextureSize.y;
        
        //float u_angle = -2.4;
        
        float u_angle = -2.4 * sin(effectTime * 2.0);
        
        float eye_angle = abs(u_angle);
        float half_angle = eye_angle/2.0;
        float half_dist = tan(half_angle);

        vec2  vp_scale = vec2(aspect, 1.0);
        vec2  P = ndcPos * vp_scale; 
        
        float vp_dia = length(vp_scale);
        vec2  rel_P = normalize(P) / normalize(vp_scale);

        vec2 pos_prj = ndcPos;

        float beta = abs(atan((length(P) / vp_dia) * half_dist) * -abs(cos(effectTime - 0.25 + 0.5)));
        pos_prj = rel_P * beta / half_angle;

        vec2 uv_prj = (pos_prj * 0.5 + 0.5);

        vec2 trueAberration = aberration * pow((uv_prj.st - 0.5), vec2(3.0, 3.0));
        // vec4 texColor = tex2D(bitmap, uv_prj.st);
        gl_FragColor = vec4(
            texture(bitmap, uv_prj.st + trueAberration).r, 
            texture(bitmap, uv_prj.st).g, 
            texture(bitmap, uv_prj.st - trueAberration).b, 
            1.0
        );
    }
    ";

    /**
     * Shader which turns everything into black and white
     * 
     * no values needed
     */
    var grayScale = 
    "
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
    ";

    /**
     * sets a glitch shader to the camera
     * 
     * @param time shader time
     * @param prob to be honest i don't know what does it do
     * @param vignetteIntensity intensity of the glitch, default is by 0.75
     */
    var vignetteGlitch =
    "
    // https://www.shadertoy.com/view/XtyXzW

    #pragma header
    #extension GL_EXT_gpu_shader4 : enable

    uniform float time = 0.0;
    uniform float prob = 0.0;
    uniform float vignetteIntensity = 0.75;

    float _round(float n) {
        return floor(n + .5);
    }

    vec2 _round(vec2 n) {
        return floor(n + .5);
    }

    vec3 tex2D(sampler2D _tex,vec2 _p)
    {
        vec3 col=texture(_tex,_p).xyz;
        if(.5<abs(_p.x-.5)){
            col=vec3(.1);
        }
        return col;
    }

    #define PI 3.14159265359
    #define PHI (1.618033988749895)

    // --------------------------------------------------------
    // Glitch core
    // --------------------------------------------------------

    float rand(vec2 co){
        return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
    }

    const float glitchScale = .5;

    vec2 glitchCoord(vec2 p, vec2 gridSize) {
        vec2 coord = floor(p / gridSize) * gridSize;;
        coord += (gridSize / 2.);
        return coord;
    }

    struct GlitchSeed {
        vec2 seed;
        float prob;
    };
        
    float fBox2d(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
    }

    GlitchSeed glitchSeed(vec2 p, float speed) {
        float seedTime = floor(time * speed);
        vec2 seed = vec2(
            1. + mod(seedTime / 100., 100.),
            1. + mod(seedTime, 100.)
        ) / 100.;
        seed += p; 
        return GlitchSeed(seed, prob);
    }

    float shouldApply(GlitchSeed seed) {
        return round(
            mix(
                mix(rand(seed.seed), 1., seed.prob - .5),
                0.,
                (1. - seed.prob) * .5
            )
        );
    }

    // gamma again 
    const float GAMMA = 1;

    vec3 gamma(vec3 color, float g) {
        return pow(color, vec3(g));
    }

    vec3 linearToScreen(vec3 linearRGB) {
        return gamma(linearRGB, 1.0 / GAMMA);
    }

    // --------------------------------------------------------
    // Glitch effects
    // --------------------------------------------------------

    // Swap

    vec4 swapCoords(vec2 seed, vec2 groupSize, vec2 subGrid, vec2 blockSize) {
        vec2 rand2 = vec2(rand(seed), rand(seed+.1));
        vec2 range = subGrid - (blockSize - 1.);
        vec2 coord = floor(rand2 * range) / subGrid;
        vec2 bottomLeft = coord * groupSize;
        vec2 realBlockSize = (groupSize / subGrid) * blockSize;
        vec2 topRight = bottomLeft + realBlockSize;
        topRight -= groupSize / 2.;
        bottomLeft -= groupSize / 2.;
        return vec4(bottomLeft, topRight);
    }

    float isInBlock(vec2 pos, vec4 block) {
        vec2 a = sign(pos - block.xy);
        vec2 b = sign(block.zw - pos);
        return min(sign(a.x + a.y + b.x + b.y - 3.), 0.);
    }

    vec2 moveDiff(vec2 pos, vec4 swapA, vec4 swapB) {
        vec2 diff = swapB.xy - swapA.xy;
        return diff * isInBlock(pos, swapA);
    }

    void swapBlocks(inout vec2 xy, vec2 groupSize, vec2 subGrid, vec2 blockSize, vec2 seed, float apply) {
        
        vec2 groupOffset = glitchCoord(xy, groupSize);
        vec2 pos = xy - groupOffset;
        
        vec2 seedA = seed * groupOffset;
        vec2 seedB = seed * (groupOffset + .1);
        
        vec4 swapA = swapCoords(seedA, groupSize, subGrid, blockSize);
        vec4 swapB = swapCoords(seedB, groupSize, subGrid, blockSize);
        
        vec2 newPos = pos;
        newPos += moveDiff(pos, swapA, swapB) * apply;
        newPos += moveDiff(pos, swapB, swapA) * apply;
        pos = newPos;
        
        xy = pos + groupOffset;
    }


    // Static

    void staticNoise(inout vec2 p, vec2 groupSize, float grainSize, float contrast) {
        GlitchSeed seedA = glitchSeed(glitchCoord(p, groupSize), 5.);
        seedA.prob *= .5;
        if (shouldApply(seedA) == 1.) {
            GlitchSeed seedB = glitchSeed(glitchCoord(p, vec2(grainSize)), 5.);
            vec2 offset = vec2(rand(seedB.seed), rand(seedB.seed + .1));
            offset = round(offset * 2. - 1.);
            offset *= contrast;
            p += offset;
        }
    }

    // --------------------------------------------------------
    // Glitch compositions
    // --------------------------------------------------------

    void glitchSwap(inout vec2 p) {
        vec2 pp = p;
        
        float scale = glitchScale;
        float speed = 5.;
        
        vec2 groupSize;
        vec2 subGrid;
        vec2 blockSize;    
        GlitchSeed seed;
        float apply;
        
        groupSize = vec2(.6) * scale;
        subGrid = vec2(2);
        blockSize = vec2(1);

        seed = glitchSeed(glitchCoord(p, groupSize), speed);
        apply = shouldApply(seed);
        swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);
        
        groupSize = vec2(.8) * scale;
        subGrid = vec2(3);
        blockSize = vec2(1);
        
        seed = glitchSeed(glitchCoord(p, groupSize), speed);
        apply = shouldApply(seed);
        swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);

        groupSize = vec2(.2) * scale;
        subGrid = vec2(6);
        blockSize = vec2(1);
        
        seed = glitchSeed(glitchCoord(p, groupSize), speed);
        float apply2 = shouldApply(seed);
        swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 1.), apply * apply2);
        swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 2.), apply * apply2);
        swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 3.), apply * apply2);
        swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 4.), apply * apply2);
        swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 5.), apply * apply2);
        
        groupSize = vec2(1.2, .2) * scale;
        subGrid = vec2(9,2);
        blockSize = vec2(3,1);
        
        seed = glitchSeed(glitchCoord(p, groupSize), speed);
        apply = shouldApply(seed);
        swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);
    }

    void glitchStatic(inout vec2 p) {
        staticNoise(p, vec2(.5, .25/2.) * glitchScale, .2 * glitchScale, 2.);
    }


    void main() {
        // time = mod(time, 1.);
        float alpha = openfl_Alphav;
        vec2 p = openfl_TextureCoordv.xy;
        vec3 basecolor = texture2D(bitmap, openfl_TextureCoordv).rgb;
        
        glitchSwap(p);
        glitchStatic(p);

        vec3 color = texture2D(bitmap, p).rgb;

        float amount = (0.5 * sin(time * PI) + vignetteIntensity);
        float vignette = distance(openfl_TextureCoordv, vec2(0.5));
        //
        vignette = mix(1.0, 1.0 - amount, vignette);
        //
        gl_FragColor = vec4(mix(color.rgb, basecolor.rgb, vignette), 1.0);
    }
    ";

    /**
     * The truly overrated & overused Andromeda Engine shader, used for legacy songs
     * 
     * @param iTime the time to set to the shader
     * @param glitchModifier the glitch modifer to set to the shader
     * @param perspectiveOn sets a perspective to the shader
     * @param vignetteMoving sets if the shader's viggete should move
     * @param scanlinesOn sets if the scanlines are on
     * @param distortionOn sets if the shader should have distortion on
     */
    var andromedaVCR = 
    "
    #pragma header

    uniform float iTime;
    uniform bool vignetteOn;
    uniform bool perspectiveOn;
    uniform bool distortionOn;
    uniform bool scanlinesOn;
    uniform bool vignetteMoving;
   // uniform sampler2D noiseTex;
    uniform float glitchModifier;
    vec2 iResolution = openfl_TextureSize;

    float onOff(float a, float b, float c)
    {
    	return step(c, sin(iTime + a*cos(iTime*b)));
    }

    float ramp(float y, float start, float end)
    {
    	float inside = step(start,y) - step(end,y);
    	float fact = (y-start)/(end-start)*inside;
    	return (1.-fact) * inside;

    }

    vec4 getVideo(vec2 uv)
      {
      	vec2 look = uv;
        if(distortionOn){
        	float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
        	look.x = look.x + (sin(look.y*10. + iTime)/50.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window)*(glitchModifier*2);
        	float vShift = 0.4*onOff(2.,3.,.9)*(sin(iTime)*sin(iTime*20.) +
        										 (0.5 + 0.1*sin(iTime*200.)*cos(iTime)));
        	look.y = mod(look.y + vShift*glitchModifier, 1.);
        }
      	vec4 video = flixel_texture2D(bitmap,look);

      	return video;
      }

    vec2 screenDistort(vec2 uv)
    {
      if(perspectiveOn){
        uv = (uv - 0.5) * 2.0;
      	uv *= 1.1;
      	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
      	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
      	uv  = (uv / 2.0) + 0.5;
      	uv =  uv *0.92 + 0.04;
      	return uv;
      }
    	return uv;
    }
    float random(vec2 uv)
    {
     	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
    }
    float noise(vec2 uv)
    {
     	vec2 i = floor(uv);
        vec2 f = fract(uv);

        float a = random(i);
        float b = random(i + vec2(1.,0.));
    	float c = random(i + vec2(0., 1.));
        float d = random(i + vec2(1.));

        vec2 u = smoothstep(0., 1., f);

        return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;

    }


    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 2.0 + iTime), 0.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 2.0 + iTime + 4.0) * 10.0, 0.0, 1.0) ;
    	float amount = scan1 * scan2 * uv.x;

    	//uv.x -= 0.05 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.9);

    	return uv;

    }
    void main()
    {
    	vec2 uv = openfl_TextureCoordv;
      vec2 curUV = screenDistort(uv);
    	uv = scandistort(curUV);
    	vec4 video = getVideo(uv);
      float vigAmt = 1.0;
      float x =  0.;


      video.r = getVideo(vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
      video.g = getVideo(vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
      video.b = getVideo(vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
      video.r += 0.08*getVideo(0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
      video.g += 0.05*getVideo(0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
      video.b += 0.08*getVideo(0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

      video = clamp(video*0.6+0.4*video*video*1.0,0.0,1.0);
      if(vignetteMoving)
    	  vigAmt = 3.+.3*sin(iTime + 5.*cos(iTime*5.));

    	float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));

      if(vignetteOn)
    	 video *= vignette;


      gl_FragColor = mix(video,vec4(noise(uv * 75.)),.05);

      if(curUV.x<0 || curUV.x>1 || curUV.y<0 || curUV.y>1){
        gl_FragColor = vec4(0,0,0,0);
      }

    }
    ";
    
    /**
     * Ditto as ```aberration```, but it doesn't have ```effectTime``` meaning that it does not have a zoom on it
     * 
     * @param rOffset the red color offset to set
     * @param gOffset same as ```rOffset``` but green
     * @param bOffset same as ```rOffset``` but blue
     */
    var aberrationDefault = 
    "
    #pragma header

    uniform float rOffset;
    uniform float gOffset;
    uniform float bOffset;

    void main()
    {
        vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset, 0.0));
        vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(gOffset, 0.0));
        vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(bOffset, 0.0));
        vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
        toUse.r = col1.r;
        toUse.g = col2.g;
        toUse.b = col3.b;
        //float someshit = col4.r + col4.g + col4.b;

        gl_FragColor = toUse;
    }
    ";

    /**
     * **Modified version of a tilt shift shader from Martin Jonasson (http://grapefrukt.com/)**
     * 
     * Sets a Tilt Shift shader which is also declarated as a Blur shader
     * 
     * @param bluramount the blur amount to set
     * @param center how centered the shader should be
     * @param steps steps to set
     * @param stepSize sets the ```steps``` value size
     */
    var tiltShift =
    "
    #pragma header

		// Modified version of a tilt shift shader from Martin Jonasson (http://grapefrukt.com/)
		// Read http://notes.underscorediscovery.com/ for context on shaders and this file
		// License : MIT
		 
			/*
				Take note that blurring in a single pass (the two for loops below) is more expensive than separating
				the x and the y blur into different passes. This was used where bleeding edge performance
				was not crucial and is to illustrate a point. 
		 
				The reason two passes is cheaper? 
				   texture2D is a fairly high cost call, sampling a texture.
		 
				   So, in a single pass, like below, there are 3 steps, per x and y. 
		 
				   That means a total of 9 'taps', it touches the texture to sample 9 times.
		 
				   Now imagine we apply this to some geometry, that is equal to 16 pixels on screen (tiny)
				   (16 * 16) * 9 = 2304 samples taken, for width * height number of pixels, * 9 taps
				   Now, if you split them up, it becomes 3 for x, and 3 for y, a total of 6 taps
				   (16 * 16) * 6 = 1536 samples
			
				   That\'s on a *tiny* sprite, let\'s scale that up to 128x128 sprite...
				   (128 * 128) * 9 = 147,456
				   (128 * 128) * 6 =  98,304
		 
				   That\'s 33.33..% cheaper for splitting them up.
				   That\'s with 3 steps, with higher steps (more taps per pass...)
		 
				   A really smooth, 6 steps, 6*6 = 36 taps for one pass, 12 taps for two pass
				   You will notice, the curve is not linear, at 12 steps it\'s 144 vs 24 taps
				   It becomes orders of magnitude slower to do single pass!
				   Therefore, you split them up into two passes, one for x, one for y.
			*/
		 
		// I am hardcoding the constants like a jerk
			
		uniform float bluramount  = 1.0;
		uniform float center      = 1.0;
		const float stepSize    = 0.004;
		const float steps       = 3.0;
		 
		const float minOffs     = (float(steps-1.0)) / -2.0;
		const float maxOffs     = (float(steps-1.0)) / +2.0;
		 
		void main() {
			float amount;
			vec4 blurred;
				
			// Work out how much to blur based on the mid point 
			amount = pow((openfl_TextureCoordv.y * center) * 2.0 - 1.0, 2.0) * bluramount;
				
			// This is the accumulation of color from the surrounding pixels in the texture
			blurred = vec4(0.0, 0.0, 0.0, 1.0);
				
			// From minimum offset to maximum offset
			for (float offsX = minOffs; offsX <= maxOffs; ++offsX) {
				for (float offsY = minOffs; offsY <= maxOffs; ++offsY) {
		 
					// copy the coord so we can mess with it
					vec2 temp_tcoord = openfl_TextureCoordv.xy;
		 
					//work out which uv we want to sample now
					temp_tcoord.x += offsX * amount * stepSize;
					temp_tcoord.y += offsY * amount * stepSize;
		 
					// accumulate the sample 
					blurred += texture2D(bitmap, temp_tcoord);
				}
			} 
				
			// because we are doing an average, we divide by the amount (x AND y, hence steps * steps)
			blurred /= float(steps * steps);
		 
			// return the final blurred color
			gl_FragColor = blurred;
		}
    ";

    /**
     * Sets a bloom shader made by BBPanzu
     * 
     * @param amount the amount of the bloom
     * @param Directions The directions of the shader
     * @param Quality the quality to set
     * @param Size the bloom shader size 
     */
    var bloom =
    "
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

    //BLOOM SHADER BY BBPANZU

    const float amount = 1;

    // GAUSSIAN BLUR SETTINGS
    float dim = 1.8;
    float Directions = 20.0;
    float Quality = 20.0; 
    float Size = 20.0; 
    vec2 Radius = Size/openfl_TextureSize.xy;

    void mainImage()
    { 
        vec2 uv = openfl_TextureCoordv.xy ;

    float Pi = 6.28318530718; // Pi*2
        
    vec4 Color = texture2D( bitmap, uv);
    
    for( float d=0.0; d<Pi; d+=Pi/Directions){
    for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality){
    float ex = (cos(d)*Size*i)/openfl_TextureSize.x;
    float why = (sin(d)*Size*i)/openfl_TextureSize.y;

    Color += flixel_texture2D( bitmap, uv+vec2(ex,why));	
        }
    }
        
    Color /= (dim * Quality) * Directions - 15.0;
    vec4 bloom =  (flixel_texture2D( bitmap, uv)/ dim)+Color;

    gl_FragColor = bloom;

    }
    ";

    @:noCompletion var bloom_alt = 
    "
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

    //BLOOM SHADER BY BBPANZU

    const float amount = 1;

    // GAUSSIAN BLUR SETTINGS
    float dim = 2;
    float Directions = 17.0;
    float Quality = 20.0; 
    float Size = 22.0; 
    vec2 Radius = Size/openfl_TextureSize.xy;

    void mainImage()
    { 
        vec2 uv = openfl_TextureCoordv.xy ;

    float Pi = 6.28318530718; // Pi*2
        
    vec4 Color = texture2D( bitmap, uv);
    
    for( float d=0.0; d<Pi; d+=Pi/Directions){
    for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality){
    float ex = (cos(d)*Size*i)/openfl_TextureSize.x;
    float why = (sin(d)*Size*i)/openfl_TextureSize.y;

    Color += flixel_texture2D( bitmap, uv+vec2(ex,why));	
        }
    }
        
    Color /= (dim * Quality) * Directions - 15.0;
    vec4 bloom =  (flixel_texture2D( bitmap, uv)/ dim)+Color;

    gl_FragColor = bloom;

    }
    ";

    /*
    * Filter used for Credits Menu
    */
    var filter1990 =
    "
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
    ";

    /*
    * Don't Cross Freeplay Shader
    */
    var theBlurOf87 =
    "
	//source: https://www.shadertoy.com/view/fsV3R3

	#pragma header
	
	uniform float iTime;
	
	vec2 iResolution = openfl_TextureSize;
	
	uniform float amount = 0.5;
	
	const float pi = radians(180.);
	const int samples = 20;
	const float sigma = float(samples) * 0.25;
	
	// we don't need to recalculate these every time
	const float sigma2 = 2. * sigma * sigma;
	const float pisigma2 = pi * sigma2;
	
	float gaussian(vec2 i) {
	    float top = exp(-((i.x * i.x) + (i.y * i.y)) / sigma2);
	    float bot = pisigma2;
	    return top / bot;
	}
	
	vec3 blur(sampler2D sp, vec2 uv, vec2 scale) {
	    vec2 offset;
	    float weight = gaussian(offset);
	    vec3 col = texture2D(sp, uv).rgb * weight;
	    float accum = weight * amount;
	    
	    // we need to use x <= samples / 2
	    // to ensure symmetry
	    for (int x = 0; x <= samples / 2; ++x) {
	        for (int y = 1; y <= samples / 2; ++y) {
	            offset = vec2(x, y);
	            weight = gaussian(offset);
	            col += texture2D(sp, uv + scale * offset).rgb * weight;
	            accum += weight;
	
	            // since values are symmetrical
	            // we can re-use the 'weight' value, saving 3 function calls
	
	            col += texture2D(sp, uv - scale * offset).rgb * weight;
	            accum += weight;
	
	            offset = vec2(-y, x);
	            col += texture2D(sp, uv + scale * offset).rgb * weight;
	            accum += weight;
	
	            col += texture2D(sp, uv - scale * offset).rgb * weight;
	            accum += weight;
	        }
	    }
	    
	    return col / accum;
	}
	
	void main() {
	    vec2 fragCoord = openfl_TextureCoordv * iResolution;
	
	    vec2 ps = vec2(1.0) / iResolution.xy;
	    vec2 uv = fragCoord * ps;
	
	    gl_FragColor = vec4(blur(bitmap, uv, ps * amount), texture2D(bitmap,uv).a);
	}
    ";

    /*
    * For Dramatic Effect on the Cam movement
    */
    var cameraMovement = 
    "
	#pragma header

	uniform float time = 0.0;
	
	vec2 ShakeUV(vec2 uv, float time) {
	    uv.x += 0.002 * sin(time*3.141) * sin(time*14.14);
	    uv.y += 0.002 * sin(time*1.618) * sin(time*17.32);
	    return uv;
	}
	
	void main() {
	    gl_FragColor = texture2D(bitmap, ShakeUV(openfl_TextureCoordv, time / 2.0));
	}
    ";

    /*
    * The Shader that's used on basically everything in the game except for certain songs
    */
    var monitorFilter =
    "
    	#pragma header

	float zoom = 1;
	void main()
	{
	    vec2 uv = openfl_TextureCoordv;
	    uv = (uv-.5)*2.;
	    uv *= zoom;
	    
	    uv.x *= 1. + pow(abs(uv.y/2.),3.);
	    uv.y *= 1. + pow(abs(uv.x/2.),3.);
	    uv = (uv + 1.)*.5;
	    
	    vec4 tex = vec4( 
	        texture2D(bitmap, uv+.001).r,
	        texture2D(bitmap, uv).g,
	        texture2D(bitmap, uv-.001).b, 
	        1.0
	    );
	    
	    tex *= smoothstep(uv.x,uv.x+0.01,1.)*smoothstep(uv.y,uv.y+0.01,1.)*smoothstep(-0.01,0.,uv.x)*smoothstep(-0.01,0.,uv.y);
	    
	    float avg = (tex.r+tex.g+tex.b)/3.;
	    gl_FragColor = tex + pow(avg,3.);
	}
    ";
}
