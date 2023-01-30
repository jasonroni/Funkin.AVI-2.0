import flixel.text.FlxText;
import openfl.filters.ShaderFilter;

var gettingSleepy:FlxSprite;
var limitThing:Int = 0; //Default Value

var pissOfGlory:FNFSprite;
var greaterPiss:FNFSprite;

var inkFormWarning:FlxText;

var spaceBarCounter:FlxText;

var vhsFilter:FlxRuntimeShader;
var grainFilter:FlxRuntimeShader;
var monitorFilter:FlxRuntimeShader; //I can't get this one to work without covering the entire screen
var shaderTime:Float = 0;

function onCreate()
{
	spawnGirlfriend(false);
	hideBoyfriend(true);
	
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

	gettingSleepy = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
		-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
	gettingSleepy.scrollFactor.set();
	gettingSleepy.cameras = [PlayState.camAlt];
	gettingSleepy.alpha = 0; //Default value
	add(gettingSleepy);

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

	inkFormWarning = new FlxText(0, 0, 0, "PRESS SPACE!", 15);
	inkFormWarning.setFormat(Paths.font("splatter"), 50);
	inkFormWarning.cameras = [PlayState.camAlt];
	inkFormWarning.alpha = 0;
	inkFormWarning.scrollFactor.set();
	inkFormWarning.screenCenter();
	add(inkFormWarning);

	spaceBarCounter = new FlxText(0, 680, 0, 'Health Boosts Left: ' + limitThing, 15);
	spaceBarCounter.setFormat(Paths.font("splatter"), 30);
	spaceBarCounter.cameras = [PlayState.camAlt];
	spaceBarCounter.scrollFactor.set();
	add(spaceBarCounter);

	FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
	FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});

	if (PlayState.SONG.song == 'Mercy Legacy') limitThing += 12; else if (PlayState.SONG.song == 'Mercy') limitThing += 16; else limitThing += 5; //This line sets up the limit based on the song it's set on.

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
	}else if (PlayState.SONG.song == 'Mercy'){

		// Walt's Health Mechanic
		if (curBeat >= 0 && curBeat <= 63) PlayState.health -= 0.005;
		else if (curBeat >= 64 && curBeat <= 79) PlayState.health -= 0.01;
		else if (curBeat >= 80 && curBeat <= 87) PlayState.health -= 0.07;
		else if (curBeat >= 88 && curBeat <= 95) PlayState.health -= 0.01;
		else if (curBeat >= 96 && curBeat <= 127) PlayState.health -= 0.03;
		else if (curBeat >= 128 && curBeat <= 159) PlayState.health -= 0.1;
		else if (curBeat >= 160 && curBeat <= 191) PlayState.health -= 0.06;
		else if (curBeat >= 192 && curBeat <= 207) PlayState.health -= 0.01;
		else if (curBeat >= 208 && curBeat <= 239) PlayState.health -= 0.04;
		else if (curBeat >= 240 && curBeat <= 255) PlayState.health -= 0.005;
		else if (curBeat >= 256 && curBeat <= 291) PlayState.health -= 0.03;
		else if (curBeat >= 292 && curBeat <= 307) PlayState.health -= 0.05;
		else if (curBeat >= 308 && curBeat <= 339) PlayState.health -= 0.085;
		else if (curBeat >= 340 && curBeat <= 371) PlayState.health -= 0.1;
		else if (curBeat >= 372 && curBeat <= 387) PlayState.health -= 0.12;
		else if (curBeat >= 388 && curBeat <= 403) PlayState.health -= 0.135;
		else if (curBeat >= 404 && curBeat <= 451) PlayState.health -= 0.15;
		else if (curBeat >= 452 && curBeat <= 467) PlayState.health -= 0.2;
		else if (curBeat >= 468 && curBeat <= 475) PlayState.health -= 0.25;
		else if (curBeat >= 476 && curBeat <= 489) PlayState.health -= 0.3;
		else if (curBeat >= 490) PlayState.health -= 0.02;

		// Mid-Song Stuff
		if (curBeat == 16)
		{
			FlxTween.tween(PlayState.camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
			FlxTween.tween(PlayState.camHUD, {alpha: 1}, 5, {ease: FlxEase.sineInOut, startDelay: 1.5});
			PlayState.defaultCamZoom = 1.3;
		}
		if (curBeat == 32) PlayState.defaultCamZoom = 1.2;
		if (curBeat == 40) PlayState.defaultCamZoom = 1.1;
		if (curBeat == 48) PlayState.defaultCamZoom = 1;
		if (curBeat == 56) PlayState.defaultCamZoom = 0.9;
		if (curBeat == 64) PlayState.defaultCamZoom = 0.75;
		if (curBeat == 256)
		{
			FlxTween.tween(PlayState.camGame, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
		}
		if (curBeat == 264)
		{
			FlxTween.tween(PlayState.camGame, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
			PlayState.defaultCamZoom = 1.3;
		}
		if (curBeat == 275)
		{
			PlayState.defaultCamZoom = 0.8;
			inkFormWarning.alpha = 1;
			FlxTween.tween(pissOfGlory, {alpha: 0}, 0.5, {ease: FlxEase.quartInOut});
			FlxTween.tween(greaterPiss, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});
		}
		if (curBeat == 276) FlxTween.tween(inkFormWarning, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
		if (curBeat == 494)
		{
			PlayState.camHUD.flash(ForeverTools.returnColor("white"), 3);
			PlayState.camGame.visible = 0;
			FlxTween.tween(PlayState.bfStrums, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
			FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: 3});
			FlxTween.tween(spaceBarCounter, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
		}
		if (curBeat == 501) PlayState.bfStrums.visible = false;

	}else{
		PlayState.health -= 0.07; //Default drain value
	}
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	//Shader stuff
	shaderTime += elapsed;
	vhsFilter.setFloat('time', shaderTime);
	grainFilter.setFloat('time', shaderTime);

	spaceBarCounter.text = 'Health Boosts Left: ' + limitThing;

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
	Seems simple, right? Well, people can easily exploit this if there is no limit given, so that's where the "limitThing" variable comes in.
	As you see at the top, it's at 0, but in the onCreate function, you can see it adds a certain amount based on the song given (by default, it's 5).
	The moment it reaches 0, you will no longer be able to use the spacebar key, encouraging players to actually use it wisely.
	*/
	if(FlxG.keys.justPressed.SPACE && PlayState.health < 0.3 && limitThing > 0)
	{
		PlayState.health += 1.25;
		limitThing -= 1;
	}
}
