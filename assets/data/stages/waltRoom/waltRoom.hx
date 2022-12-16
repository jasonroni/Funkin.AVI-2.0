var blackShit:FlxSprite;

function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.75;

	var pissOfGlory:FNFSprite = new FNFSprite(-450, -300).loadGraphic(Paths.image('walt-bg', 'data/stages/waltRoom/images'));
	pissOfGlory.scale.set(1, 1);
	pissOfGlory.updateHitbox();
	pissOfGlory.antialiasing = true;
	pissOfGlory.scrollFactor(1, 1);
	pissOfGlory.active = false;
	add(pissOfGlory);

	var vignette:FNFSprite = new FNFSprite(-250, -140).loadGraphic(Paths.image('vignetteOverlay', 'data/stages/waltRoom/images'));
	vignette.cameras = [PlayState.camAlt];
	vignette.scale.set(0.75, 0.75);
	vignette.antialiasing = true;
	vignette.scrollFactor();
	vignette.active = false;
	add(vignette);
	
	var waltInstructionsMain:FlxText = new FlxText(350, 500, 0, "Take Advantage of the SPACEBAR!", 30);
	waltInstructionsMain.cameras = [PlayState.camAlt];
	waltInstructionsMain.setFormat(Paths.font("splatter"), 30);
	waltInstructionsMain.borderSize = 2;
	waltInstructionsMain.borderQuality = 2;
	waltInstructionsMain.scrollFactor.set();
	add(waltInstructionsMain);

	var waltSubTxt:FlxText = new FlxText(waltInstructionsMain.x + 70, waltInstructionsMain.y + 40, 0, "(It Will Help You Regain Health When In Need)", 15);
	waltSubTxt.setFormat(Paths.font("splatter"), 15);
	waltSubTxt.cameras = [PlayState.camAlt];
	waltSubTxt.borderSize = 2;
	waltSubTxt.borderQuality = 2;
	waltSubTxt.alpha = 0;
	waltSubTxt.scrollFactor.set();
	add(waltSubTxt);
	
	blackShit = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
		-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
	blackShit.scrollFactor.set();
	blackShit.cameras = [PlayState.camAlt];
	blackShit.alpha = 0;
	add(blackShit);


	FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(0, 0);
    	boyfriend.setPosition(330, 300); //make sure to replace bf with a first-person pov variant
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	PlayState.health -= 0.07;
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	if(PlayState.health <= 0.1)
	{
		blackShit.alpha = 0.95;
	}else if (PlayState.health <= 0.2)
	{
		blackShit.alpha = 0.9;
	}else if (PlayState.health <= 0.3)
	{
		blackShit.alpha = 0.85;
	}else if (PlayState.health <= 0.4)
	{
		blackShit.alpha = 0.8;
	}else if (PlayState.health <= 0.5)
	{
		blackShit.alpha = 0.75;
	}else if (PlayState.health <= 0.6)
	{
		blackShit.alpha = 0.7;
	}else if (PlayState.health <= 0.7)
	{
		blackShit.alpha = 0.65;
	}else if (PlayState.health <= 0.8)
	{
		blackShit.alpha = 0.6;
	}else if (PlayState.health <= 0.9)
	{
		blackShit.alpha = 0.55;
	}else if (PlayState.health <= 1)
	{
		blackShit.alpha = 0.5;
	}else if (PlayState.health <= 1.1)
	{
		blackShit.alpha = 0.45;
	}else if (PlayState.health <= 1.2)
	{
		blackShit.alpha = 0.4;
	}else if (PlayState.health <= 1.3)
	{
		blackShit.alpha = 0.35;
	}else if (PlayState.health <= 1.4)
	{
		blackShit.alpha = 0.3;
	}else if (PlayState.health <= 1.5)
	{
		blackShit.alpha = 0.25;
	}else if (PlayState.health <= 1.6)
	{
		blackShit.alpha = 0.2;
	}else if (PlayState.health <= 1.7)
	{
		blackShit.alpha = 0.15;
	}else if (PlayState.health <= 1.8)
	{
		blackShit.alpha = 0.1;
	}else if (PlayState.health <= 1.9)
	{
		blackShit.alpha = 0.05;
	}else if (PlayState.health <= 2)
	{
		blackShit.alpha = 0;
	}

	if(FlxG.keys.justPressed.SPACE && PlayState.health < 0.25)
	{
		PlayState.health += 1.25;
	}
}
