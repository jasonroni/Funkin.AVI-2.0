function onCreate()
	{
		spawnGirlfriend(false);
		PlayState.defaultCamZoom = 0.87;
		PlayState.cameraSpeed = 1;
		PlayState.camHUD.alpha = 0;
	
		var colorsOrSmthElse:FNFSprite = new FNFSprite(-990, 1600).loadGraphic(Paths.image('randomColors', 'data/stages/abandonedStreet/images'));
		colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 4));
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
		stageCurtains.scale.set(1.3,1.3);
		stageCurtains.antialiasing = true;
		stageCurtains.cameras = [PlayState.camAlt];
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;
		add(stageCurtains);
	
		var blackFade:FNFSprite = new FNFSprite(stageCurtains.x - 200, stageCurtains.y - 300).loadGraphic(Paths.image('black', 'data/stages/abandonedStreet/images'));
		blackFade.setGraphicSize(Std.int(blackFade.width * 7));
		blackFade.updateHitbox();
		blackFade.antialiasing = true;
		blackFade.cameras = [PlayState.camAlt];
		blackFade.scrollFactor.set(1.3, 1.3);
		blackFade.active = false;
		add(blackFade);
	
		var stageFront:FNFSprite = new FNFSprite(-1570, 130).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
		stageFront.scale.set(5.1, 1.6);
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(3, 2.5);
		stageFront.active = false;
		add(stageFront);
	
	
		FlxTween.tween(PlayState.camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 9});
		FlxTween.tween(blackFade, {alpha: 0}, 3, {ease: FlxEase.quadOut, startDelay: 6});
	}
	
	function charStagePos(boyfriend:Character, gf:Character, dad:Character)
	{
		dad.setPosition(-150, 420);
		boyfriend.setPosition(350, 0);
	}