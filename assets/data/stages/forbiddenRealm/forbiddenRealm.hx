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

	var greyParticles = new FlxEmitter(-2080.5, 650.4);
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

					var blackParticles = new FlxEmitter(-2080.5, 1512.4);
                    blackParticles.launchMode = FlxEmitterMode.SQUARE;
                    blackParticles.velocity.set(-70, -220, 70, -620, -110, 20, 110, -620);
                    blackParticles.scale.set(6, 6, 6, 6, 2, 2, 2, 2);
                    blackParticles.drag.set(2, 2, 2, 2, 7, 7, 12, 12);
                    blackParticles.width = 4787.45;
                    blackParticles.alpha.set(1, 1);
                    blackParticles.lifespan.set(1.9, 4.9);
                    blackParticles.loadParticles(Paths.image('particleBlack', 'data/stages/forbiddenRealm/images'), 500, 16, true);
		foreground.add(blackParticles);
}	