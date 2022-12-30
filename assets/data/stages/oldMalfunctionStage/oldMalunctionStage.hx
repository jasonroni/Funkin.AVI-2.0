function onCreate()
{
	PlayState.defaultCamZoom = 0.8;
	spawnGirlfriend(false);

	var fuckingsquares:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('PixelMouse', 'data/stages/oldMalfunctionStage/images'));
	fuckingsquares.scale.set(1, 1);
	fuckingsquares.updateHitbox();
	fuckingsquares.antialiasing = false;
	fuckingsquares.scrollFactor(1, 1);
	fuckingsquares.active = false;
	add(fuckingsquares);
}

//I'll add the offsets later
