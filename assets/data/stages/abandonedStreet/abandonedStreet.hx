// Base Assets
var colorsOrSmthElse:FNFSprite;
var floor:FNFSprite;
var stageCurtains:FNFSprite;
var stageFront:FNFSprite;
var rain:FlxSprite;

//Delusional
var streetDaytime:FlxSprite;
var clouds:FlxSprite;
var brightSky:FlxSprite;
var cablesDayTime:FlxSprite;

var streetRuins:FlxSprite;
var fakeLightOfHope:FlxSprite;

// For events
var objects:Array<FlxSprite>;

var pathWay:String = 'data/stages/abandonedStreet/images';

function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.87;
	PlayState.cameraSpeed = 1;
	PlayState.skipCountdown = true;	
	
	colorsOrSmthElse = new FNFSprite(-990, 1600).loadGraphic(Paths.image('randomColors', pathWay));
	colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 4));
	colorsOrSmthElse.updateHitbox();
	colorsOrSmthElse.antialiasing = true;
	colorsOrSmthElse.screenCenter();
	colorsOrSmthElse.scale.set(3, 3);
	colorsOrSmthElse.scrollFactor.set(0.9, 0.9);
	colorsOrSmthElse.active = false;
	add(colorsOrSmthElse);	
	
	floor = new FNFSprite(-20, 200).loadGraphic(Paths.image('street', pathWay));
	floor.antialiasing = true;
	floor.scale.set(2.2, 2.1);
	floor.scrollFactor.set(1, 1);
	floor.active = false;
	add(floor);	

	if (PlayState.SONG.song == 'Delusional')
	{
		brightSky = new FlxSprite(-990, 1600).loadGraphic(Paths.image('brightSky', pathWay));
		brightSky.setGraphicSize(Std.int(brightSky.width * 4));
		brightSky.updateHitbox();
		brightSky.antialiasing = true;
		brightSky.screenCenter();
		brightSky.scale.set(3, 3);
		brightSky.scrollFactor.set(0.9, 0.9);
		add(brightSky);

		if (!lowQuality)
		{
			clouds = new FlxSprite(-990, 1600).loadGraphic(Paths.image('clouds', pathWay));
			clouds.setGraphicSize(Std.int(clouds.width * 4));
			clouds.updateHitbox();
			clouds.antialiasing = true;
			clouds.screenCenter();
			clouds.scale.set(3, 3);
			clouds.scrollFactor.set(1.1, 1.1);
			add(clouds);

			clouds.visible = false;
		}

		streetDaytime = new FlxSprite(-20, 200).loadGraphic(Paths.image('streetDay', pathWay));
		streetDaytime.antialiasing = true;
		streetDaytime.scale.set(2.2, 2.1);
		streetDaytime.scrollFactor.set(1, 1);
		add(streetDaytime);

		fakeLightOfHope = new FlxSprite(-990, 1600).loadGraphic(Paths.image('falseHope', pathWay));
		fakeLightOfHope.setGraphicSize(Std.int(fakeLightOfHope.width * 4));
		fakeLightOfHope.updateHitbox();
		fakeLightOfHope.antialiasing = true;
		fakeLightOfHope.screenCenter();
		fakeLightOfHope.scale.set(3, 3);
		fakeLightOfHope.scrollFactor.set(0.9, 0.9);
		add(fakeLightOfHope);

		streetRuins = new FlxSprite(-20, 200).loadGraphic(Paths.image('streetDestroyed', pathWay));
		streetRuins.antialiasing = true;
		streetRuins.scale.set(2.2, 2.1);
		streetRuins.scrollFactor.set(1, 1);
		add(streetRuins);

		brightSky.visible = false;
		streetDaytime.visible = false;
		fakeLightOfHope.visible = false;
		streetRuins.visible = false;
	}
	
	if(!lowQuality)
		{
			stageCurtains = new FNFSprite(0, 0).loadGraphic(Paths.image('i_forgor', pathWay));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.screenCenter();
			stageCurtains.scale.set(1.3,1.3);
			stageCurtains.antialiasing = true;
			stageCurtains.cameras = [PlayState.camAlt];
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			add(stageCurtains);	

			stageFront = new FNFSprite(-3000, 130).loadGraphic(Paths.image('cables', pathWay));
			stageFront.scale.set(9, 2.1);
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(5, 2.6);
			stageFront.active = false;
			foreground.add(stageFront);

			if (PlayState.SONG.song == 'Delusional')
			{
				cablesDayTime = new FlxSprite(-3000, 130).loadGraphic(Paths.image('cablesDay', pathWay));
				cablesDayTime.scale.set(9, 2.1);
				cablesDayTime.updateHitbox();
				cablesDayTime.antialiasing = true;
				cablesDayTime.scrollFactor.set(5, 2.6);
				foreground.add(cablesDayTime);

				cablesDayTime.visible = false;
			}
			
			rain = new FlxSprite(-550, -900);
			rain.frames = Paths.getSparrowAtlas('rain', pathWay);
			rain.animation.addByPrefix('drippin', 'Rain', 30, true);
			rain.scale.set(2, 2);
			rain.alpha = 0.0001;
			foreground.add(rain);
			rain.animation.play('drippin');
		}
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (PlayState.SONG.song == 'Delusional')
	{
		if (curBeat == 176 && rain != null && !lowQuality)
			rain.alpha = 1;
		//if (curBeat == 280)
			//FlxTween.tween(smoke, {alpha: 0.85}, 1.5);
		//if (curBeat == 312)
		//{
			//FlxTween.tween(firePhase1, {alpha: 1}, 1);
			//smokeParticles.emitting = true;
		//}
		//if (curBeat == 336)
		//{
			//FlxTween.tween(smoke, {alpha: 0.3}, 1.5);
			//decayedBuildings.alpha = 1;
			//floor.alpha = 0;
		//}
		if (curBeat == 474) // load daytime street assets
		{
			colorsOrSmthElse.visible = false;
			//decayedBuildings.alpha = 0;
			//smokeParticles.emitting = false;
			//firePhase1.alpha = 0;
			//smoke.alpha = 0;
			floor.visible = false;
			stageCurtains.visible = false;
			stageFront.visible = false;
			rain.visible = false;
			brightSky.visible = true;
			streetDaytime.visible = true;
			cablesDayTime.visible = true;
			clouds.visible = true;
		}
		if (curBeat == 740) // go back to the street in a even more decayed state
		{
			//firePhase2.alpha = 1;
			//smokeParticles.emitting = true;
			//fireParticles.emitting = true;
			//smoke.alpha = 0.56;
			rain.visible = true;
			streetRuins.visible = true;
			fakeLightOfHope.visible = true;
			brightSky.visible = false;
			clouds.visible = false;
			streetDaytime.visible = false;
			cablesDayTime.visible = false;
		}
	}
}
	
function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(-861, -259);

	if (boyfriend.curCharacter == 'bf-demon')
		boyfriend.setPosition(510, 170);
	else
		boyfriend.setPosition(260, 0);
}
