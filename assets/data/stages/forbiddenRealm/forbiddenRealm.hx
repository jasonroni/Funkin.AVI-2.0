public var mickeyEmitter:FlxEmitter;

function onCreate()
{
	PlayState.defaultCamZoom = 0.8;
	spawnGirlfriend(false);

	var fuckingsquares:FNFSprite = new FNFSprite(-750, -850).loadGraphic(Paths.image('PixelMouse', 'data/stages/forbiddenRealm/images'));
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
    	add(greyParticles);

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
    	foreground.add(blackParticles);
	
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
	foreground.add(mickeyEmitter);
	
	//Imposter V4 code for later
	/*heartEmitter = new FlxEmitter(-1200, 1000);

				for (i in 0 ... 100)
       		 	{
					var p = new FlxParticle();
					p.frames = Paths.getSparrowAtlas('mira/littleheart', 'impostor');
					p.animation.addByPrefix('littleheart', 'littleheart', 24, true);
					p.animation.play('littleheart');
        			p.exists = false;
					p.animation.curAnim.curFrame = FlxG.random.int(0, 2);
					p.shader = heartColorShader.shader;
        			heartEmitter.add(p);
        		}
				heartEmitter.launchMode = FlxEmitterMode.SQUARE;
				heartEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
				heartEmitter.scale.set(3.4, 3.4, 3.4, 3.4, 0, 0, 0, 0);
				heartEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
				heartEmitter.width = 4200.45;
				heartEmitter.alpha.set(1, 1);
				heartEmitter.lifespan.set(4, 4.5);
				//heartEmitter.loadParticles(Paths.image('mira/littleheart', 'impostor'), 500, 16, true);
						
				heartEmitter.start(false, FlxG.random.float(0.3, 0.4), 100000);

				heartEmitter.emitting = false;*/
	//Ignore this, just leaving this here for reference when I finally add the mickey face particles for a trigger mid-song, for I'mm making a different version for the phase 2 section later
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (PlayState.SONG.song == 'Malfunction')
	{
		if (curBeat == 72) PlayState.defaultCamZoom = 0.65;
		if (curBeat >= 72 && curBeat <= 135) mickeyEmitter.emitting = true;
		if (curBeat >= 136 && curBeat <= 139)
			{
				mickeyEmitter.emitting = false;
				PlayState.defaultCamZoom = 0.9;
			}
		if (curBeat == 140) PlayState.defaultCamZoom = 0.6;
	}
}
