function onCreate()
{
    spawnGirlfriend(false);
    PlayState.defaultCamZoom = 0.87;
    PlayState.cmaeraSpeed = 1;

				var stageFront:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
				stageFront.scale.set(2, 1);
				stageFront.updateHitbox();
				stageFront.cameras = [PlayState.camHUD];
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var colorsOrSmthElse:FNFSprite = new FNFSprite(-990, 1600).loadGraphic(Paths.image('randomColors', 'data/stages/abandonedStreet/images'));
				colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 1.1));
				colorsOrSmthElse.updateHitbox();
				colorsOrSmthElse.antialiasing = true;
				colorsOrSmthElse.screenCenter();
				colorsOrSmthElse.scale.set(3, 3);
				colorsOrSmthElse.scrollFactor.set(0.9, 0.9);
				colorsOrSmthElse.active = false;
				add(colorsOrSmthElse);

				var floor:FNFSprite = new FNFSprite(0, 200).loadGraphic(Paths.image('street', 'data/stages/abandonedStreet/images'));
				floor.antialiasing = true;
				floor.scale.set(2.2, 2);
			    floor.scrollFactor.set(1, 1);
				floor.active = false;
				add(floor);
				
				var stageCurtains:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('i_forgor', 'data/stages/abandonedStreet/images'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.screenCenter();
				stageCurtains.scale.set(2.8, 2.8);
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				add(stageCurtains);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(-100, 420);
    boyfriend.setPosition(350, 0);
}