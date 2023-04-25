package base.events;

import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.system.FlxAssets.FlxShader;

class CamChromZoom extends FlxBasic
{
    public var shader(default, null):ChromZoom = new ChromZoom();

    var iTime:Float = 0;

    public var amount(default, set):Float = 0;

    public function new(_amount:Float):Void{
        super();
       // shader.iResolution.value = [FlxG.stage.stageWidth, FlxG.stage.stageHeight];
        amount = _amount;
    }

    override public function update(elapsed:Float):Void{
        super.update(elapsed);
    }
    
    function set_amount(v:Float):Float{
		amount = v;
		shader.amount.value = [amount];
       // shader.iResolution.value = [FlxG.stage.stageWidth, FlxG.stage.stageHeight];
		return v;
	}
}

class CamChromNormal extends FlxBasic
{
    public var shader(default, null):ChromOld = new ChromOld();

    var iTime:Float = 0;

    public var offset(default, set):Float = 0;

    public function new (_offset:Float):Void
    {
        super();

        offset = _offset;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    function set_offset(r:Float):Float
    {
        offset = r;
        shader.rOffset.value = [offset];
        shader.bOffset.value = [-offset];
        return r;
    }
}

class CamBlur extends FlxBasic
{
    public var shader(default, null):BlurShader = new BlurShader();

    var iTime:Float = 0;

    public var blur(default, set):Float = 0;

    public function new (_blur:Float):Void
    {
        super();

        blur = _blur;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    function set_blur(b:Float):Float
    {
        blur = b;
        shader.bluramount.value = [blur];
        return b;
    }
}

class ChromZoom extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float amount;

    vec2 PincushionDistortion(in vec2 uv, float strength) 
    {
	    vec2 st = uv - 0.5;
        float uvA = atan(st.x, st.y);
        float uvD = dot(st, st);
        return 0.5 + vec2(sin(uvA), cos(uvA)) * sqrt(uvD) * (1.0 - strength * uvD);
    }

    vec3 ChromaticAbberation(sampler2D tex, in vec2 uv) 
    {
	    float rChannel = texture(tex, PincushionDistortion(uv, 0.3 * amount)).r;
        float gChannel = texture(tex, PincushionDistortion(uv, 0.15 * amount)).g;
        float bChannel = texture(tex, PincushionDistortion(uv, 0.075 * amount)).b;
        vec3 retColor = vec3(rChannel, gChannel, bChannel);
        return retColor;
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        vec3 col = ChromaticAbberation(bitmap, uv);
    
        gl_FragColor = vec4(col, 1.0);
    }')

    public function new()
    {
        super();
    }
}

class ChromOld extends FlxShader
{
	@:glFragmentSource('
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
		}')
	public function new()
	{
		super();
	}
}

class BlurShader extends FlxShader
{
	@:glFragmentSource('
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
		 
				   That means a total of 9 "taps", it touches the texture to sample 9 times.
		 
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
		}')
	public function new()
	{
		super();
	}
}