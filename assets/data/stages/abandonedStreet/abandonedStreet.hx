// Shaders
var grainFilter:FlxRuntimeShader;
var monitorFilter:FlxRuntimeShader;
var bloomEffect:FlxRuntimeShader;

// Stage Assets
var colorsOrSmthElse:FNFSprite;
var floor:FNFSprite;
var stageCurtains:FNFSprite;
var stageFront:FNFSprite;

// The Background Flash Thing
var whiteBG:FlxSprite;

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
	
	floor = new FNFSprite(-20, 200).loadGraphic(Paths.image('street', 'data/stages/abandonedStreet/images'));
	floor.antialiasing = true;
	floor.scale.set(2.2, 2.1);
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
	
	// dw, I'll make it less flashy
	whiteBG = new FlxSprite(-800, -200).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
	whiteBG.alpha = 0;
	whiteBG.active = false;
	add(whiteBG);
	
	stageFront = new FNFSprite(-1270, 130).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
	stageFront.scale.set(5.1, 2.1);
	stageFront.updateHitbox();
	stageFront.antialiasing = true;
	stageFront.scrollFactor.set(3, 2.5);
	stageFront.active = false;
	foreground.add(stageFront);

	// doing some fix with this later
	if(PlayState.SONG.song == "Isolated") {
		FlxTween.tween(PlayState.camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 9});
		FlxTween.tween(PlayState.camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 6});
	}
}
	
function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	// Stage asset modcharts cause I can't do this in PlayState.hx nor Stage.hx unless I shove FE-Legacy stuff into the code :(
	switch (PlayState.SONG.song)
	{
		case 'Isolated':
			if (curBeat == 36 || curBeat == 40 || curBeat == 44 || curBeat == 48 || curBeat == 52 || curBeat == 56 || curBeat == 60 || curBeat == 64 ||
				curBeat == 68 || curBeat == 72 || curBeat == 76 || curBeat == 80 || curBeat == 84 || curBeat == 88 || curBeat == 92)
			{
				whiteBG.alpha = 0.32;
				FlxTween.tween(whiteBG, {alpha: 0}, 1.2);
			}

			if (curBeat == 96 || curBeat == 100 || curBeat == 104 || curBeat == 108 || curBeat == 112 || curBeat == 116 || curBeat == 120 || curBeat == 124 ||
				curBeat == 128 || curBeat == 132 || curBeat == 136 || curBeat == 140 || curBeat == 144 || curBeat == 148 || curBeat == 152 || curBeat == 156)
			{
				whiteBG.alpha = 0.4;
				FlxTween.tween(whiteBG, {alpha: 0}, 0.35);
			}

			if (curBeat == 98 || curBeat == 102 || curBeat == 106 || curBeat == 110 || curBeat == 114 || curBeat == 118 || curBeat == 122 || curBeat == 126 ||
				curBeat == 130 || curBeat == 134 || curBeat == 138 || curBeat == 142 || curBeat == 146 || curBeat == 150 || curBeat == 154 || curBeat == 158)
			{
				whiteBG.alpha = 0.67;
				FlxTween.tween(whiteBG, {alpha: 0}, 0.35);
			}
			
			if (curBeat == 160 || curBeat == 352)
			{
				FlxTween.tween(colorsOrSmthElse, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(floor, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(stageCurtains, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(stageFront, {alpha: 0.15}, 0.5, {ease: FlxEase.quartOut});
			}
			switch (curBeat)
			{
				case 184:
					FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
				case 188:
					FlxTween.tween(colorsOrSmthElse, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(floor, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(stageCurtains, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(stageFront, {alpha: 0.4}, 0.5, {ease: FlxEase.quartOut});
				case 192:
					FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
					FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				case 376:
					FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
					FlxTween.tween(floor, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
					FlxTween.tween(stageCurtains, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
					FlxTween.tween(stageFront, {alpha: 1}, 4, {ease: FlxEase.quartInOut});
			}
	
		case 'Lunacy':
			// Brightens BG
			if (curBeat == 160 || curBeat == 230 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 262 || curBeat == 272 || curBeat == 280 || 
				curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320 || curBeat == 328 || curBeat == 336 ||
				curBeat == 344 || curBeat == 352)
			{
				FlxTween.tween(colorsOrSmthElse, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(stageCurtains, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(stageFront, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			}
  
			// Darkens BG
			if (curBeat == 156 || curBeat == 228 || curBeat == 238 || curBeat == 244 || curBeat == 252 || curBeat == 260 || curBeat == 270 || curBeat == 276 ||
				curBeat == 284 || curBeat == 292 || curBeat == 300 || curBeat == 308 || curBeat == 316 || curBeat == 324 || curBeat == 332 || curBeat == 340 ||
				curBeat == 348)
			{
				FlxTween.tween(colorsOrSmthElse, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(floor, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(stageCurtains, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(stageFront, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
			}
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
