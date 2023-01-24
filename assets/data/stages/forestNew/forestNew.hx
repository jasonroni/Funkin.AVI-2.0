var grainFilter:FlxRuntimeShader;
var monitorFilter:FlxRuntimeShader;
var bloomEffect:FlxRuntimeShader;
var vignette:FlxRuntimeShader;
var shaderTime:Float = 0;

function onCreate()
{
	bloomEffect = new FlxRuntimeShader(File.getContent('./assets/shaders/bloomGame.frag'), null, 120);
	grainFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/filmgrain.frag'), null, 150);
	monitorFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);
	vignette = new FlxRuntimeShader(File.getContent('./assets/shaders/vignetteApparition.frag'), null, 120);

	PlayState.camGame.setFilters([
		new ShaderFilter(grainFilter),
		new ShaderFilter(monitorFilter),
		new ShaderFilter(bloomEffect)
	]);

	spawnGirlfriend(false);
	PlayState.cameraSpeed = 0.9;
	PlayState.defaultCamZoom = 0.65;
	PlayState.skipCountdown = true;

	var goofyBG:FNFSprite = new FNFSprite(-600, -650).loadGraphic(Paths.image('bg', 'data/stages/forestNew/images'));
	goofyBG.scrollFactor.set(0.7, 0.7);
	goofyBG.scale.set(1.2, 1.2);
	goofyBG.screenCenter();
	add(goofyBG);

	var treesBack:FNFSprite = new FNFSprite(-550, -650).loadGraphic(Paths.image('treesBack', 'data/stages/forestNew/images'));
	treesBack.scale.set(1.3, 1.2);
	treesBack.scrollFactor.set(1, 0.8);
	add(treesBack);

	var goofyStreet:FNFSprite = new FNFSprite(-700, -950).loadGraphic(Paths.image('ground', 'data/stages/forestNew/images'));
	goofyStreet.scale.set(2, 1.9);
	goofyStreet.scrollFactor.set(1, 1);
	add(goofyStreet);

	var treesFront:FNFSprite = new FNFSprite(-550, -650).loadGraphic(Paths.image('treesFront', 'data/stages/forestNew/images'));
	treesFront.scale.set(1.5, 1.5);
	treesFront.scrollFactor.set(1.2, 1.2);
	foreground.add(treesFront);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (curBeat == 184) PlayState.defaultCamZoom = 1.4;
	if (curBeat == 190) PlayState.defaultCamZoom = 0.65;
	if (curBeat == 192)
	{
		PlayState.camGame.flash("white", 1);
		PlayState.camGame.setFilters(
			[	
				new ShaderFilter(vignette),
				new ShaderFilter(grainFilter),
				new ShaderFilter(monitorFilter),
				new ShaderFilter(bloomEffect)
			]);
	}
	if (curBeat == 256)
	{
		PlayState.camGame.flash("white", 1);
		PlayState.camGame.setFilters(
			[	
				new ShaderFilter(grainFilter),
				new ShaderFilter(monitorFilter),
				new ShaderFilter(bloomEffect)
			]);
	}
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	// Shader stuff
	shaderTime += elapsed;
	grainFilter.setFloat('time', shaderTime);
	vignette.setFloat('time', shaderTime);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(-440, 0);
	boyfriend.setPosition(850, 0);
}