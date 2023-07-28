function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.75;
	PlayState.cameraSpeed = 2.5;

	var office:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('office', 'data/stages/trueGrinsOfSins/images'));
	office.antialiasing = true;
	office.scrollFactor.set(1, 1);
	office.active = false;
	add(office);

    var chair:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('chair', 'data/stages/trueGrinsOfSins/images'));
    chair.antialiasing = true;
    chair.scrollFactor.set(1, 1);
    chair.active = false;
    add(chair);

	var funiLight:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('light', 'data/stages/trueGrinsOfSins/images'));
	funiLight.antialiasing = true;
	funiLight.scrollFactor.set(1, 1);
	funiLight.alpha = 0.6;
	funiLight.blend = ForeverTools.returnBlendMode("add");
	funiLight.active = false;
	foreground.add(funiLight);

    office.scale.set(0.85, 0.8);
    chair.scale.set(0.9, 0.85);
    funiLight.scale.set(0.85, 0.8);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	boyfriend.setPosition(1300, 400);
	dad.setPosition(130, 480);
}


	
