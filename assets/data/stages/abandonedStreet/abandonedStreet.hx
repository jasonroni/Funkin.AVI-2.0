// Shaders
var grainFilter:FlxRuntimeShader;
var monitorFilter:FlxRuntimeShader;
var bloomEffect:FlxRuntimeShader;

// Stage Assets
var colorsOrSmthElse:FNFSprite;
var floor:FNFSprite;
var stageCurtains:FNFSprite;
var stageFront:FNFSprite;

// Shader Animations
var shaderTime:Float = 0;

function onCreate()
{

	bloomEffect = new FlxRuntimeShader(File.getContent('./assets/shaders/bloomGame.frag'), null, 120);
	grainFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/filmgrain.frag'), null, 150);
	monitorFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);


	PlayState.camGame.setFilters([
		new ShaderFilter(grainFilter),
		new ShaderFilter(monitorFilter),
		new ShaderFilter(bloomEffect)
	]);

	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.87;
	
	if (PlayState.SONG.song == "Isolated" || PlayState.SONG.song == "Lunacy") {
		PlayState.camHUD.alpha = 0;
		PlayState.camGame.alpha = 0;
	}
	
	PlayState.cameraSpeed = 1;
	PlayState.skipCountdown = true;
	
	colorsOrSmthElse = new FNFSprite(-990, 1600).loadGraphic(Paths.image('randomColors', 'data/stages/abandonedStreet/images'));
	colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 4));
	colorsOrSmthElse.updateHitbox();
	colorsOrSmthElse.antialiasing = true;
	colorsOrSmthElse.screenCenter();
	colorsOrSmthElse.scale.set(3, 3);
	colorsOrSmthElse.scrollFactor.set(0.9, 0.9);
	colorsOrSmthElse.active = false;
	add(colorsOrSmthElse);
	
	floor = new FNFSprite(0, 200).loadGraphic(Paths.image('street', 'data/stages/abandonedStreet/images'));
	floor.antialiasing = true;
	floor.scale.set(2.2, 2);
	floor.scrollFactor.set(1, 1);
	floor.active = false;
	add(floor);
		
	stageCurtains = new FNFSprite(0, 0).loadGraphic(Paths.image('i_forgor', 'data/stages/abandonedStreet/images'));
	stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
	stageCurtains.updateHitbox();
	stageCurtains.screenCenter();
	stageCurtains.scale.set(1.3,1.3);
	stageCurtains.antialiasing = true;
	stageCurtains.cameras = [PlayState.camAlt];
	stageCurtains.scrollFactor.set(1.3, 1.3);
	stageCurtains.active = false;
	add(stageCurtains);
	
	stageFront = new FNFSprite(-1570, 130).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
	stageFront.scale.set(5.1, 1.6);
	stageFront.updateHitbox();
	stageFront.antialiasing = true;
	stageFront.scrollFactor.set(3, 2.5);
	stageFront.active = false;
	add(stageFront);

	// doing some fix with this later
	if(PlayState.SONG.song == "Isolated") {
		FlxTween.tween(PlayState.camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 9});
		FlxTween.tween(PlayState.camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 6});
	}
}
	
function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (PlayState.SONG.song == "Isolated")
	{
		if (curBeat == 32 || curBeat == 96 || curBeat == 128 || curBeat == 192 || curBeat == 224 || curBeat == 256 || curBeat == 288 || curBeat == 320)
			if (!Init.trueSettings.get("Disable Flashing Lights")) PlayState.camGame.flash("white", 1.5);
			
		if (curBeat == 48 || curBeat == 112 || curBeat == 144 || curBeat == 208 || curBeat == 240 || curBeat == 272 || curBeat == 304 || curBeat == 336)
			if (!Init.trueSettings.get("Disable Flashing Lights")) PlayState.camGame.flash("black", 1.5);
			
		if (curBeat == 160 || curBeat == 352)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
		}
		
		if (curBeat == 184)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
		}
		
		if (curBeat == 188)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
		}
			
		if (curBeat == 192)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
		}
			
		if (curBeat == 376)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
			FlxTween.tween(floor, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
			FlxTween.tween(stageCurtains, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
			FlxTween.tween(stageFront, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
		}
	}
	
	if (PlayState.SONG.song == 'Lunacy')
	{
		if (curBeat == 96 || curBeat == 128)
			PlayState.camGame.flash(ForeverTools.returnColor("white"), 1.5);

		

		if (curBeat == 160)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			PlayState.defaultCamZoom = 0.7;
			PlayState.camGame.flash(ForeverTools.returnColor("white"), 1.5);
		}

		if (curBeat == 156)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			PlayState.defaultCamZoom = 1.05;
		}

		if (curBeat == 192)
			PlayState.defaultCamZoom = 0.75;
		if (curBeat == 200)
			PlayState.defaultCamZoom = 0.8;
		if (curBeat == 208)
			PlayState.defaultCamZoom = 0.85;
		if (curBeat == 216)
			PlayState.defaultCamZoom = 0.9;
		if (curBeat == 220)
			PlayState.defaultCamZoom = 0.95;
		if (curBeat == 222)
			PlayState.defaultCamZoom = 1;

		if (curBeat == 224 || curBeat == 288)
		{
			PlayState.defaultCamZoom = 0.75;
			PlayState.camGame.flash(ForeverTools.returnColor("white"), 1.5);
			FlxTween.tween(PlayState.camHUD, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
			for (i in PlayState.strumHUD)
			{
				FlxTween.tween(i, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
			}
		}

		if (curBeat == 228 || curBeat == 260)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			PlayState.defaultCamZoom = 1.1;
		}

		if (curBeat == 230 || curBeat == 262)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			PlayState.defaultCamZoom = 0.65;
		}
		
		if (curBeat == 232 || curBeat == 264)
		{
			PlayState.camGame.flash(ForeverTools.returnColor("white"), 1.5);
			PlayState.defaultCamZoom = 0.9;
		}

		if (curBeat == 233 || curBeat == 266)
			PlayState.defaultCamZoom = 0.7;

		if (curBeat == 235 || curBeat == 267)
			PlayState.defaultCamZoom = 1;

		if (curBeat == 236 || curBeat == 268)
			PlayState.defaultCamZoom = 0.65;

		if (curBeat == 238 || curBeat == 270)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			PlayState.defaultCamZoom = 0.8;
		}
		
		if (curBeat == 239 || curBeat == 271)
			PlayState.defaultCamZoom = 1;

		if (curBeat == 240 || curBeat == 272)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			PlayState.camGame.flash(ForeverTools.returnColor("white"), 1.5);
			PlayState.defaultCamZoom = 0.7;
		}

		if (curBeat == 244 || curBeat == 276)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			PlayState.defaultCamZoom = 1.1;
		}
		
		if (curBeat == 248 || curBeat == 280)
		{
			FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			PlayState.camGame.flash(ForeverTools.returnColor("white"), 1.5);
			PlayState.defaultCamZoom = 0.7;
		}

		if (curBeat == 252 || curBeat == 284)
			PlayState.defaultCamZoom = 0.9;
		
		if (curBeat == 254 || curBeat == 286)
			PlayState.defaultCamZoom = 1.1;

		if (curBeat == 254 || curBeat == 318)
		{
			FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
			for (i in PlayState.strumHUD)
			{
				FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
			}
		}

		if (curBeat == 256 || curBeat == 320)
			PlayState.camGame.flash("white", 1.5);
	}
}


function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	//Shader stuff
	shaderTime += elapsed;
	grainFilter.setFloat('time', shaderTime);
}
	
function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(-861, -259);
	boyfriend.setPosition(260, 0);
}
