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
	monitorFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);
	aberrationBoom = new FlxRuntimeShader(Shaders.aberration, null, 150);

	aberrationBoom.setFloat('aberration', 0.001);
	aberrationBoom.setFloat('effectTime', 0.001);

	PlayState.camGame.setFilters([
		new ShaderFilter(aberrationBoom),
		new ShaderFilter(monitorFilter),
		new ShaderFilter(bloomEffect)
	]);
	
	if(PlayState.SONG.song == 'Isolated')
	{
	PlayState.camHUD.alpha = 0;
	
	var fade:FlxSprite = new FlxSprite(0,0).makeGraphic(1280, 720, 0x000000);
	fade.scale.set(5,5);
	fade.screenCenter();
	add(fade);
	
	FlxTween.tween(fade, {alpha: 0}, 3, {ease: FlxEase.sineInOut, startDelay: 6});
	FlxTween.tween(PlayState.camHUD, {alpha: 1}, 3, {ease: FlxEase.sineInOut, startDelay: 9});
	}

	var background:FNFSprite = new FNFSprite(-400, -300).loadGraphic(Paths.image('bg', 'data/stages/clubhouse/images'));
	background.scale.set(1.2, 1.2);
	background.updateHitbox();
	background.antialiasing = true;
	background.scrollFactor.set(0.7, 0.7);
	background.active = false;
	add(background);

	var clubhouse:FNFSprite = new FNFSprite(-400, -300).loadGraphic(Paths.image('street', 'data/stages/clubhouse/images'));
	clubhouse.scale.set(1.2, 1.2);
	clubhouse.updateHitbox();
	clubhouse.antialiasing = true;
	clubhouse.scrollFactor.set(1, 1);
	clubhouse.active = false;
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
	
