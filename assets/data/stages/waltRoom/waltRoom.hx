function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.75;

	var pissOfGlory:FNFSprite = new FNFSprite(-450, -300).loadGraphic(Paths.image('walt-bg', 'data/stages/waltRoom/images'));
	pissOfGlory.scale.set(1, 1);
	pissOfGlory.updateHitbox();
	pissOfGlory.antialiasing = true;
	pissOfGlory.scrollFactor(1, 1);
	pissOfGlory.active = false;
	add(pissOfGlory);

	var vignette:FNFSprite = new FNFSprite(-250, -140).loadGraphic(Paths.image('vignetteOverlay', 'data/stages/waltRoom/images'));
	vignette.cameras = [PlayState.camAlt];
	vignette.scale.set(0.75, 0.75);
	vignette.antialiasing = true;
	vignette.scrollFactor();
	vignette.active = false;
	add(vignette);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(0, 0);
    	boyfriend.setPosition(330, 300); //make sure to replace bf with a first-person pov variant
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	PlayState.health -= 0.07;
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
	if(FlxG.keys.justPressed.SPACE)
	{
		PlayState.health += 0.05;
	}
}