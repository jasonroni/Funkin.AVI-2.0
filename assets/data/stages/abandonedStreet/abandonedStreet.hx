// Base Assets
var colorsOrSmthElse:FNFSprite;
var floor:FNFSprite;
var stageCurtains:FNFSprite;
var stageFront:FNFSprite;

var atmosphereParticle:FlxEmitter;
var ashParticle:FlxEmitter;

var rain:FlxSprite;
var tumbleWeed:FlxSprite;

var streetDaytime:FlxSprite;
var clouds:FlxSprite;
var brightSky:FlxSprite;
var cablesDayTime:FlxSprite;

var streetRuins:FlxSprite;
var fakeLightOfHope:FlxSprite;

var fireThing:FlxSprite;
var fireThing2:FlxSprite; // what the fuck what the fuck what the fuck what the fuck what the fuck what the fuck
var fireForeground:FlxSprite;

var fireTweenHandler:FlxTween;

var fireParticle:FlxEmitter;

var bigSmoke1:FlxSprite;
var bigSmoke2:FlxSprite;
var bigSmoke3:FlxSprite;
var smallSmoke1:FlxSprite;
var smallSmoke2:FlxSprite;

// For events
var objects:Array<FlxSprite>;

var pathWay:String = 'data/stages/abandonedStreet/images';

function onCreate()
{
	spawnGirlfriend(false);
	PlayState.defaultCamZoom = 0.87;
	PlayState.cameraSpeed = 1;
	
	colorsOrSmthElse = new FNFSprite(-990, 1600).loadGraphic(Paths.image('randomColors', pathWay));
	colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 4));
	colorsOrSmthElse.updateHitbox();
	colorsOrSmthElse.antialiasing = true;
	colorsOrSmthElse.screenCenter();
	colorsOrSmthElse.scale.set(3, 3);
	colorsOrSmthElse.scrollFactor.set(0.9, 0.9);
	colorsOrSmthElse.active = false;
	add(colorsOrSmthElse);

	fireThing = new FlxSprite(0, -80);
	fireThing.scale.set(5.85, 3);
	fireThing.alpha = 0.0001;
	fireThing.frames = Paths.getSparrowAtlas('delusional-fire', pathWay);
	fireThing.animation.addByPrefix('burning', 'delusional-fire fire-idle', 16, true);
	fireThing.scrollFactor.set(0.8, 0.8);
	add(fireThing);
	fireThing.animation.play('burning');
	
	floor = new FNFSprite(-20, 200).loadGraphic(Paths.image('street', pathWay));
	floor.antialiasing = true;
	floor.scale.set(2.5, 2.3);
	floor.scrollFactor.set(1, 1);
	floor.active = false;
	add(floor);	

	if (PlayState.SONG.song == 'Delusional' || PlayState.SONG.song == 'Delusion')
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
		streetDaytime.scale.set(2.5, 2.3);
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

		if (!lowQuality)
		{
			fireThing2 = new FlxSprite(0, -80);
			fireThing2.scale.set(5.85, 3);
			fireThing2.alpha = 0.0001;
			fireThing2.frames = Paths.getSparrowAtlas('delusional-fire', pathWay);
			fireThing2.animation.addByPrefix('burning', 'delusional-fire fire-idle', 16, true);
			add(fireThing2);
			fireThing2.animation.play('burning');
		}

		streetRuins = new FlxSprite(-20, 200).loadGraphic(Paths.image('streetDestroyed', pathWay));
		streetRuins.antialiasing = true;
		streetRuins.scale.set(2.5, 2.3);
		streetRuins.scrollFactor.set(1, 1);
		add(streetRuins);

		if (!lowQuality)
		{
			fireForeground = new FlxSprite(0, -80);
			fireForeground.scale.set(5.85, 3);
			fireForeground.alpha = 0.0001;
			fireForeground.frames = Paths.getSparrowAtlas('delusional-fire', pathWay);
			fireForeground.animation.addByPrefix('burning', 'delusional-fire fire-idle', 16, true);
			foreground.add(fireForeground);
			fireForeground.animation.play('burning');		

			/*fireParticle = new FlxEmitter(-2080.5, 2150.4);
			fireParticle.launchMode = 'square';
			fireParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
			fireParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
			fireParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
			fireParticle.width = 4787.45;
			fireParticle.alpha.set(1, 1);
			fireParticle.lifespan.set(1.9, 4.9);
			fireParticle.loadParticles(Paths.image('fireParticle', pathWay), 500, 16, true);
			fireParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);
			foreground.add(fireParticle);*/
		}

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
			add(stageCurtains);	

			atmosphereParticle = new FlxEmitter(-2080.5, 2000);
			atmosphereParticle.launchMode = 'square';
			atmosphereParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
			atmosphereParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
			atmosphereParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
			atmosphereParticle.width = 4787.45;
			atmosphereParticle.alpha.set(1, 0.3);
			atmosphereParticle.lifespan.set(1.9, 4.9);
			atmosphereParticle.loadParticles(Paths.image('dustParticle', pathWay), 500, 16, true);
			atmosphereParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);
			foreground.add(atmosphereParticle);

			ashParticle = new FlxEmitter(-2080.5, 2150.4);
			for (i in 0 ... 100)
				{
					var blackParticle = new FlxParticle();
					blackParticle.frames = Paths.getSparrowAtlas('ashParticle', pathWay);
					blackParticle.animation.addByPrefix('idle', 'ashParticle idle', 5, true);
					blackParticle.animation.play('idle');
					blackParticle.exists = false;
					blackParticle.animation.curAnim.curFrame = FlxG.random.int(0, 9);
					ashParticle.add(blackParticle);
				}
			ashParticle.launchMode = 'circle';
			ashParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
			ashParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
			ashParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
			ashParticle.width = 4787.45;
			ashParticle.alpha.set(1, 1);
			ashParticle.lifespan.set(1.9, 4.9);
			ashParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);
			ashParticle.angle.set(290, 0);
			ashParticle.launchAngle.set(250, 210, 270, 290, 300);
			foreground.add(ashParticle);

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
	if (!lowQuality)
	{
		if (FlxG.random.bool(3))
		{
			if (PlayState.SONG.song == 'Delusional' && curBeat < 474)
				summonWeedMakerLmfao();
			else
				summonWeedMakerLmfao();
		}
	}

	if (PlayState.SONG.song == 'Lunacy')
	{
		if (curBeat == 228 || curBeat == 238 || curBeat == 244 || curBeat == 252 || curBeat == 260 || curBeat == 270 || curBeat == 276 || curBeat == 284 || curBeat == 292 || curBeat == 300 || curBeat == 308 || curBeat == 316 || curBeat == 324 || curBeat == 332 || curBeat == 340 || curBeat == 248)
		{
			if (fireTweenHandler != null)
				fireTweenHandler.cancel();

			fireTweenHandler = FlxTween.tween(fireThing, {alpha: 0.75, y: -250}, 0.35, {ease: ForeverTools.returnTweenEase('sineOut'), onComplete: function(twn:FlxTween)
				{
					fireTweenHandler = null;
				}
			});
		}
		if (curBeat == 230 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 262 || curBeat == 272 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320 || curBeat == 328 || curBeat == 336 || curBeat == 344 || curBeat == 352)
		{
			if (fireTweenHandler != null)
				fireTweenHandler.cancel();

			fireTweenHandler = FlxTween.tween(fireThing, {alpha: 0.0001, y: -80}, 0.35, {ease: ForeverTools.returnTweenEase('sineOut'), onComplete: function(twn:FlxTween)
				{
					fireTweenHandler = null;
				}
			});
		}
		if (curBeat == 416)
		{
			if (fireTweenHandler != null)
				fireTweenHandler.cancel();

			fireTweenHandler = FlxTween.tween(fireThing, {alpha: 1, y: -350}, 19.5, {ease: ForeverTools.returnTweenEase('sineInOut'), onComplete: function(twn:FlxTween)
				{
					fireTweenHandler = null;
				}
			});
		}
		if (curBeat == 480)
		{
			fireThing.alpha = 0.35;
			fireThing.y = -120;
		}
		if (curBeat == 536)
		{
			fireTweenHandler = FlxTween.tween(fireThing, {alpha: 0, y: 0}, 1, {ease: ForeverTools.returnTweenEase('sineOut'), onComplete: function(twn:FlxTween)
				{
					fireTweenHandler = null;
				}
			});
		}
	}
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
	if (dad.curCharacter == 'delusional-mickey')
		dad.setPosition(-260, 100);
	else
		dad.setPosition(-870, -190);

	if (boyfriend.curCharacter == 'bf-demon')
		boyfriend.setPosition(550, 170);
	else
		boyfriend.setPosition(275, 50);
}

function summonWeedMakerLmfao()
{
	if (FlxG.random.bool(1))
	{
		tumbleWeed = new FlxSprite(1800, 490).loadGraphic(Paths.image('THELEGENDARYTUMBLEWEED', pathWay));
		tumbleWeed.scale.set(0.6, 0.6);
		FlxTween.tween(tumbleWeed, {angle: -360}, 0.5, {type: ForeverTools.returnTweenType('looping')});
		foreground.add(tumbleWeed);

		FlxTween.tween(tumbleWeed, {y: 825}, 0.1, {ease: ForeverTools.returnTweenEase('sineInOut'), type: ForeverTools.returnTweenType('pingpong')});

		FlxTween.tween(tumbleWeed, {x: -1200}, 2, {onComplete: function(twn:FlxTween)
		{
			tumbleWeed.kill();
		}});
	}
	else
	{
		tumbleWeed = new FlxSprite(1800, 600).loadGraphic(Paths.image('Tumble_' + FlxG.random.int(0,1), pathWay));
		FlxTween.tween(tumbleWeed, {angle: -360}, 1.7, {type: ForeverTools.returnTweenType('looping')});
		foreground.add(tumbleWeed);

		FlxTween.tween(tumbleWeed, {y: 735}, 0.75, {ease: ForeverTools.returnTweenEase('sineIn'), type: ForeverTools.returnTweenType('pingpong')});

		FlxTween.tween(tumbleWeed, {x: -1200}, 5.6, {onComplete: function(twn:FlxTween)
		{
			tumbleWeed.kill();
		}});
	}
}