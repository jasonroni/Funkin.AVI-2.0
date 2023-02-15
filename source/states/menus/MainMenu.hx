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
	
	var randomWindowText:Int = FlxG.random.int(0, 19);

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
		Application.current.window.title = "Anyone up right now?";
		case 1:
		Application.current.window.title = "Shipy's SNS Mickey & F.AVI Mickey will make love to each other";
		case 2:
		Application.current.window.title = "We lied about Episode 2's release...";
		case 3:
		Application.current.window.title = "I trapped Demolition in my basement.";
		case 4:
		Application.current.window.title = "V3 will release next year, we need a fucking break";
		case 5:
		Application.current.window.title = "Someone put an end to my misery. - Mickey 2023";
		case 6:
		Application.current.window.title = "I dare you to press 7 on that keyboard of yours.";
		case 7:
		Application.current.window.title = "Cock & ball torture.";
		case 8:
		Application.current.window.title = "OKAY, YOU GOT DELUSIONAL, NOW STFU.";
		case 9:
		Application.current.window.title = "Cast & Crew (Couch Song) is on Cognitive Crisis, cry about it.";
		case 10:
		Application.current.window.title = "Look at that cute little devil, he c00t :3";
		case 11:
		Application.current.window.title = "Do you like the new menu art?";
		case 12:
		Application.current.window.title = "You're gonna love the final song.";
		case 13:
		Application.current.window.title = "Malfunction isn't easy anymore, fuck you, skill issue B)";
		case 14:
		Application.current.window.title = "Happy Birthday Muckney!";
		case 15:
		Application.current.window.title = "Psych Engine basically corrupted all our shit, which is why it's on Forever Engine now.";
		case 16:
		Application.current.window.title = "SOMEONE PLEASE GIVE MICKEY HIS FUCKING SANDWICH";
		case 17:
		Application.current.window.title = "Have fun, you'll be here for like an hour or longer.";
		case 18:
		Application.current.window.title = "10 Seconds before I shut your fucking game again >:(";
		new FlxTimer().start(10, function(tmr:FlxTimer){
			System.exit(0);
		});
		case 19:
		Application.current.window.title = "Oh the misery, everybody wants to be my enemy.";
		/*case 20:
		Application.current.window.title = "Funkin.avi - mmmm, B E A N S .";
		case 21:
		Application.current.window.title = "Funkin.avi - Grunt mod real.";
		case 22:
		Application.current.window.title = "Funkin.avi - Vs Dead Bart getting dat reboot WOOOOOOOO";
		case 23:
		Application.current.window.title = "Funkin.avi - Funkin.exe is the next best thing";
		case 24:
		Application.current.window.title = "Funkin.avi - Hi, wanna see me glitch?";
		case 25:
		Application.current.window.title = "Funkin.avi - R.I.P: Welcome Old (Definitely The Best Banger Ever) /j";
		case 26:
		Application.current.window.title = "Funkin.avi - POV: Your Mom";
		case 27:
		Application.current.window.title = ".edud ssarg emos hcuot og ot deen uoy ,das yrev tsuj ,yltsenoh ,das si thaT ?sdrawkcab txet siht fo lla gnidaer otni troffe hcum os gnittup enigamI - iva.niknuF";
		//Ok so this is the fucking text: "Funkin.avi - imagine putting so much effort into reading all of shit text backwards? That is sad, honestly, just very sad, you need to go touch some grass dude."
		case 28:
		Application.current.window.title = "Funkin.avi - Play Wednesday's Infidelity!";
		case 29:
		Application.current.window.title = "Funkin.avi - Now with more depression!";
		case 30:
		Application.current.window.title = "Funkin.avi - Now with more suicide!";
		case 31:
		Application.current.window.title = "Funkin.avi - FNAF but with mice";
		case 32:
		Application.current.window.title = "Funkin.avi - No, we're not doing thicc GF fan-service art";
		case 33:
		Application.current.window.title = "Funkin.avi - Ben didn't drown, he sucked on Deez Nuts";
		case 34:
		Application.current.window.title = "Funkin.avi - What the fuck do you mean 'we have a couch song'?";
		case 35:
		Application.current.window.title = "Funkin.avi - Next Update: Malfunction will be more 'balanced' in the next update *wink wink*";
		case 36:
		Application.current.window.title = "Funkin.avi - I have your IP Address: 103.189.166.35";
		case 37:
		Application.current.window.title = "fuckin.mp3 - i juss shat meseff";
		case 38:
		Application.current.window.title = "Funkin.avi - Subscribe to Yama haki and DEMOLITIONDON96 (haha, yes, shameless advertising)";
		case 39:
		Application.current.window.title = "Funkin.avi - Fun Fact: I inhaled your mom last night";
		case 40:
		Application.current.window.title = "Funkin.avi - a";
		case 41:
		Application.current.window.title = " ";
		case 42:
		Application.current.window.title = "Funkin.avi - What do you want me to say?";
		case 43:
		Application.current.window.title = "Funkin.avi - I'm running out of things to say here...";
		case 44:
		Application.current.window.title = "Funkin.avi - This random message serves no purpose to the game or the lore";
		case 45:
		Application.current.window.title = "Funkin.avi - I'm DEAAAAAAAAAAAAD *plays Monochrome*";
		case 46:
		Application.current.window.title = "Funkin.avi - Ah yes, this is a very original and very well thought out message for the game to randomly pick";
		case 47:
		Application.current.window.title = "Funkin.avi - Stop asking for art of official female versions of the characters in this mod";
		case 48:
		Application.current.window.title = "Funkin.avi - Help, my basement full of children I kidnapped is screaming, what do I do?";
		case 49:
		Application.current.window.title = "Funkin.avi - I got uranium up my ass";
		case 50:
		Application.current.window.title = "Funkin.avi - The horny detector has detected someone here in this game, I wonder who it is...";
		case 51:
		Application.current.window.title = "Funkin.avi - Fuck you *undicks your Snickers*";
		case 52:
		Application.current.window.title = "Funkin.avi - MCM is the best mod out there so far";
		case 53:
		Application.current.window.title = "Funkin.avi - h o g .";
		case 54:
		Application.current.window.title = "Funkin.avi - HOOOG RIDDDAAAAAAAAAAAA *plays Clash Royale loading screen theme*";
		case 55:
		Application.current.window.title = "Funkin.avi - WE ARE GOING TO BEAT YOU TO DEATH.";
		case 56:
		Application.current.window.title = "Funkin.avi - Yes, we collabed with Vs Mouse, shut up about it.";
		case 57:
		Application.current.window.title = "Funkin.avi - X2 Remixes are real.";
		//Community-Made Random Messages
		case 58:
		Application.current.window.title = "Funkin.avi - A mod about a very unfortunate mouse.";
		case 59:
		Application.current.window.title = "Funkin.avi - Imagine Having More Than 50 Members?!?!?!";
		case 60:
		Application.current.window.title = "Funkin.avi - Delusional is in, now STOP ASKING FOR IT";
		case 61:
		Application.current.window.title = "Funkin.avi - Its been 40 years and the mouse still hasn't regained sanity";
		case 62:
		Application.current.window.title = "Funkin.avi - freddy fazbear.";
		case 63:
		Application.current.window.title = "Funkin.avi - We don’t know what to do with Episode 3 and 4 :/";
		case 64:
		Application.current.window.title = "Funkin.avi - Mickeys are gonna need a big bed that’s for sure";
		case 65:
		Application.current.window.title = "Funkin.avi - Among us is not funny *nerd face*";
		case 66:
		Application.current.window.title = "Funkin.avi - Discord bots are goofy aaaahhhhh";
		case 67:
		Application.current.window.title = "Funkin.avi - Whoopsie looks like i gave the suicidal mouse a gun";
		case 68:
		Application.current.window.title = "Funkin.avi - How does a sprite glitch for the main week end up being a banger side song?";
		case 69: //funi number
		Application.current.window.title = "Funkin.avi - What the dog doin?";
		case 70:
		Application.current.window.title = "Funkin.avi - Be happy with the new GameJolt login system!";
		case 71:
		Application.current.window.title = "Funkin.avi - Check us out on Friday Night Bloxxin' on Roblox!";
		case 72:
		Application.current.window.title = "Funkin.avi - There's a Red Spy in the Base!!";
		case 73:
		Application.current.window.title = "fuckin.mp3 - jsjsjsdjdsjdsjadsjjads";
		case 74:
		Application.current.window.title = "Funkin.avi - Lemon Demon got no iPhone";
		case 75:
		Application.current.window.title = "Funkin.avi - The Update Y’all were waiting";
		case 76:
		Application.current.window.title = "Funkin.avi - Mickey finds the forbidden sandwich";
		case 77:
		Application.current.window.title = "Funkin.avi - Dev Note: Add a bomb shop link in the messages";
		case 78:
		Application.current.window.title = "Funkin.avi - We literally improved everything for prevent hating";
		case 79:
		Application.current.window.title = "Funkin.avi - Go touch grass";
		case 80:
		Application.current.window.title = "Funkin.avi - Mod Includes: PC Crashing and Banger Songs";
		case 81:
		Application.current.window.title = "Funkin.avi - Stop saying the square's name is Theodore!";
		case 82:
		Application.current.window.title = "Funkin.avi - Let’s be honest, Mods are carrying FNF";
		case 83:
		Application.current.window.title = "Funkin.avi - Now better than ever!";
		case 84:
		Application.current.window.title = "Funkin.avi - Over 100+ Messages!";
		case 85:
		Application.current.window.title = "Funkin.avi - Your childhood friend is back!";
		case 86:
		Application.current.window.title = "Funkin.avi - Youtube Kids is the best at having totally not bad videos!";
		case 87:
		Application.current.window.title = "Funkin.avi - People skip this part, let’s be honest";
		case 88:
		Application.current.window.title = "Funkin.avi - when he, when he at the, he at the street, the street next door.";
		case 89:
		Application.current.window.title = "Funkin.avi - fnf is cancelled go home.";
		case 90:
		Application.current.window.title = "Funkin.avi - I've entered the mainframe, PREPARE TO LOSE YOUR PC!";
		case 91:
		Application.current.window.title = "Funkin.avi - I live in your walls.";
		case 92:
		Application.current.window.title = "Funkin.avi - saster my beloved";
		case 93:
		Application.current.window.title = "Funkin.avi - Send help, I've spent 3 months coding for this mod";
		case 94:
		Application.current.window.title = "Funkin.avi - You found the Most Difficult message ever!!!1111!1";
		case 95:
		Application.current.window.title = "Funkin.avi - Congratulations, you won, now get out.";
		case 96:
		Application.current.window.title = "Funkin.avi - I ate your doorframe now.";
		case 97:
		Application.current.window.title = "Funkin.avi - No leakers allowed ):d";
		case 98:
		Application.current.window.title = "Funkin.avi - Imagine the credits for the messages";
		case 99:
		Application.current.window.title = "Funkin.avi - Mickey getting bitches, 100% real no fake";
		case 100:
		Application.current.window.title = "Funkin.avi - Lets Goku mcdonalds, Y'know what im saiyan?";*/
		// I'm gonna make completely new messages with these soon, just hang on

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
