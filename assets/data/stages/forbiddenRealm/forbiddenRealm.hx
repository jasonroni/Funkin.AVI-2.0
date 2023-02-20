public var mickeyEmitter:FlxEmitter;
var fuckingsquares:FlxSprite;

var glitchBG:FlxRuntimeShader;
var staticBG:FlxRuntimeShader;

var shaderTime:Float = 0;

function onCreate()
{
	PlayState.defaultCamZoom = 0.8;
	spawnGirlfriend(false);

	
    	staticBG = new FlxRuntimeShader(File.getContent('./assets/shaders/tvStatic.frag'), null, 120);
    	glitchBG = new FlxRuntimeShader(File.getContent('./assets/shaders/vignetteGlitch.frag'), null, 130);

	fuckingsquares = new FlxSprite(-750, -850);
	if (PlayState.SONG.song == 'Malfunction Legacy')
		fuckingsquares.loadGraphic(Paths.image('PixelMouse', 'data/stages/forbiddenRealm/images'));
	else
		fuckingsquares.loadGraphic(Paths.image('PixelMouse', 'data/stages/forbiddenRealm/images')); //i'm gonna get the new stage background later
	fuckingsquares.scale.set(1.2, 1);
	fuckingsquares.updateHitbox();
	fuckingsquares.antialiasing = false;
	fuckingsquares.scrollFactor(1, 1);
	fuckingsquares.active = false;
	add(fuckingsquares);

	var greyParticles:FlxEmitter = new FlxEmitter(-2080.5, 650.4);
    	greyParticles.launchMode = 'square';
    	greyParticles.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
    	greyParticles.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
    	greyParticles.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
    	greyParticles.width = 4787.45;
    	greyParticles.alpha.set(1, 1);
    	greyParticles.lifespan.set(1.9, 4.9);
    	greyParticles.loadParticles(Paths.image('greyParticle', 'data/stages/forbiddenRealm/images'), 500, 16, true);
    	greyParticles.start(false, FlxG.random.float(.0521, .1060), 1000000);

    	var blackParticles:FlxEmitter = new FlxEmitter(-2080.5, 912.4);
    	blackParticles.launchMode = 'square';
    	blackParticles.velocity.set(-70, -220, 70, -620, -110, 20, 110, -620);
    	blackParticles.scale.set(6, 6, 6, 6, 2, 2, 2, 2);
    	blackParticles.drag.set(2, 2, 2, 2, 7, 7, 12, 12);
    	blackParticles.width = 4787.45;
    	blackParticles.alpha.set(1, 1);
    	blackParticles.lifespan.set(1.9, 4.9);
    	blackParticles.loadParticles(Paths.image('particleBlack', 'data/stages/forbiddenRealm/images'), 500, 16, true);
		blackParticles.start(false, FlxG.random.float(.0821, .1460), 1000000);
	
	mickeyEmitter = new FlxEmitter(-2099.8, 1620.4);
	for (i in 0 ... 100)
	{
		var mickeyParticle = new FlxParticle();
		mickeyParticle.frames = Paths.getSparrowAtlas('mickParticle', 'data/stages/forbiddenRealm/images');
		mickeyParticle.animation.addByPrefix('mickParticle idle', 'mickParticle idle', 12, true);
		mickeyParticle.animation.play('mickParticle idle');
		mickeyParticle.exists = false;
		mickeyParticle.animation.curAnim.curFrame = FlxG.random.int(0, 3);
		mickeyEmitter.add(mickeyParticle);
	}
	mickeyEmitter.launchMode = 'square';
	mickeyEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
	mickeyEmitter.scale.set(3.4, 3.4, 3.4, 3.4, 0, 0, 0, 0);
	mickeyEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	mickeyEmitter.width = 4200.45;
	mickeyEmitter.alpha.set(1, 1);
	mickeyEmitter.lifespan.set(4, 4.5);
	mickeyEmitter.start(false, FlxG.random.float(.125, .287), 100000);
	mickeyEmitter.emitting = false;
	
	if (PlayState.SONG.song != 'Malfunction Legacy')
	{
		add(greyParticles);
		foreground.add(blackParticles);
		foreground.add(mickeyEmitter);
	}
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (PlayState.SONG.song == 'Malfunction')
	{
		if (curBeat == 72) PlayState.defaultCamZoom = 0.65;
		if (curBeat >= 72 && curBeat <= 135) mickeyEmitter.emitting = true;
		if (curBeat == 136)
		{
			PlayState.camGame.alpha = 0;
			
		}
		if (curBeat >= 136 && curBeat <= 139)
		{
			mickeyEmitter.emitting = false;
			PlayState.defaultCamZoom = 0.9;
		}
		if (curBeat == 140)
		{ 
			PlayState.defaultCamZoom = 0.6;
			PlayState.camGame.alpha = 1;
			if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(ForeverTools.returnColor("white"), 2);
			if (!Init.trueSettings.get('Disable Screen Shaders')) fuckingsquares.shader = staticBG;
		}
		if (curBeat == 204)
		{ 
			PlayState.defaultCamZoom = 1.1;
			FlxTween.tween(fuckingsquares, {alpha: 0.2}, 0.3, {ease: FlxEase.quartInOut});
		}
		if (curBeat == 206)
		{
			PlayState.defaultCamZoom = 0.65;
			if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(ForeverTools.returnColor("white"), 2.5);
			fuckingsquares.alpha = 1;
			if (!Init.trueSettings.get('Disable Screen Shaders'))
			{
				fuckingsquares.shader = glitchBG;
				glitchBG.setFloat('vignetteIntensity', 0.8);
			}
		}
	}
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
    	shaderTime += elapsed;

    	glitchBG.setFloat('time', shaderTime);
    	glitchBG.setFloat('prob', shaderTime);

    	staticBG.setFloat('uTime', shaderTime);
    	staticBG.setFloat('iTime', shaderTime);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(-100, 160);
	boyfriend.setPosition(1300, 600);
}
