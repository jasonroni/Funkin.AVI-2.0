function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.85;
	PlayState.cameraSpeed = 1.35;

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

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(100, 360);
    boyfriend.setPosition(500, -30);
}
	