package states.menus;

import sys.io.File;
import base.dependency.Discord;
import base.dependency.FeatherDeps.ScriptHandler;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flash.system.System;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import states.MusicBeatState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import base.song.Song;

using StringTools;

/**
 * This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
 * Get as expressive as you can with this, create your own menu!
 * 
 * I really need to make a structure to manage and customize menus haha @BeastlyGhost
**/
class MainMenu extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];

	//HOWTODELUSIONAL
	var delutranceLmao:Array<Dynamic> = [
		[FlxKey.H, FlxKey.H], 
		[FlxKey.O, FlxKey.O], 
		[FlxKey.W, FlxKey.W], 
		[FlxKey.T, FlxKey.T], 
		[FlxKey.O, FlxKey.O],
		[FlxKey.D, FlxKey.D],
		[FlxKey.E, FlxKey.E],
		[FlxKey.L, FlxKey.L],
		[FlxKey.U, FlxKey.U],
		[FlxKey.S, FlxKey.S],
		[FlxKey.I, FlxKey.I],
		[FlxKey.O, FlxKey.O],
		[FlxKey.N, FlxKey.N],
		[FlxKey.A, FlxKey.A],
		[FlxKey.L, FlxKey.L]
	];
	
	// the anniversary date of Funkin.avi lmao
	var birthdayCode:Array<Dynamic> = [
		[FlxKey.ZERO, FlxKey.NUMPADZERO],
		[FlxKey.THREE, FlxKey.NUMPADTHREE],
		[FlxKey.TWO, FlxKey.NUMPADTWO],
		[FlxKey.ONE, FlxKey.NUMPADONE],
		[FlxKey.TWO, FlxKey.NUMPADTWO],
		[FlxKey.TWO, FlxKey.NUMPADTWO]
	];
	
	var theCodeOrder:Int = 0;
	var theBirthdayCode:Int = 0;

	var eyes:FlxSprite;
	var floor:FlxSprite;
	var blood:FlxSprite;
	var otherCoolDetail:FlxSprite;
	var moreCoolDetails:FlxSprite;
	var omgCamera:FlxSprite;
	var datBook:FlxSprite;

	var gradient:FlxSprite;

	var arrow:FlxSprite;

	var firstStart:Bool = true;
	var finishedFunnyMove:Bool = false;

	var freeplayPopup:FlxText;
	var freeplayPopupSub:FlxText;
	var freeplayTxtBox:FlxSprite;
	var freeplayTxtTween:FlxTween;
	var freeplayTxtTween2:FlxTween;
	var freeplayTxtTween3:FlxTween;

	var camGame:FlxCamera;
	var camHUD:FlxCamera;

	var windowShit:Array<Any> = [
			"Anyone up right now?",
			"Shipy's SNS Mickey & F.AVI Mickey will make love to each other",
			"We lied about Episode 2's release...",
			"I trapped Demolition in my basement.",
			"V3 will release next year, we need a fucking break",
			"Someone put an end to my misery. - Mickey 2023",
			"I dare you to press 7 on that keyboard of yours.",
			"Cock & ball torture.",
			"OKAY, YOU GOT DELUSIONAL, NOW STFU.",
			"Cast & Crew (Couch Song) is on Cognitive Crisis, cry about it.",
			"Look at that cute little devil, he c00t :3",
			"Do you like the new menu art?",
			"You're gonna love the final song.",
			"Malfunction isn't easy anymore, fuck you, skill issue B)",
			"Happy Birthday Muckney!",
			"Psych Engine basically corrupted all our shit, which is why it's on Forever Engine now.",
			"SOMEONE PLEASE GIVE MICKEY HIS FUCKING SANDWICH",
			"Have fun, you'll be here for like an hour or longer.",
			"10 Seconds before I shut your fucking game again >:(",
			"Oh the misery, everybody wants to be my enemy.",
			"Sex, NOW.",
			"Quick, hide behind that conveniently shaped lamp!",
			"Welcome to hell",
			"blue lobster *jumpscare*",
			"hi. *starts dancing on the floor*",
			"sample text 2: electric boogaloo",
			"The bastard named squidward cheated on poor mickey :(",
			"D E A T H",
			"Man, i'm starving... *Fight or Flight plays*",
			"Shit, the mouse got a gun again.",
			"You should /kill @s NOW", //haha, funi Minecraft reference
			"Why are you here? FNF is still cancelled.",
			"This community is fr the big stinky.",
			"Go ahead, cancel us, you'll only make us come back stronger.",
			"NOOOOOOOOOOO, YOU CAN'T JUST CHEAT THE GAME!!!!!!!",
			"V3 Update in a Nutshell: Suicidal Remixes",
			"Mom, can we have Wednesday's Infidelity?",
			"GUYS, LOOK, IT'S SHIPY, SAY HELLO TO HER! :D",
			"Don't leave Muckney's party, please, you'll make him sad if you do :(",
			"It's about drive, it's about power, we stay hungry, we devour.",
			"Main Menu Music: idfk, you might've removed the damn menu music by going in and out of freeplay >:(",
			"Peter, the horse is here.",
			"*horse walks in*",
			"Anyone here watch Yahiamice?",
			"*cantaloupe jumpscare*",
			"Prank 'em John",
			"POV: You're a YouTuber doing some generic intro right about now",
			"Another very well thought out idea of a random message that this game can randomly pick from within the code.",
			"AHHH, FUCK, THERE'S RULE 34 OF SUICIDE MOUSE, WHYYYYYY????",
			"Check out this cool rare little easter egg that I found, which I want to show to you but I can't cause I'm just a title screen message.",
			"There's still uranium in my ass, send help.",
			"Main Menu Music: Soulless Town",
			"Mickey lost his ballsack.",
			"Oh the horror of AI generated images.",
			"You should [R] Reset Character NOW", // boblox reference
			"peak mouse experience.",
			"Austin is the most horniest of the team lmao",
			"This mod was stressful to make, the organization was a mess lmao",
			"Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi - Funkin.avi",
			"Just like Domingo is constantly remaking Mickey's sprites, Dreupy is the Domingo of Delusional Recharts.",
			"Type \"HOWTODELUSIONAL\" for a special surprise :)",
			"When did Funkin.avi start development?",
			"I think one of the codes is a certain date",
			"This mod was an idea that started on 03/21/22, pretty crazy, right?",
			"Everyday is Muckney's Birthday",
			"there is no message, go play some minecraft"
			
	];

	var defaultShader:FlxRuntimeShader;
	var defaultShader2:FlxRuntimeShader;
	var darkFilter:FlxRuntimeShader;
	
	var randomWindowText:Int = FlxG.random.int(0, 49);

	public var logContent:String;

	public function new(?logContent:String)
	{
		super();

		this.logContent = logContent;
	}

	// the create 'state'
	override function create()
	{
		camGame = new FlxCamera(); // Main camera for objects and stuff

		camHUD = new FlxCamera(); // for the grain effect and etc
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		Paths.clearUnusedMemory();

		super.create();

		if (!Init.trueSettings.get('Disable Screen Shaders'))
		{
			defaultShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/grayScale.frag'), null, 140);
			defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);
			darkFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/coolDarkFilter.frag'), null, 120);

			if(!Init.trueSettings.get('Disable Screen Shaders'))
				{
					if(!Init.trueSettings.get('Low Quality')) {
					camGame.setFilters(
						[
							new openfl.filters.ShaderFilter(defaultShader2),
							new openfl.filters.ShaderFilter(defaultShader),
							new openfl.filters.ShaderFilter(darkFilter),
						]);
					} else {
					camGame.setFilters(
						[
							new openfl.filters.ShaderFilter(defaultShader2),
						]);
					}
				}
		}

		openfl.Lib.application.window.title = "Funkin.avi - " + windowShit[FlxG.random.int(0, windowShit.length-1)];

		//shutdowns the game
		if(openfl.Lib.application.window.title.contains('10 Seconds before I shut your fucking game again >:('))
			{
				new flixel.util.FlxTimer().start(10, function(e)
					{
						Sys.exit(0);
					});
			}

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		#if DISCORD_RPC
		Discord.changePresence('MENU SCREEN', 'Main Menu', 'icon', 'mouse');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		eyes = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/NEWmenu/HahaSadBoi'));
		eyes.scrollFactor.set(0, 0);
		eyes.screenCenter();
		eyes.updateHitbox();
		eyes.antialiasing = true;

		floor = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu/floor'));
		floor.scrollFactor.set(0, 0);
		floor.setGraphicSize(Std.int(floor.width * 0.75));
		floor.updateHitbox();
		floor.screenCenter();
		floor.antialiasing = true;
		add(floor);

		if(!Init.trueSettings.get('Low Quality')) {
		blood = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu/blood'));
		blood.scrollFactor.set(0, 0);
		blood.setGraphicSize(Std.int(blood.width * 0.75));
		blood.updateHitbox();
		blood.screenCenter();
		blood.antialiasing = true;
		add(blood);

		otherCoolDetail = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu/coolDetails'));
		otherCoolDetail.scrollFactor.set(0, 0);
		otherCoolDetail.setGraphicSize(Std.int(otherCoolDetail.width * 0.75));
		otherCoolDetail.updateHitbox();
		otherCoolDetail.screenCenter();
		otherCoolDetail.antialiasing = true;
		add(otherCoolDetail);
		
		omgCamera = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu/camera_in_a_cool_way'));
		omgCamera.scrollFactor.set(0, 0);
		omgCamera.setGraphicSize(Std.int(omgCamera.width * 0.75));
		omgCamera.updateHitbox();
		omgCamera.screenCenter();
		omgCamera.antialiasing = true;
		add(omgCamera);
		}

		datBook = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu/book'));
		datBook.scrollFactor.set(0, 0);
		datBook.setGraphicSize(Std.int(datBook.width * 0.75));
		datBook.updateHitbox();
		datBook.screenCenter();
		datBook.antialiasing = true;
		add(datBook);

		if(!Init.trueSettings.get('Low Quality')) {
		moreCoolDetails = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu/light'));
		moreCoolDetails.scrollFactor.set(0, 0);
		moreCoolDetails.setGraphicSize(Std.int(moreCoolDetails.width * 0.75));
		moreCoolDetails.updateHitbox();
		moreCoolDetails.screenCenter();
		moreCoolDetails.antialiasing = true;
		add(moreCoolDetails);

		arrow = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/menu_arrow'));
		arrow.setGraphicSize(Std.int(arrow.width * 0.3));
		arrow.screenCenter(X);
		arrow.scrollFactor.set(0, 0);
		add(arrow);

		gradient = new FlxSprite().loadGraphic(Paths.image('filters/gradient'));
		gradient.scrollFactor.set(0, 0);
		gradient.setGraphicSize(Std.int(gradient.width * 0.75));
		gradient.updateHitbox();
		gradient.screenCenter();
		gradient.antialiasing = true;
		add(gradient);
		}

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menus/base/menuDesat'));
		magenta.scrollFactor.set(0, 0.18);
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.8;

		for (i in 0...optionShit.length)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 100)  + offset);
				menuItem.scale.set(0.6, 0.6);
				menuItem.frames = Paths.getSparrowAtlas('menus/Funkin_avi/mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItem.x -= 180;
				menuItem.y += 158 + (0 * 25) - 100;
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				menuItem.scrollFactor.set(0, scr);
				menuItem.antialiasing = true;
				//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
				menuItem.updateHitbox();

				if(arrow != null)
				arrow.angle = 90;
			}

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();

		// from the base game lol
		var versionShit:FlxText = new FlxText(5, FlxG.height * 0.01, 0, 'Funkin.avi v2.0.0\nForever engine v0.3.1', 24);
		versionShit.setFormat(Paths.font("DisneyFont"), 29, 0xFFFFFFFF, ForeverTools.setTextAlign('left'), FlxTextBorderStyle.OUTLINE, 0xFF000000);
		versionShit.scrollFactor.set();
		versionShit.cameras = [camHUD];
		add(versionShit);

		if(Init.trueSettings.get('FPS Counter') && Init.trueSettings.get('Memory Counter'))
			{
				versionShit.y = FlxG.height - 80;
			}

		if (logContent != null && logContent.length > 1)
			logTrace('$logContent', 3);
		
		freeplayPopup = new FlxText(0, FlxG.height - 80, 0, 'Freeplay is Locked!', 24);
		freeplayPopup.setFormat(Paths.font("DisneyFont"), 32, 0xFFFFFFFF, ForeverTools.setTextAlign('left'), FlxTextBorderStyle.OUTLINE, 0xFF000000);
		freeplayPopup.scrollFactor.set();
		freeplayPopup.cameras = [camHUD];
		
		freeplayPopupSub = new FlxText(0, freeplayPopup.y + 30, 0, 'Complete Episode 1 to Unlock this Menu!', 24);
		freeplayPopupSub.setFormat(Paths.font("DisneyFont"), 24, 0xFFFFFFFF, ForeverTools.setTextAlign('left'), FlxTextBorderStyle.OUTLINE, 0xFF000000);
		freeplayPopupSub.scrollFactor.set();
		freeplayPopupSub.cameras = [camHUD];
		
		freeplayTxtBox = new FlxSprite(0, freeplayPopup.y).makeGraphic(350, 90, FlxColor.BLACK);
		freeplayTxtBox.scrollFactor.set();
		freeplayTxtBox.cameras = [camHUD];
		
		freeplayTxtBox.alpha = 0;
		freeplayPopup.alpha = 0;
		freeplayPopupSub.alpha = 0;

		freeplayTxtBox.x -= 400;
		freeplayPopup.x -= 400;
		freeplayPopupSub.x -= 400;
		
		add(freeplayTxtBox);
		add(freeplayPopup);
		add(freeplayPopupSub);

		if(!Init.trueSettings.get('Low Quality')) {
		var scratchStuff:FlxSprite = new FlxSprite();
		scratchStuff.frames = Paths.getSparrowAtlas('filters/scratchShit');
		scratchStuff.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
		scratchStuff.animation.play('idle');
		scratchStuff.screenCenter();
		scratchStuff.scale.x = 1.1;
		scratchStuff.scale.y = 1.1;
		scratchStuff.cameras = [camHUD];
		add(scratchStuff);

		var grain:FlxSprite = new FlxSprite();
		grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
		grain.animation.addByPrefix('idle', 'grains 1', 24, true);
		grain.animation.play('idle');
		grain.screenCenter();
		grain.scale.x = 1.1;
		grain.scale.y = 1.1;
		grain.cameras = [camHUD];
		add(grain);
		}
	}

	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		var up = Controls.getPressEvent("ui_up", "pressed");
		var down = Controls.getPressEvent("ui_down", "pressed");
		var up_p = Controls.getPressEvent("ui_up");
		var down_p = Controls.getPressEvent("ui_down");
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		//camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		//you are 100% obligated lmao
			if (FlxG.keys.justPressed.ANY) {
				var hitCorrectKey:Bool = false;
				var birthdayKey:Bool = false;

				for (i in 0...delutranceLmao[theCodeOrder].length) {
					if (FlxG.keys.checkStatus(delutranceLmao[theCodeOrder][i], JUST_PRESSED))
						hitCorrectKey = true;
				}

				for (b in 0...birthdayCode[theBirthdayCode].length) {
					if (FlxG.keys.checkStatus(birthdayCode[theBirthdayCode][b], JUST_PRESSED))
						birthdayKey = true;
				}

				if (hitCorrectKey) {
					if (theCodeOrder == (delutranceLmao.length - 1)) {
						PlayState.gameplayMode = FREEPLAY;
						PlayState.storyDifficulty = 0;
						PlayState.SONG = Song.loadFromJson('delutrance-hard', 'delutrance');
						PlayState.campaignScore = 0;
						PlayState.campaingMisses = 0;
						new FlxTimer().start(0.25, function(tmr:FlxTimer)
						{
							Main.switchState(this, new states.PlayState());
							FlxG.sound.music.volume = 0;
						});
					} else {
						theCodeOrder++;
					}
				} else {
					theCodeOrder = 0;
					for (i in 0...delutranceLmao[0].length) {
						if (FlxG.keys.checkStatus(delutranceLmao[0][i], JUST_PRESSED))
							theCodeOrder = 1;
					}
				}

				if (birthdayKey) {
					if (theBirthdayCode == (birthdayCode.length - 1)) {
						states.menus.freeplay.FreeplaySongs.freeplayMenuList = 3; //void lol
						Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
					} else {
						theBirthdayCode++;
					}
				} else {
					theBirthdayCode = 0;
					for (b in 0...birthdayCode[0].length) {
						if (FlxG.keys.checkStatus(birthdayCode[0][b], JUST_PRESSED))
							theBirthdayCode = 1;
					}
				}
			}

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{

			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					/*
						i > 1 is single pressá
						up is 2, down is 3
					 */

					var changeValue:Int = 0;

					if (i > 1)
					{
						if (i == 2)
							changeValue -= 1;
						else if (i == 3)
							changeValue += 1;

						FlxG.sound.play(Paths.sound('base/menus/scrollMenu'));
					}

					curSelected = FlxMath.wrap(Math.floor(curSelected) + changeValue, 0, optionShit.length - 1);
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}

		if (!Init.trueSettings.get('Disable Screen Shaders')) darkFilter.setFloat('iTime', elapsed);

		if ((Controls.getPressEvent("back")) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
			Main.switchState(this, new TitleState());
		}

		if ((Controls.getPressEvent("accept")) && (!selectedSomethin))
		{
			var daChoice:String = optionShit[Math.floor(curSelected)];

			var flashValue:Float = 0.1;
			if (Init.trueSettings.get('Disable Flashing Lights'))
				flashValue = 0.2;

			if(daChoice == 'freeplay')
			{
						if(GameData.episode1FPLock == 'unlocked')
						{
							selectedSomethin = true;
							FlxG.sound.play(Paths.sound('funkinAVI/menu/select_sfx'));
							FlxTween.tween(camGame, {zoom: 6}, 2, {ease: FlxEase.cubeInOut, startDelay: 0.5});
	
							menuItems.forEach(function(spr:FlxSprite)
								{
									if (curSelected != spr.ID)
									{
										// Main Menu Select Animations
										FlxTween.tween(spr, {x: -250, alpha: 0}, 0.4, {
											ease: FlxEase.quadOut,
											onComplete: function(twn:FlxTween)
											{
												spr.kill();
											}
										});
									}
									else
									{
										FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
										{
											switch (daChoice)
											{
												case 'freeplay':
													CoolUtil.difficulties = CoolUtil.difficultyArray;
													Main.switchState(this, new states.menus.freeplay.FreeplayCategories());
											}
										});
									}
								});
						}else{
							if (freeplayTxtTween != null)
								freeplayTxtTween.cancel();
							if (freeplayTxtTween2 != null)
								freeplayTxtTween2.cancel();
							if (freeplayTxtTween3 != null)
								freeplayTxtTween3.cancel();
								
							FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
							// Okay, this should work better now
							freeplayTxtTween = FlxTween.tween(
								freeplayPopup,
								{
									alpha: 1,
									x: 0
								},
								   0.8,
								   {
									ease: FlxEase.sineOut,
									onComplete: function(twn:FlxTween)
									{
										freeplayTxtTween = FlxTween.tween(
											freeplayPopup,
											{
												alpha: 0,
												x: -400
											},
											1.5,
											{
												startDelay: 3,
												ease: FlxEase.sineInOut,
												onComplete: function(twn:FlxTween)
												{
													freeplayTxtTween = null;
												}
											}
										);
									}
								}
							);
							freeplayTxtTween2 = FlxTween.tween(
								freeplayPopupSub,
								{
									alpha: 1,
									x: 0
								},
								   0.8,
								   {
									ease: FlxEase.sineOut,
									onComplete: function(twn:FlxTween)
									{
										freeplayTxtTween2 = FlxTween.tween(
											freeplayPopupSub,
											{
												alpha: 0,
												x: -400
											},
											1.5,
											{
												startDelay: 3,
												ease: FlxEase.sineInOut,
												onComplete: function(twn:FlxTween)
												{
													freeplayTxtTween2 = null;
												}
											}
										);
									}
								}
							);
							freeplayTxtTween3 = FlxTween.tween(
								freeplayTxtBox,
								{
									alpha: 1,
									x: 0
								},
								   0.8,
								   {
									ease: FlxEase.sineOut,
									onComplete: function(twn:FlxTween)
									{
										freeplayTxtTween3 = FlxTween.tween(
											freeplayTxtBox,
											{
												alpha: 0,
												x: -400
											},
											1.5,
											{
												startDelay: 3,
												ease: FlxEase.sineInOut,
												onComplete: function(twn:FlxTween)
												{
													freeplayTxtTween3 = null;
												}
											}
										);
									}
								}
							);
						}
					}else{

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0, x: FlxG.width * 2}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, flashValue, false, false, function(flick:FlxFlicker)
					{
						switch (daChoice)
						{
							case 'story_mode':
								Main.switchState(this, new states.menus.StoryMenu());
							case 'credits':
								Main.switchState(this, new states.menus.OptionsMenu());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new states.menus.OptionsMenu());
						}
					});
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('base/menus/confirmMenu'));
					FlxTween.tween(camGame, {zoom: 6}, 2, {ease: FlxEase.cubeInOut, startDelay: 0.5});
				}
			});
		}
	}

		// It actually makes sense since some pepole doesn't know we moved to forever or just think we ported the psych editor lol
		if(FlxG.keys.justPressed.SEVEN) 
			{
				Main.switchState(this, new states.menus.SexState());
			} else if(FlxG.keys.justPressed.EIGHT) 
			{
				Main.switchState(this, new GameJoltLogin());
			}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);

		menuItems.forEach(function(menuItem:FlxSprite)
		{
		});
	}

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

		if(arrow != null) {
		switch(curSelected)
		{
			case 0:
				arrow.y = 60;
				arrow.x = -20;
			case 1:
				arrow.y = 170;
				arrow.x = 35;
			case 2:
				arrow.y = 265;
				arrow.x = 35;
			case 3:
				arrow.y = 355;
				arrow.x = 35;
		}
	}

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
			menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}
