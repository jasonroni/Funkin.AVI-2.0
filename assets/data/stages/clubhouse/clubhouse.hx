var aberrationBoom:FlxRuntimeShader;
var monitorFilter:FlxRuntimeShader;
var bloomEffect:FlxRuntimeShader;

var aberrationTimer:Float = 0;

function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.85;
	PlayState.cameraSpeed = 1.35;

	bloomEffect = new FlxRuntimeShader(Shaders.bloom_alt, null, 120);
	monitorFilter = new FlxRuntimeShader(Shaders.monitorFilter, null, 140);
	aberrationBoom = new FlxRuntimeShader(Shaders.aberration, null, 150);

	aberrationBoom.setFloat('aberration', 0.001);
	aberrationBoom.setFloat('effectTime', 0.001);

	PlayState.camGame.setFilters([
		new ShaderFilter(aberrationBoom),
		new ShaderFilter(monitorFilter),
		new ShaderFilter(bloomEffect)
	]);

	var muckneysHouse:FNFSprite = new FNFSprite(-410, -100).loadGraphic(Paths.image('muckneybg', 'data/stages/clubhouse/images'));
	muckneysHouse.scale.set(1.9, 1.8);
	muckneysHouse.updateHitbox();
	muckneysHouse.antialiasing = true;
	muckneysHouse.scrollFactor.set(1, 1);
	muckneysHouse.active = false;
	add(muckneysHouse);

	var clubhouse:FlxSprite = new FlxSprite(-410, -100);
	clubhouse.frames = Paths.getSparrowAtlas('balloons', 'data/stages/clubhouse/images');
	clubhouse.animation.addByPrefix('balloons bounce', 'balloons bounce', 10, true);
	clubhouse.animation.play('balloons bounce');
	clubhouse.scale.set(1.85, 1.75);
	clubhouse.updateHitbox();
	clubhouse.antialiasing = true;
	clubhouse.scrollFactor.set(1.1, 1.1);
	add(clubhouse);

	var vignette:FNFSprite = new FNFSprite(-250, -140).loadGraphic(Paths.image('vignetteOverlay', 'data/stages/clubhouse/images'));
	vignette.cameras = [PlayState.camAlt];
	vignette.scale.set(0.75, 0.75);
	vignette.antialiasing = true;
	vignette.scrollFactor();
	vignette.active = false;
	add(vignette);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	// they start going on an acid trip lmao
	if (curBeat == 256)
	{
		PlayState.camGame.shake(0.015, 1.3);
		PlayState.defaultCamZoom = 1.1;
		aberrationBoom.setFloat('aberration', 0.03);
		aberrationBoom.setFloat('effectTime', 0.06);
	}
	if (curBeat == 258)
	{
		aberrationBoom.setFloat('aberration', 0.06);
		aberrationBoom.setFloat('effectTime', 0.12);
	}
	if (curBeat == 260)
	{
		PlayState.defaultCamZoom = 0.76;
		aberrationBoom.setFloat('aberration', 0.12);
		aberrationBoom.setFloat('effectTime', 0.24);
	}
	if (curBeat == 320)
	{
		PlayState.camGame.shake(0.025, 1.3);
		PlayState.defaultCamZoom = 1;
		aberrationBoom.setFloat('aberration', 0.15);
		aberrationBoom.setFloat('effectTime', 0.30);
	}
	if (curBeat == 322)
	{
			aberrationBoom.setFloat('aberration', 0.18);
			aberrationBoom.setFloat('effectTime', 0.36);
	}
	if (curBeat == 324)
	{
		PlayState.camGame.flash('white', 0.5);
		PlayState.defaultCamZoom = 2.8;
	}

	if (curBeat >= 324 && curBeat <= 387)
	{
		aberrationBoom.setFloat('aberration', aberrationTimer);
		aberrationBoom.setFloat('effectTime', aberrationTimer);
	}

	if (curBeat == 388)
	{
		PlayState.defaultCamZoom = 0.85;
		PlayState.camGame.flash('white', 0.5);
		aberrationBoom.setFloat('aberration', 0.001);
		aberrationBoom.setFloat('effectTime', 0.001);
	}
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	aberrationTimer -= 0.01;
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(100, 360);
    boyfriend.setPosition(500, -30);
}
	
