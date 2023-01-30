var datTV:FlxSprite;

var holyShitStatic:FlxRuntimeShader;

var shaderTime:Float = 0;

function onCreate()
{
  	spawnGirlfriend(false);
	hideBoyfriend(true);
	
	PlayState.defaultCamZoom = 0.85;

	holyShitStatic = new FlxRuntimeShader(File.getContent('./assets/shaders/tvStatic.frag', null, 120));

	PlayState.camGame.setFilters(
	[
		new ShaderFilter(holyShitStatic)
	]);
	
  
  var thePath:String = 'data/stages/staticVoid/images';
  
  var whoaBlackBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(2000, 2000, 0x000000);
  whoaBlackBG.screenCenter();
  add(whoaBlackBG);
  
  datTV = new FlxSprite(-250, -160);
	datTV.frames = Paths.getSparrowAtlas('white', thePath);
  datTV.animation.addByPrefix('idle', 'white idle');
  datTV.animation.play('idle');
	datTV.scale.set(0.6, 0.6);
  datTV.alpha = 0.001;
  add(datTV);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (curBeat == 104)
	{
		datTV.alpha = 1;
		PlayState.camGame.flash(ForeverTools.returnColor("white"), 1);
	}
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
    shaderTime += elapsed;

    holyShitStatic.setFloat('uTime', shaderTime);
    holyShitStatic.setFloat('iTime', shaderTime);
}
    
