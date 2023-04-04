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

// For events
var objects:Array<FlxSprite>;

function onCreate()
{
	bloomEffect = new FlxRuntimeShader(File.getContent('./assets/shaders/bloomGame.frag'), null, 120);
	grainFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/filmgrain.frag'), null, 150);
	monitorFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);
	
	if(!lowQuality)
		{
			PlayState.camGame.setFilters([
				new ShaderFilter(grainFilter),
				new ShaderFilter(monitorFilter),
				new ShaderFilter(bloomEffect)
			]);
		} else {
			PlayState.camGame.setFilters([
				new ShaderFilter(monitorFilter),
			]);
		}
	
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
	
	if(!lowQuality)
		{
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
		}
	
	if(!lowQuality)
		{
			stageFront = new FNFSprite(-3000, 130).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
			stageFront.scale.set(9, 2.1);
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(5, 2.6);
			stageFront.active = false;
			foreground.add(stageFront);
		}

	if(!lowQuality)
		{
			objects = [
				colorsOrSmthElse,
				stageFront,
				stageCurtains,
				floor
			];
		} else {
			objects = [
				colorsOrSmthElse,
				floor
			];
		}
	
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
		case 'Lunacy':
			// Brightens BG
			if (curBeat == 160 || curBeat == 230 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 262 || curBeat == 272
				|| curBeat == 280 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320
				|| curBeat == 328 || curBeat == 336 || curBeat == 344 || curBeat == 352)
			{
				for(_stuff in objects)
					FlxTween.tween(_stuff, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
			}

			// Darkens BG
			if (curBeat == 156 || curBeat == 228 || curBeat == 238 || curBeat == 244 || curBeat == 252 || curBeat == 260 || curBeat == 270
				|| curBeat == 276 || curBeat == 284 || curBeat == 292 || curBeat == 300 || curBeat == 308 || curBeat == 316 || curBeat == 324
				|| curBeat == 332 || curBeat == 340 || curBeat == 348)
			{
				for(_stuff in objects)
					FlxTween.tween(_stuff, {alpha: 0.23}, 0.5, {ease: FlxEase.quartOut});
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
