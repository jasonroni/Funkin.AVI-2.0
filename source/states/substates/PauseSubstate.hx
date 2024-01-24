package states.substates;

import base.utils.PlayStateUtils;
import sys.FileSystem;
import base.song.Conductor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
#if (flixel <= "5.2.2")
	import flixel.system.FlxSound;
#else
	import flixel.sound.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import states.MusicBeatState.MusicBeatSubstate;
import states.menus.*;
import sys.thread.Mutex;
import sys.thread.Thread;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import lime.app.Application;
import flixel.FlxCamera;
import openfl.system.System;

class PauseSubstate extends MusicBeatSubstate
{
	public static var colorSetup:Null<FlxColor> = FlxColor.WHITE;
	public static var toOptions:Bool = false;
	#if desktop
	public static var getPropertyFromDesktop = Sys.getEnv(Sys.systemName() == "Windows" ? "UserProfile" : "HOME") + "\\Desktop";
	public static var yourName = Sys.environment()["USERNAME"];
    #end
	var bg:FlxSprite;
	var levelInfo:FlxText;
	var menuItems:Array<String>;
	var curSelected:Int = 0;
	var buttonGroup:FlxTypedGroup<FlxSprite>;
	var songText:FlxSprite;
	var pauseMusic:FlxSound;
	var leftPortrait:FlxSprite;
	var rightPortrait:FlxSprite;
	var mutex:Mutex;
	var disc:FlxSprite;
	var discColor:FlxSprite;
	var songArt:FlxSprite;
	var songArtOutline:FlxSprite;	
	var creditsCard:FlxSprite;
	var songNameBar:FlxSprite;
	var songName:FlxText;
	var countDown:FlxText;
	var hasResumed:Bool = false;
	var invertPortraits:Bool = false;
	var buttonScale:Float = 1;
	var satanTxt:FlxText;
	var satanQuotes:Array<String> = [
		"You can't leave now...",
		"Not so fast, little one...",
		"You've come too far to leave now...",
		"The fun has just begun...",
		"Don't be afraid of a little mouse...",
		"He's already died many times...",
		"What difference will you leaving do?",
		"Leaving so soon?",
		"Something wrong, " + yourName + "?",
		"Are you scared?",
		"You've seen too much, I won't let you go yet...",
		"Do you know who I am?"
	];

	public function new(x:Float, y:Float, ?itemStack:Array<String>)
	{
		super();

		if (itemStack == null)
		{
			switch (PlayState.SONG.song)
			{
				// To be continued...
				/*case 'War Dilemma': itemStack = ['wd-continue', 'wd-restart', 'wd-settings', 'wd-escape'];
				case 'Malfunction': itemStack = ['mal-continue', 'mal-restart', 'mal-settings', 'rage'];
				case 'Delusional': itemStack = ['finish-him', 'restartD', 'optionsD', 'null'];*/
				case 'Birthday': itemStack = ['resume', 'restart', 'options', 'leave'];
				case 'Cycled Sins': itemStack = ['resumeR', 'restartR', 'optionsR', 'escapeR'];
				default: itemStack = ['resume', 'restart', 'options', 'escape'];
			}
		}

		// cool stuff
		var getArt:String = 'menus/Funkin_avi/pause/songs/';
		var pauseArtAsset:String = CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase());
		toOptions = false;
		menuItems = itemStack;
		invertPortraits = /*PlayState.SONG.song == 'Devilish Deal' ? true :*/false;
		buttonScale = PlayState.SONG.song == 'Delusional' ? 0.9 : 0.6;

		if (PlayState.gameplayMode == CHARTING)
		{
			if (!menuItems.contains("Back to Charter"))
				menuItems.insert(2, "Back to Charter");
			if (!menuItems.contains("Leave Charter Mode"))
				menuItems.insert(3, "Leave Charter Mode");
		}

		mutex = new Mutex();
		Thread.create(function()
		{
			mutex.acquire();
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('funkinAVI/calmlyWinds'), true, true);
			pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
			FlxG.sound.list.add(pauseMusic);
			pauseMusic.volume = 0;
			mutex.release();
		});

		// all variable initial setups
		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		levelInfo = new FlxText(0, 150, 0, "", 32);
		songName = new FlxText(0, 20, 0, PlayState.SONG.song, 32);
		songNameBar = new FlxSprite(0, -350).loadGraphic(Paths.image('menus/Funkin_avi/pause/ui/pauseTop'));
		creditsCard = new FlxSprite(0, -780).loadGraphic(Paths.image('menus/Funkin_avi/pause/ui/pauseCredits'));
		disc = new FlxSprite(0, 720).loadGraphic(Paths.image('menus/Funkin_avi/pause/ui/pauseDisc'));
		discColor = new FlxSprite(0, 720).loadGraphic(Paths.image('menus/Funkin_avi/pause/ui/pauseDiscColor'));
		songArt = new FlxSprite(0, 560);
		songArtOutline = new FlxSprite(songArt.x - 20, songArt.y - 20 /*POV: you're lazy to do the math yourself*/).makeGraphic(890, 890, FlxColor.BLACK);
		leftPortrait = new FlxSprite(invertPortraits ? 250 : -250, 0);
		rightPortrait = new FlxSprite(invertPortraits ? -250 : 250, 0);
		countDown = new FlxText(0, 0, 0, "", 0);
		satanTxt = new FlxText(0, 650, 0, "", 0);

		// text stuff
		levelInfo.setFormat(Paths.font("disneyFreeplayFont"), 28, FlxColor.BLACK, CENTER);
		songName.setFormat(Paths.font("disneyFreeplayFont"), 60, FlxColor.BLACK, CENTER);
		countDown.setFormat(Paths.font("betterSatanFont"), 90, FlxColor.WHITE, EngineTools.setTextAlign('center'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		satanTxt.setFormat(Paths.font("betterSatanFont"), 40, FlxColor.WHITE, EngineTools.setTextAlign('center'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		// cool file check system so we don't need to compile the game everytime for this
		if (sys.FileSystem.exists('./assets/images/' + getArt + pauseArtAsset + '.png'))
			songArt.loadGraphic(Paths.image(getArt + pauseArtAsset));
		else
			songArt.loadGraphic(Paths.image(getArt + 'unknown-song'));
		if (sys.FileSystem.exists('./assets/images/menus/Funkin_avi/pause/leftPortrait/' + PlayState.opponent.curCharacter + '.png'))
			leftPortrait.loadGraphic(Paths.image('menus/Funkin_avi/pause/leftPortrait/' + PlayState.opponent.curCharacter));
		else
			leftPortrait.loadGraphic(Paths.image('menus/Funkin_avi/pause/leftPortrait/placeholder'));
		if (sys.FileSystem.exists('./assets/images/menus/Funkin_avi/pause/rightPortrait/' + PlayState.boyfriend.curCharacter + '.png'))
			rightPortrait.loadGraphic(Paths.image('menus/Funkin_avi/pause/rightPortrait/' + PlayState.boyfriend.curCharacter));
		else
			rightPortrait.loadGraphic(Paths.image('menus/Funkin_avi/pause/rightPortrait/placeholder'));

		// scales
		bg.scale.set(FlxG.width * 4, FlxG.height * 4);
		disc.scale.set(0.4, 0.4);
		discColor.scale.set(0.4, 0.4);
		songArt.scale.set(0.29, 0.29);
		songArtOutline.scale.set(0.29, 0.29); // this was easier for me to scale it off the ORIGINAL image size instead of just trying to get the exact graphic size of the song art being SCALED

		levelInfo.text = getSongPath();

		discColor.color = colorSetup;

		levelInfo.scrollFactor.set();
		bg.scrollFactor.set();
		songName.scrollFactor.set();
		countDown.scrollFactor.set();

		disc.screenCenter(X);
		discColor.screenCenter(X);
		countDown.screenCenter();
		songName.screenCenter(X);
		songArt.screenCenter(X);
		songArtOutline.screenCenter(X);
		levelInfo.screenCenter(X);
		satanTxt.screenCenter(X);

		// alpha value setup
		bg.alpha = 0.0001;
		levelInfo.alpha = 0.0001;
		songName.alpha = 0.0001;
		countDown.visible = false;

		// fuck it. add everything
		add(bg);
		add(creditsCard);
		add(songNameBar);
		add(songName);
		add(levelInfo);
		add(discColor);
		add(disc);
		add(songArtOutline);
		add(songArt);
		add(leftPortrait);
		add(rightPortrait);

		// menu buttons
		buttonGroup = new FlxTypedGroup<FlxSprite>();
		add(buttonGroup);

		for (i in 0...menuItems.length)
		{
			songText = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/Funkin_avi/pause/menuOptions/${menuItems[i]}'));
			songText.alpha = 0;
			songText.ID = i;
			songText.scale.set(buttonScale, buttonScale);
			switch (menuItems[i])
			{
				case 'resume' | 'resumeR':
					songText.x = 70;
					songText.y = 100;
				case 'restart':
					songText.x = 60;
					songText.y = 290;
				case 'options':
					songText.x = 920;
					songText.y = 100;
				case 'escape':
					songText.x = 940;
					songText.y = 290;
				case 'restartR':
					songText.x = 80;
					songText.y = 290;
				case 'optionsR':
					songText.x = 970;
					songText.y = 100;
				case 'escapeR':
					songText.x = 985;
					songText.y = 290;
				case 'leave':
					songText.x = 900;
					songText.y = 250;
					
			}
			FlxTween.tween(songText, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			buttonGroup.add(songText);
		}

		add(satanTxt);
		add(countDown);

		// tweens (bruh moment)
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartOut});
		FlxTween.tween(levelInfo, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(songName, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(disc, {y: disc.y - 420}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(discColor, {y: discColor.y - 420}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(disc, {angle: 360}, 2, {type: LOOPING});
		FlxTween.tween(songArt, {y: songArt.y - 310}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(songArtOutline, {y: songArtOutline.y - 310}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(songNameBar, {y: 0}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(creditsCard, {y: 0}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(leftPortrait, {x: 0}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(rightPortrait, {x: 0}, 0.8, {ease: FlxEase.quartOut});

		changeSelection();
		PlayStateUtils.instance.loadWindowTitleData();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		updateSelection();

		super.update(elapsed);

		var upP = Controls.getPressEvent("ui_up");
		var downP = Controls.getPressEvent("ui_down");
		var leftP = Controls.getPressEvent("ui_left");
		var rightP = Controls.getPressEvent("ui_right");
		var accepted = Controls.getPressEvent("accept");

		if (!hasResumed)
		{
			if (upP)
				changeSelection(-1);
			if (downP)
				changeSelection(1);
			if (leftP)
				changeSelection(-2);
			if (rightP)
				changeSelection(2);
			if(FlxG.mouse.wheel != 0)
				changeSelection(-1 * FlxG.mouse.wheel);
			if (accepted)
			{
				var daSelected:String = menuItems[curSelected];

				switch (daSelected)
				{
					case "resume" | 'resumeR' | 'finish-him':
						resumeGame();
					case "restart" | 'restartD' | 'restartR':
						Main.switchState(this, new PlayState());
					case "Back to Charter":
						Main.switchState(this, new states.editors.OriginalChartingState());
					case "Leave Charter Mode":
						PlayState.gameplayMode = FREEPLAY;
						Main.switchState(this, new PlayState());
					case "options" | 'optionsD' | 'optionsR':
						toOptions = true;
						Main.switchState(this, new OptionsMenu());
					case 'null':
						satanTxt.text = satanQuotes[FlxG.random.int(0, satanQuotes.length - 1)];
					case 'leave':
						Main.switchState(this, new states.ManIHateYouSoMuchYouMadeMuckneySad()); // grah
					case "escape" | 'escapeR':
							PlayState.clearStored = true;
							PlayState.resetMusic();
							PlayState.deaths = 0;

							if (PlayState.gameplayMode == STORY)
								Main.switchState(this, new StoryMenu());
							else
								switch (CoolUtil.dashToSpace(PlayState.SONG.song))
								{
									case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional' | 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus' | 'Mercy' | 'Affliction':
										states.menus.freeplay.FreeplaySongs.freeplayMenuList = 0;
										Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
									case 'Delutrance': // hahaha, you FOOL, you're obligated to play till you beat it!
										if (FlxG.save.data.highOnCrackLock == 'forceBackToSong')
										{
											Main.switchState(this, new PlayState());
										}
										else
										{
											states.menus.freeplay.FreeplaySongs.freeplayMenuList = 1;
											Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
										}
									default:
										states.menus.freeplay.FreeplaySongs.freeplayMenuList = PlayState.SONG.song.toLowerCase().endsWith('legacy') ? 2 : 1;
										Main.switchState(this, new states.menus.freeplay.FreeplaySongs()); // yeah, there's no way I'm making a case for EVERY fucking song in that menu, too much work!
								}
				}
			}
		}

		if (pauseMusic != null && pauseMusic.playing)
		{
			if (pauseMusic.volume < 0.5)
				pauseMusic.volume += 0.1 * elapsed;
		}
	}

	override function destroy()
	{
		if (pauseMusic != null)
			pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);

		if (menuItems != null)
			curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

		var bullShit:Int = 0;
	}

	function resumeGame()
	{
		hasResumed = true;
		songName.alpha = 0;
		levelInfo.alpha = 0;
		satanTxt.text = "";
		if (PlayState.pauseCountEnabled)
		{
			FlxG.sound.play(Paths.sound('dialogue/clickText'), 0.6);
			FlxTween.tween(disc, {y: disc.y + 420}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(discColor, {y: discColor.y + 420}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(songArt, {y: songArt.y + 310}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(songArtOutline, {y: songArtOutline.y + 310}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(songNameBar, {y: -350}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(creditsCard, {y: -780}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(leftPortrait, {x: invertPortraits ? 450 : -450}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(rightPortrait, {x: invertPortraits ? -450 : 450}, 0.8, {ease: FlxEase.quartOut});

			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);
				countDown.visible = true;
				countDown.text = "3";
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);
					countDown.text = "2";
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);
						countDown.text = "1";
						FlxTween.tween(bg, {alpha: 0}, 1.2, {ease: FlxEase.quartInOut});
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);
							countDown.text = "Go!";
							FlxTween.tween(countDown, {alpha: 0}, 0.4);
							new FlxTimer().start(0.55, function(tmr:FlxTimer)
							{
								close();
								remove(disc);
								PlayStateUtils.instance.loadWindowTitleData(); // resets the title bar to the PlayState info
							});
						});
					});
				});
			});
		}
		else
		{
			FlxG.sound.play(Paths.sound('dialogue/clickText'), 0.6);
			FlxTween.tween(bg, {alpha: 0}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(disc, {y: disc.y + 420}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(discColor, {y: discColor.y + 420}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(songArt, {y: songArt.y + 310}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(songArtOutline, {y: songArtOutline.y + 310}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(songNameBar, {y: -350}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(creditsCard, {y: -780}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(leftPortrait, {x: -400}, 0.4, {ease: FlxEase.quartOut});
			FlxTween.tween(rightPortrait, {x: 400}, 0.4, {ease: FlxEase.quartOut});

			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				close();
				remove(disc);
				PlayStateUtils.instance.loadWindowTitleData(); // resets the title bar to the PlayState info
			});
		}
	}	

	function updateSelection()
	{
		buttonGroup.forEach(function(spr:FlxSprite)
		{
			spr.alpha = hasResumed ? 0 : 0.45;
		});

		if (buttonGroup.members[curSelected].alpha == 0.45)
			buttonGroup.members[curSelected].alpha = hasResumed ? 0 : 1;
	}

	/**
	 * Gets the song credit information by a path
	 * 
	 * the use of a txt file is creating it on the song path and calling it `credits.txt`
	 * 
	 * ### EXAMPLE:
	 * ```txt
	 * *Song name here*
	 * Artwork: artist here
	 * Charting: charters here
	 * Programming: programmers here
	 * Music: composers here
	 * ```
	 * @return The `String` of the `credits.txt` file.
	 */
	function getSongPath():String
	{
		// checks file existence for prevent crashes
		if(FileSystem.exists(Paths.getPath('songs/${PlayState.SONG.song.toLowerCase()}/credits.txt', TEXT)))
		{
			return Paths.getTextFile('songs/${PlayState.SONG.song.toLowerCase()}/credits.txt', TEXT);
		} else {
			// default text in case it does not exist
			return Paths.getTextFile('data/defaultSongCredit.txt', TEXT);
		}
	}
}