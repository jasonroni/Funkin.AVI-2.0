using StringTools;

var grainFilter:FlxRuntimeShader;

function onCreate()
	{
		spawnGirlfriend(false);
		PlayState.defaultCamZoom = 0.87;
	if (PlayState.SONG.song == "Isolated") {
		PlayState.camHUD.alpha = 0;
		PlayState.camGame.alpha = 0;
	}
		PlayState.cameraSpeed = 1;
		PlayState.skipCountdown = true;
	
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
	
		var stageFront:FNFSprite = new FNFSprite(-1570, 130).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
		stageFront.scale.set(5.1, 1.6);
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(3, 2.5);
		stageFront.active = false;
		add(stageFront);
		
	
		if(PlayState.SONG.song == "Isolated") {
			FlxTween.tween(PlayState.camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 9});
			FlxTween.tween(PlayState.camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut, startDelay: 6});
		}
	}
	
	function charStagePos(boyfriend:Character, gf:Character, dad:Character)
	{
		//lazy to mess with the JSON
		if(PlayState.SONG.song == "Lunacy")
		{
				dad.setPosition(-861, -259);
		} else {
				dad.setPosition(-230, 420);
		}
		boyfriend.setPosition(260, 0);
	}