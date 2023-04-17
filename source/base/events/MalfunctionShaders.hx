/*
* This class was made specifically so Malfunction's shader effects
* can be hardcoded AND hopefully reduce the lag the script is giving
* due to how fucking unoptimized the code for it is..
*
* Shaders in this class are:
* - Tiltshift
* - Chromatic Aberration (Normal)
* - Chromatic Aberration (Zoom)
*
* @author DEMOLITIONDON96
*/

package base.events;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import states.PlayState;

class Effect {
	public function setValue(shader:FlxShader, variable:String, value:Float){
		Reflect.setProperty(Reflect.getProperty(shader, 'variable'), 'value', [value]);
	}

}

class BuildingEffect {
  public var shader:BuildingShader = new BuildingShader();
  public function new(){
    shader.alphaShit.value = [0];
  }
  public function addAlpha(alpha:Float){
    trace(shader.alphaShit.value[0]);
    shader.alphaShit.value[0]+=alpha;
  }
  public function setAlpha(alpha:Float){
    shader.alphaShit.value[0]=alpha;
  }
}

class BuildingShader extends FlxShader
{
  @:glFragmentSource('
    #pragma header
    uniform float alphaShit;
    void main()
    {

      vec4 color = flixel_texture2D(bitmap,openfl_TextureCoordv);
      if (color.a > 0.0)
        color-=alphaShit;

      gl_FragColor = color;
    }
  ')
  public function new()
  {
    super();
  }
}

class MalfunctionLegacyShader extends FlxShader
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

class MalfunctionLegacyEffect extends Effect
{
	public var shader:MalfunctionLegacyShader;
  public function new(offset:Float = 0.00){
	shader = new MalfunctionLegacyShader();
    shader.rOffset.value = [offset];
    shader.gOffset.value = [0.0];
    shader.bOffset.value = [-offset];
  }
	
	public function setChrome(chromeOffset:Float):Void
	{
		shader.rOffset.value = [chromeOffset];
		shader.gOffset.value = [0.0];
		shader.bOffset.value = [chromeOffset * -1];
	}

}

class MalfunctionNewShader extends FlxShader
{
	@:glFragmentSource('
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
}')
	public function new()
	{
		super();
	}
}

class MalfunctionNewEffect extends Effect
{
	public var shader:MalfunctionNewShader;
  public function new(aberration:Float = 0.0001, effectTime:Float = 0.0001){
	shader = new MalfunctionNewShader();
    shader.aberration.value = [aberration];
    shader.effectTime.value = [effectTime];
  }
	
	public function setAberration(aberrationOffset:Float):Void
	{
		shader.aberration.value = [aberrationOffset];
	}
  
  public function setEffectTime(effectOffset:Float):Void
  {
    shader.effectTime.value = [effectOffset];
  }
}

class FuckingBlurEffect extends Effect
{	
	public var shader:BlurryShit;
	public function new (blurAmount:Float, center:Float){
		shader = new BlurryShit();
    shader.bluramount.value = [blurAmount];
		shader.center.value = [center];
  }
  public function setBlur(blurAmount:Float){
    shader.bluramount.value = [blurAmount];
  }	
	
}

class BlurryShit extends FlxShader
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
