var pissOfGlory:FNFSprite;
var greaterPiss:FNFSprite;

var vhsFilter:FlxRuntimeShader;
var grainFilter:FlxRuntimeShader;
var shaderTime:Float = 0;

function onCreate()
{
	spawnGirlfriend(false);
	hideBoyfriend(true);
	
	PlayState.health = 1; // Hardcoding it breaks for some reason
	
	//PlayState.boyfriend.alpha = 0; //This crashes the game cause apparently, Character.hx doesn't have an "alpha" value.
	PlayState.defaultCamZoom = 0.75;

	if (PlayState.SONG.song == 'Mercy')
	{
		PlayState.camGame.alpha = 0;
		PlayState.camHUD.alpha = 0;
		//PlayState.dadStrums.visible = false;

		pissOfGlory = new FNFSprite(-470, -280);
		pissOfGlory.loadGraphic(Paths.image('newWaltBG', 'data/stages/waltRoom/images'));
		pissOfGlory.scale.set(1.7, 1.7);
	}else{
		pissOfGlory = new FNFSprite(-450, -300);
		pissOfGlory.loadGraphic(Paths.image('walt-bg', 'data/stages/waltRoom/images'));
		pissOfGlory.scale.set(1, 1);
	}
	pissOfGlory.updateHitbox();
	pissOfGlory.antialiasing = true;
	pissOfGlory.scrollFactor(1, 1);
	pissOfGlory.active = false;
	add(pissOfGlory);

	greaterPiss = new FNFSprite(-60, -70);
	greaterPiss.loadGraphic(Paths.image('inkWaltBG', 'data/stages/waltRoom/images'));
	greaterPiss.scale.set(1.7, 1.7);
	greaterPiss.alpha = 0;
	add(greaterPiss);

	var vignette:FNFSprite = new FNFSprite(-250, -140).loadGraphic(Paths.image('vignetteOverlay', 'data/stages/waltRoom/images'));
	vignette.cameras = [PlayState.camAlt];
	vignette.scale.set(0.75, 0.75);
	vignette.antialiasing = true;
	vignette.scrollFactor();
	vignette.active = false;
	add(vignette);

	var waltInstructionsMain:FlxText = new FlxText(370, 500, 0, "Take Advantage of the SPACEBAR!", 30);
	waltInstructionsMain.cameras = [PlayState.camAlt];
	waltInstructionsMain.setFormat(Paths.font("splatter"), 30);
	waltInstructionsMain.borderSize = 2;
	waltInstructionsMain.borderQuality = 2;
	waltInstructionsMain.scrollFactor.set();
	add(waltInstructionsMain);

	var waltSubTxt:FlxText = new FlxText(waltInstructionsMain.x + 66, waltInstructionsMain.y + 40, 0, "(It will help you regain health when critically low)", 15);
	waltSubTxt.setFormat(Paths.font("splatter"), 15);
	waltSubTxt.cameras = [PlayState.camAlt];
	waltSubTxt.borderSize = 2;
	waltSubTxt.borderQuality = 2;
	waltSubTxt.alpha = 0;
	waltSubTxt.scrollFactor.set();
	add(waltSubTxt);

	FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});

	vhsFilter = new FlxRuntimeShader(File.getContent("./assets/shaders/vhs.frag"), null, 130);

	grainFilter = new FlxRuntimeShader(File.getContent("./assets/shaders/filmgrain.frag"), null, 150);

	PlayState.camGame.setFilters(
		[
			new ShaderFilter(vhsFilter),
			new ShaderFilter(grainFilter),
		]);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(0, 0);
    	boyfriend.setPosition(330, 300); //make sure to replace bf with a first-person pov variant
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	//Shader stuff
	shaderTime += elapsed;
	vhsFilter.setFloat('time', shaderTime);
	grainFilter.setFloat('time', shaderTime);
}
