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
import states.MusicBeatState.MusicBeatSubstate;
import states.menus.*;
import sys.thread.Mutex;
import sys.thread.Thread;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import lime.app.Application;
import flixel.FlxCamera;

class PauseSubstate extends MusicBeatSubstate
{
	var menuItems:Array<String>;
	var curSelected:Int = 0;
	var funnyButton:FlxSprite;
	var songText:FlxSprite;
	var pauseMusic:FlxSound;
	public static var toOptions:Bool = false;
	var mutex:Mutex;
	var disc:FlxSprite;
	var songArt:FlxSprite;
	var songArtOutline:FlxSprite;	
	var creditsCard:FlxSprite; // Planning on adding a card showing credits to everyone that worked on a single song that shows from the top in the middle
	var creditsTxt:FlxText;

	public function new(x:Float, y:Float, ?itemStack:Array<String>)
	{
		super();
		
		if (itemStack == null)
		{
			switch (PlayState.SONG.song)
			{
				case 'War Dilemma': itemStack = ['wd-continue', 'wd-restart', 'wd-settings', 'wd-escape'];
				case 'Malfunction': itemStack = ['mal-continue', 'mal-restart', 'mal-settings', 'rage'];
				case 'Birthday': itemStack = ['continue', 'restart', 'settings', 'leave'];
				default: itemStack = ['continue', 'restart', 'settings', 'escape'];
			}
		}

		toOptions = false;

		menuItems = itemStack;

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

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		disc = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/pause/disc'));
		disc.setPosition(200, 0); // sets it off-screen
		disc.origin.set(970, 558); // is it centered now?
		FlxTween.tween(disc, {angle: 360}, 2.5, {type: FlxTweenType.LOOPING});
		add(disc);

		var getArt:String = 'menus/Funkin_avi/pause/songs/';
		var pauseArtAsset:String = CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase());

		songArt = new FlxSprite(800, 130);
		if (sys.FileSystem.exists('./assets/images/' + getArt + pauseArtAsset + '.png'))
			songArt.loadGraphic(Paths.image(getArt + pauseArtAsset));
		else
			songArt.loadGraphic(Paths.image(getArt + 'unknown-song'));
		songArt.scale.set(0.29, 0.29);

		songArtOutline = new FlxSprite(800 - 20, 130 - 20 /*POV: you're lazy to do the math yourself*/).makeGraphic(890, 890, FlxColor.BLACK);
		songArtOutline.scale.set(0.29,
			0.29); // this was easier for me to scale it off the ORIGINAL image size instead of just trying to get the exact graphic size of the song art being SCALED

		add(songArtOutline);
		add(songArt);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text = getSongPath();
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("DisneyFont"), 32, FlxColor.WHITE, RIGHT);
		levelInfo.updateHitbox();
		add(levelInfo);

		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});

		disc.alpha = 0;
		songArt.alpha = 0;
		songArtOutline.alpha = 0;

		FlxTween.tween(disc, {x: 0, alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
		FlxTween.tween(songArt, {x: 675, alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
		FlxTween.tween(songArtOutline, {x: 655, alpha: 1}, 0.8, {ease: FlxEase.quartInOut});

		for (i in 0...menuItems.length)
		{
			songText = new FlxSprite(0, (10 * i) + 30).loadGraphic(Paths.image('menus/Funkin_avi/pause/menuButtons/${menuItems[i]}'));
			songText.alpha = 0;
			add(songText);
			FlxTween.tween(songText, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
		}

		var skinDirectory:String = 'menus/Funkin_avi/pause/selectorSkin/';

		funnyButton = new FlxSprite(0, 0);
		switch (PlayState.SONG.song)
		{
			case 'War Dilemma':
				funnyButton.loadGraphic(Paths.image(skinDirectory + 'wd-selector'));
			case 'Malfunction':
				funnyButton.loadGraphic(Paths.image(skinDirectory + 'mal-selector'));
			default:
				funnyButton.loadGraphic(Paths.image(skinDirectory + 'select'));
		}
		add(funnyButton);

		funnyButton.alpha = 0;

		FlxTween.tween(funnyButton, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});

		changeSelection();
		PlayStateUtils.instance.loadWindowTitleData();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		switch (menuItems[curSelected])
		{
			case 'continue':
				funnyButton.x = songText.x + 300;
				funnyButton.y = 120;
			case 'restart':
				funnyButton.x = songText.x + 310;
				funnyButton.y = 265;
			case 'settings':
				funnyButton.x = songText.x + 540;
				funnyButton.y = 420;
			case 'escape':
				funnyButton.x = songText.x + 300;
				funnyButton.y = 580;
			case 'leave':
				funnyButton.x = songText.x + 530;
				funnyButton.y = 580;
			case 'wd-continue':
				funnyButton.x = songText.x + 430;
				funnyButton.y = 124;
			case 'wd-restart':
				funnyButton.x = songText.x + 370;
				funnyButton.y = 280;
			case 'wd-settings':
				funnyButton.x = songText.x + 720;
				funnyButton.y = 430;
			case 'wd-escape':
				funnyButton.x = songText.x + 570;
				funnyButton.y = 585;
			case 'mal-continue':
				funnyButton.x = songText.x + 410;
				funnyButton.y = 104;
			case 'mal-restart':
				funnyButton.x = songText.x + 420;
				funnyButton.y = 250;
			case 'mal-settings':
				funnyButton.x = songText.x + 770;
				funnyButton.y = 410;
			case 'rage':
				funnyButton.x = songText.x + 960;
				funnyButton.y = 570;
		}

		super.update(elapsed);

		var upP = Controls.getPressEvent("ui_up");
		var downP = Controls.getPressEvent("ui_down");
		var accepted = Controls.getPressEvent("accept");

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);
		if(FlxG.mouse.wheel != 0)
			changeSelection(-1 * FlxG.mouse.wheel);

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "continue" | 'wd-continue' | 'mal-continue':
					close();
					remove(disc);
					PlayStateUtils.instance.loadWindowTitleData(); // resets the title bar to the PlayState info
				case "restart" | 'wd-restart' | 'mal-restart':
					Main.switchState(this, new PlayState());
				case "Back to Charter":
					Main.switchState(this, new states.editors.OriginalChartingState());
				case "Leave Charter Mode":
					PlayState.gameplayMode = FREEPLAY;
					Main.switchState(this, new PlayState());
				case "settings" | 'wd-settings' | 'mal-settings':
					toOptions = true;
					Main.switchState(this, new OptionsMenu());
				case "escape" | 'wd-escape' | 'rage' | 'leave':
					if (PlayState.SONG.song == 'Delusional')
					{
						FlxG.camera.shake(0.05, 0.15);
						songText.alpha = 0.2;
					}
					else
					{
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
								case 'Birthday':
									Main.switchState(this, new states.ManIHateYouSoMuchYouMadeMuckneySad()); // grah
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
									if (PlayState.SONG.song.endsWith('Legacy')) // me when StringTools optimizes the code
									{
										states.menus.freeplay.FreeplaySongs.freeplayMenuList = 2;
										Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
									}
									else
									{
										states.menus.freeplay.FreeplaySongs.freeplayMenuList = 1;
										Main.switchState(this, new states.menus.freeplay.FreeplaySongs()); // yeah, there's no way I'm making a case for EVERY fucking song in that menu, too much work!
									}
							}
					}
			}
		}

		if (pauseMusic != null && pauseMusic.playing)
		{
			if (pauseMusic.volume < 0.5)
				pauseMusic.volume += 0.01 * elapsed;
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

	// TODO: making it small

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
	 * Coding: coders here
	 * Music: composers here
	 * ```
	 * @return String
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
