var gettingSleepy:FlxSprite;
var limitThing:Int = 0; //Default Value

function onCreate()
{
	spawnGirlfriend(false);
	
	//PlayState.boyfriend.alpha = 0; //This crashes the game cause apparently, Character.hx doesn't have an "alpha" value.
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
	
	var waltInstructionsMain:FlxText = new FlxText(370, 500, 0, "Take Advantage of the SPACEBAR!", 30);
	waltInstructionsMain.cameras = [PlayState.camAlt];
	waltInstructionsMain.setFormat(Paths.font("splatter"), 30);
	waltInstructionsMain.borderSize = 2;
	waltInstructionsMain.borderQuality = 2;
	waltInstructionsMain.scrollFactor.set();
	add(waltInstructionsMain);

	var waltSubTxt:FlxText = new FlxText(waltInstructionsMain.x + 85, waltInstructionsMain.y + 40, 0, "(It Will Help You Regain Health When In Need)", 15);
	waltSubTxt.setFormat(Paths.font("splatter"), 15);
	waltSubTxt.cameras = [PlayState.camAlt];
	waltSubTxt.borderSize = 2;
	waltSubTxt.borderQuality = 2;
	waltSubTxt.alpha = 0;
	waltSubTxt.scrollFactor.set();
	add(waltSubTxt);
	
	gettingSleepy = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
		-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
	gettingSleepy.scrollFactor.set();
	gettingSleepy.cameras = [PlayState.camAlt];
	gettingSleepy.alpha = 0; //Default value
	add(gettingSleepy);


	FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});

	if (PlayState.SONG.song == 'Mercy Legacy') limitThing += 12; else if (PlayState.SONG.song == 'Mercy') limitThing += 8; else limitThing += 5; //This line sets up the limit based on the song it's set on.
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(0, 0);
    	boyfriend.setPosition(330, 300); //make sure to replace bf with a first-person pov variant
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (PlayState.SONG.song == 'Mercy Legacy') //Health Drain Modchart
	{
		if (curBeat >= 0 && curBeat <= 63) PlayState.health -= 0.02;
		else if (curBeat >= 64 && curBeat <= 95) PlayState.health -= 0.2;
		else if (curBeat >= 96 && curBeat <= 127) PlayState.health -= 0.06;
		else if (curBeat >= 128 && curBeat <= 191) PlayState.health -= 0.16;
		else if (curBeat >= 192 && curBeat <= 255) PlayState.health -= 0.1;
		else if (curBeat >= 256 && curBeat <= 319) PlayState.health -= 0.18;
		else if (curBeat >= 320) PlayState.health -= 0.01;
	}else{
		PlayState.health -= 0.07; //Default drain value
	}
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	//This entire set monitors the brightness of the screen based on the percentage of your health
	
	if(PlayState.health <= 0.1) //if 5% HP
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.95}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.2) //if 10% HP
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.9}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.3) //if 15% HP
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.85}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.4) //if 20% HP (you get the idea)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.8}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.5)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.75}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.6)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.7}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.7)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.65}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.8)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.6}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 0.9)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.55}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.5}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.1)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.45}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.2)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.4}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.3)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.35}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.4)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.3}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.5)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.25}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.6)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.2}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.7)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.15}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.8)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.1}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 1.9)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0.05}, 0.15, {ease: FlxEase.sineInOut});
	}else if (PlayState.health <= 2)
	{
		FlxTween.tween(gettingSleepy, {alpha: 0}, 0.15, {ease: FlxEase.sineInOut});
	}

	/*
	Okay, time to explain how the spacebar works, basically, you can't spam it anymore unlike the Psych counterpart.
	With the conditions given, the spacebar becomes available and accessible when your HP is at exactly 12.5% health or lower.
	Seems simple, right? Well, people can easily exploit this if there is no limit given, so that's there the "limitThing" variable comes in.
	As you see at the to, it's at 0, but in the onCreate function, you can see it adds a certain amount based on the song given (by default, it's 5).
	The moment it reaches 0, you will no longer be able to use the spacebar key, encouraging players to actually use it wisely.
	*/
	if(FlxG.keys.justPressed.SPACE && PlayState.health < 0.25 && limitThing > 0)
	{
		PlayState.health += 1.25;
		limitThing -= 1;
	}
}
