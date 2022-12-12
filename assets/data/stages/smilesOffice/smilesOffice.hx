function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.9;
	PlayState.cameraSpeed = 2;

	var office:FNFSprite = new FNFSprite(-100, -100).loadGraphic(Paths.image('office', 'data/stages/smilesOffice/images'));
	office.scale.set(1, 1);
	office.updateHitbox();
	office.antialiasing = true;
	office.scrollFactor.set(1, 1);
	office.active = false;
	add(office);

	var funiLight:FNFSprite = new FNFSprite(-100, -100).loadGraphic(Paths.image('officeLight', 'data/stages/smilesOffice/images'));
	funiLight.scale.set(1, 1);
	funiLight.updateHitbox();
	funiLight.antialiasing = true;
	funiLight.scrollFactor.set(1, 1);
	funiLight.alpha = 0.6;
	funiLight.active = false;
	foreground.add(funiLight);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	boyfriend.setPosition(1000, 300);
	dad.setPosition(200, 400);
}


	