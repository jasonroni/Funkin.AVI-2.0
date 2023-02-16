package states.menus;

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

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];

	var eyes:FlxSprite;
	var firstStart:Bool = true;
	var finishedFunnyMove:Bool = false;
	var menuart:FlxSprite;

	var camGame:FlxCamera;
	var camHUD:FlxCamera;

	var defaultShader:FlxRuntimeShader;
	var defaultShader2:FlxRuntimeShader;
	
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

		if(GameJoltAPI.getStatus())
			{
				trace('is logged');
			}

		super.create();

		defaultShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/grayScale.frag'), null, 140);
		defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);
		camGame.setFilters(
			[
				new openfl.filters.ShaderFilter(defaultShader),
				new openfl.filters.ShaderFilter(defaultShader2)
			]);

		openfl.Lib.application.window.title = "Funkin.avi - " + randomWindowText;

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
		add(eyes);

		menuart = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/NEWmenu/newspaper'));
		menuart.scrollFactor.set(0, 0);
		//menuart.setGraphicSize(StdDaInt(menuart.width * 1.175));
		menuart.updateHitbox();
		menuart.screenCenter();
		menuart.antialiasing = true;
		add(menuart);

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
		if(optionShit.length > 6) {
			scale = 0.6 / optionShit.length;
		}

		// Story Mode
		var menuItem:FlxSprite = new FlxSprite(700, 100);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('menus/base/menuItems/' + optionShit[0]);
		menuItem.animation.addByPrefix('idle', optionShit[0] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[0] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 0;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 0;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = true;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();
		if (firstStart)
			FlxTween.tween(menuItem, {y: 100 + (0 * 90)}, 1 + (0 * 0.25), {
				ease: FlxEase.elasticInOut,
				onComplete: function(flxTween:FlxTween)
				{
					finishedFunnyMove = true;
					updateSelection();
				}
			});
		else
			menuItem.y = 108 + (0 * 90);

		// Freeplay
		var menuItem:FlxSprite = new FlxSprite(700, 250);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('menus/base/menuItems/' + optionShit[1]);
		menuItem.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[1] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 1;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 1;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = true;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();
		if (firstStart)
			FlxTween.tween(menuItem, {y: 100 + (0 * 90)}, 1 + (0 * 0.25), {
				ease: FlxEase.elasticInOut,
				onComplete: function(flxTween:FlxTween)
				{
					finishedFunnyMove = true;
					updateSelection();
				}
			});
		else
			menuItem.y = 108 + (0 * 90);

		// Credits
		var menuItem:FlxSprite = new FlxSprite(700, 400);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('menus/base/menuItems/' + optionShit[2]);
		menuItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 2;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 2;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = true;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();
		if (firstStart)
			FlxTween.tween(menuItem, {y: 100 + (0 * 90)}, 1 + (0 * 0.25), {
				ease: FlxEase.elasticInOut,
				onComplete: function(flxTween:FlxTween)
				{
					finishedFunnyMove = true;
					updateSelection();
				}
			});
		else
			menuItem.y = 108 + (0 * 90);

		firstStart = false;

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();

		// from the base game lol
		var versionShit:FlxText = new FlxText(5, FlxG.height - 25, 0, 'Funkin.AVI v2.0.0 - Demolition Engine v0.3.0', 24);
		versionShit.setFormat(Paths.font("DisneyFont"), 24, 0xFFFFFFFF, ForeverTools.setTextAlign('left'), FlxTextBorderStyle.OUTLINE, 0xFF000000);
		versionShit.scrollFactor.set();
		versionShit.cameras = [camHUD];
		add(versionShit);

		var versionShit:FlxText = new FlxText(700, FlxG.height - 25, 0, '', 24);
		if(gamejolt.GameJolt.GameJoltAPI.userLogin)
			{
				versionShit.text = '';
			} else {
				versionShit.text = 'Press 8 to log into GameJolt';
			}
		versionShit.setFormat(Paths.font("DisneyFont"), 24, 0xFFFFFFFF, ForeverTools.setTextAlign('left'), FlxTextBorderStyle.OUTLINE, 0xFF000000);
		versionShit.scrollFactor.set();
		versionShit.cameras = [camHUD];
		add(versionShit);

		if (logContent != null && logContent.length > 1)
			logTrace('$logContent', 3);

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

	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		switch randomWindowText {
		case 0:
		"Anyone up right now?";
		case 1:
		"Shipy's SNS Mickey & F.AVI Mickey will make love to each other";
		case 2:
		"We lied about Episode 2's release...";
		case 3:
		"I trapped Demolition in my basement.";
		case 4:
		"V3 will release next year, we need a fucking break";
		case 5:
		"Someone put an end to my misery. - Mickey 2023";
		case 6:
		"I dare you to press 7 on that keyboard of yours.";
		case 7:
		"Cock & ball torture.";
		case 8:
		"OKAY, YOU GOT DELUSIONAL, NOW STFU.";
		case 9:
		"Cast & Crew (Couch Song) is on Cognitive Crisis, cry about it.";
		case 10:
		"Look at that cute little devil, he c00t :3";
		case 11:
		"Do you like the new menu art?";
		case 12:
		"You're gonna love the final song.";
		case 13:
		"Malfunction isn't easy anymore, fuck you, skill issue B)";
		case 14:
		"Happy Birthday Muckney!";
		case 15:
		"Psych Engine basically corrupted all our shit, which is why it's on Forever Engine now.";
		case 16:
		"SOMEONE PLEASE GIVE MICKEY HIS FUCKING SANDWICH";
		case 17:
		"Have fun, you'll be here for like an hour or longer.";
		case 18:
		"10 Seconds before I shut your fucking game again >:(";
		new flixel.util.FlxTimer().start(10, function(e){
			System.exit(0);
		});
		case 19:
		"Oh the misery, everybody wants to be my enemy.";
		case 20:
		"Sex, NOW.";
		case 21:
		"Quick, hide behind that conveniently shaped lamp!";
		case 22:
		"Welcome to hell";
		case 23:
		"blue lobster *jumpscare*";
		case 24:
		"hi. *starts dancing on the floor*";
		case 25:
		"sample text 2: electric boogaloo";
		case 26:
		"The bastard named squidward cheated on poor mickey :(";
		case 27:
		"D E A T H";
		case 28:
		"Man, i'm starving... *Fight or Flight plays*";
		case 29:
		"Shit, the mouse got a gun again.";
		case 30:
		"You should /kill @s NOW"; //haha, funi Minecraft reference
		case 31:
		"Why are you here? FNF is still cancelled.";
		case 32:
		"This community is fr the big stinky.";
		case 33:
		"Go ahead, cancel us, you'll only make us come back stronger.";
		case 34:
		"NOOOOOOOOOOO, YOU CAN'T JUST CHEAT THE GAME!!!!!!!";
		case 35:
		"V3 Update in a Nutshell: Suicidal Remixes";
		case 36:
		"Mom, can we have Wednesday's Infidelity?";
		case 37:
		"GUYS, LOOK, IT'S SHIPY, SAY HELLO TO HER! :D";
		case 38:
		"Don't leave Muckney's party, please, you'll make him sad if you do :(";
		case 39:
		"It's about drive, it's about power, we stay hungry, we devour.";
		case 40:
		"Main Menu Music: idfk, you might've removed the damn menu music by going in and out of freeplay >:(";
		case 41:
		"Peter, the horse is here.";
		case 42:
		"*horse walks in*";
		case 43:
		"Anyone here watch Yahiamice?";
		case 44:
		"*cantaloupe jumpscare*";
		case 45:
		"POV: You're a YouTuber doing some generic intro right about now";
		case 46:
		"Another very well thought out idea of a random message that this game can randomly pick from within the code.";
		case 47:
		"AHHH, FUCK, THERE'S RULE 34 OF SUICIDE MOUSE, WHYYYYYY????";
		case 48:
		"Check out this cool rare little easter egg that I found, which I want to show to you but I can't cause I'm just a title screen message.";
		case 49:
		"There's still uranium in my ass, send help.";
	}
		
		var up = Controls.getPressEvent("ui_up", "pressed");
		var down = Controls.getPressEvent("ui_down", "pressed");
		var up_p = Controls.getPressEvent("ui_up");
		var down_p = Controls.getPressEvent("ui_down");
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					/*
						i > 1 is single press
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

		if ((Controls.getPressEvent("back")) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
			Main.switchState(this, new TitleState());
		}

		if ((Controls.getPressEvent("accept")) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('base/menus/confirmMenu'));

			var flashValue:Float = 0.1;
			if (Init.trueSettings.get('Disable Flashing Lights'))
				flashValue = 0.2;
			else
				FlxFlicker.flicker(magenta, 0.8, 0.1, false);

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
						var daChoice:String = optionShit[Math.floor(curSelected)];

						switch (daChoice)
						{
							case 'story mode':
								Main.switchState(this, new states.menus.StoryMenu());
							case 'freeplay':
								CoolUtil.difficulties = CoolUtil.difficultyArray;
								Main.switchState(this, new states.menus.FreeplayMenu());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new states.menus.OptionsMenu());
						}
					});
				}
			});
		}

		// It actually makes sense since some pepole doesn't know we moved to forever or just think we ported the psych editor lol
		if(FlxG.keys.justPressed.SEVEN) 
			{
				Main.switchState(this, new states.menus.SexState());
			} else if(FlxG.keys.justPressed.EIGHT) 
			{
				Main.switchState(this, new gamejolt.GameJolt.GameJoltLogin());
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

		// set the sprites and all of the current selection
		camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x,
			menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
			menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}
