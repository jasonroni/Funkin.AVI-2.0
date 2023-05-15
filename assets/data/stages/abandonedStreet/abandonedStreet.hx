// Stage Assets
var colorsOrSmthElse:FNFSprite;
var floor:FNFSprite;
var stageCurtains:FNFSprite;
var stageFront:FNFSprite;
var rain:FlxSprite;

// For events
var objects:Array<FlxSprite>;

function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.87;
	PlayState.cameraSpeed = 1;
	PlayState.skipCountdown = true;	
	
	colorsOrSmthElse = new FNFSprite(-990, 1600).loadGraphic(Paths.image('randomColors', 'data/stages/abandonedStreet/images'));
	colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 4));
	colorsOrSmthElse.updateHitbox();
	colorsOrSmthElse.antialiasing = true;
	colorsOrSmthElse.screenCenter();
	colorsOrSmthElse.scale.set(3, 3);
	colorsOrSmthElse.scrollFactor.set(0.9, 0.9);
	colorsOrSmthElse.active = false;
	add(colorsOrSmthElse);	
	
	floor = new FNFSprite(-20, 200).loadGraphic(Paths.image('street', 'data/stages/abandonedStreet/images'));
	floor.antialiasing = true;
	floor.scale.set(2.2, 2.1);
	floor.scrollFactor.set(1, 1);
	floor.active = false;
	add(floor);		
	
	if(!lowQuality)
		{
			stageCurtains = new FNFSprite(0, 0).loadGraphic(Paths.image('i_forgor', 'data/stages/abandonedStreet/images'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.screenCenter();
			stageCurtains.scale.set(1.3,1.3);
			stageCurtains.antialiasing = true;
			stageCurtains.cameras = [PlayState.camAlt];
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			add(stageCurtains);	

			stageFront = new FNFSprite(-3000, 130).loadGraphic(Paths.image('cables', 'data/stages/abandonedStreet/images'));
			stageFront.scale.set(9, 2.1);
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(5, 2.6);
			stageFront.active = false;
			foreground.add(stageFront);
			
			rain = new FlxSprite(-400, -300);
			rain.frames = Paths.getSparrowAtlas('rain', 'data/stages/abandonedStreet/images');
			rain.animation.addByPrefix('Symbol 8 instance 1', 'Symbol 8 instance 1', 30, true);
			rain.scale.set(1.6, 1.6);
			rain.alpha = 0.0001;
			foreground.add(rain);
			rain.animation.play('Symbol 8 instance 1');
		}
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if (PlayState.SONG.song == 'Delusional')
	{
		if (curBeat == 176)
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
		//if (curBeat == 474) // load mickey's bedroom
		//{
			//colorsOrSmthElse.alpha = 0;
			//decayedBuildings.alpha = 0;
			//smokeParticles.emitting = false;
			//firePhase1.alpha = 0;
			//smoke.alpha = 0;
			//stageCurtains.alpha = 0;
			//stageFront.alpha = 0;
			//rain.alpha = 0;
			//bedroom.alpha = 1;
			//windowViewStreet.alpha = 1;
		//}
		//if (curBeat == 740) // go back to the street in a even more decayed state
		//{
			//colorsOrSmthElse.alpha = 1;
			//decayedBuildings2.alpha = 1;
			//firePhase2.alpha = 1;
			//smokeParticles.emitting = true;
			//fireParticles.emitting = true;
			//smoke.alpha = 0.56;
			//stageCurtains.alpha = 1;
			//cablesRuined.alpha = 1;
			//rain.alpha = 1;
			//bedroom.alpha = 0;
			//windowViewStreet.alpha = 0;
		//}
	}
}
	
function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(-861, -259);
	boyfriend.setPosition(260, 0);
}