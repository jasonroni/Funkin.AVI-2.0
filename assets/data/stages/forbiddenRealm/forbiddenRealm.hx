import flixel.effects.particles.FlxEmitter;

function onCreate()
{
	PlayState.defaultCamZoom = 0.8;
	spawnGirlfriend(false);

	var fuckingsquares:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('PixelMouse', 'data/stages/forbiddenRealm/images'));
	fuckingsquares.scale.set(1, 1);
	fuckingsquares.updateHitbox();
	fuckingsquares.antialiasing = false;
	fuckingsquares.scrollFactor(1, 1);
	fuckingsquares.active = false;
	add(fuckingsquares);

	var greyParticles:FlxEmitter = new FlxEmitter(-2080.5, 650.4);
    greyParticles.launchMode = FlxEmitterMode.SQUARE;
    greyParticles.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
    greyParticles.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
    greyParticles.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
    greyParticles.width = 4787.45;
    greyParticles.alpha.set(1, 1);
    greyParticles.lifespan.set(1.9, 4.9);
    greyParticles.loadParticles(Paths.image('greyParticle', 'data/stages/forbiddenRealm/images'), 500, 16, true);
    greyParticles.start(false, FlxG.random.float(.0521, .1060), 1000000);
    add(greyParticles);

    var blackParticles:FlxEmitter = new FlxEmitter(-2080.5, 1512.4);
    blackParticles.launchMode = FlxEmitterMode.SQUARE;
    blackParticles.velocity.set(-70, -220, 70, -620, -110, 20, 110, -620);
    blackParticles.scale.set(6, 6, 6, 6, 2, 2, 2, 2);
    blackParticles.drag.set(2, 2, 2, 2, 7, 7, 12, 12);
    blackParticles.width = 4787.45;
    blackParticles.alpha.set(1, 1);
    blackParticles.lifespan.set(1.9, 4.9);
    blackParticles.loadParticles(Paths.image('particleBlack', 'data/stages/forbiddenRealm/images'), 500, 16, true);
    add(blackParticles);
	
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
