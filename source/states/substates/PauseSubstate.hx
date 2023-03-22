package states.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.fonts.Alphabet;
import states.MusicBeatState.MusicBeatSubstate;
import states.menus.*;
import sys.thread.Mutex;
import sys.thread.Thread;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import lime.app.Application;
import flixel.FlxCamera;

using StringTools;

class PauseSubstate extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

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

	// var songList:Array<String> = ['cycled-sins', 'malfunction', 'episode2', 'mercy', 'bless', 'hunted', 'unknown-song'];

	public function new(x:Float, y:Float, ?itemStack:Array<String>)
	{
		super();

		// apprently, it works like this
		if (PlayState.SONG.song == 'War Dilemma')
		{
			if (itemStack == null)
				itemStack = ['wd-continue', 'wd-restart', 'wd-settings', 'wd-escape'];
		}
		else if (PlayState.SONG.song == 'Birthday')
		{
			if (itemStack == null)
				itemStack = ['continue', 'restart', 'settings', 'leave'];
		}
		else if (PlayState.SONG.song == 'Malfunction')
		{
			if (itemStack == null)
				itemStack = ['mal-continue', 'mal-restart', 'mal-settings', 'rage'];
		}
		else
		{
			if (itemStack == null)
				itemStack = ['continue', 'restart', 'settings', 'escape'];
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
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
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
		var pauseArtAsset:String = PlayState.SONG.song.toLowerCase();

		songArt = new FlxSprite(800, 130);
		switch (CoolUtil.dashToSpace(PlayState.SONG.song))
		{
			case 'Isolated':
				songArt.loadGraphic(Paths.image(getArt + 'isolated'));
			case "Don't Cross!":
				songArt.loadGraphic(Paths.image(getArt + 'dont-cross'));
			case 'Hunted':
				songArt.loadGraphic(Paths.image(getArt + 'hunted'));
			case 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus':
				songArt.loadGraphic(Paths.image(getArt + 'episode2'));
			case 'Malfunction Legacy':
				songArt.loadGraphic(Paths.image(getArt + 'malfunction'));
			case 'Malfunction':
				songArt.loadGraphic(Paths.image(getArt + 'malfunction-new'));
			case 'Mercy':
				songArt.loadGraphic(Paths.image(getArt + 'mercy'));
			case 'Mercy Legacy':
				songArt.loadGraphic(Paths.image(getArt + 'mercy-old'));
			case 'Bless':
				songArt.loadGraphic(Paths.image(getArt + 'bless'));
			case 'Cycled Sins':
				songArt.loadGraphic(Paths.image(getArt + 'cycled-sins'));
			case 'Scrapped':
				songArt.loadGraphic(Paths.image(getArt + 'scrapped'));
			case 'Delusional':
				songArt.loadGraphic(Paths.image(getArt + 'delusional'));
			default:
				songArt.loadGraphic(Paths.image(getArt + 'unknown-song'));
		}
		//songArt.loadGraphic(Paths.image(getArt + (!sys.FileSystem.exists(pauseArtAsset) ? 'unknown-song' : pauseArtAsset));
		songArt.scale.set(0.29, 0.29);

		songArtOutline = new FlxSprite(800 - 20, 130 - 20 /*POV: you're lazy to do the math yourself*/).makeGraphic(890, 890, FlxColor.BLACK);
		songArtOutline.scale.set(0.29,
			0.29); // this was easier for me to scale it off the ORIGINAL image size instead of just trying to get the exact graphic size of the song art being SCALED

		add(songArtOutline);
		add(songArt);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += '${CoolUtil.dashToSpace(PlayState.SONG.song)} - ${PlayState.SONG.composer}';
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDeaths:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDeaths.text += "Blueballed: " + PlayState.deaths;
		levelDeaths.scrollFactor.set();
		levelDeaths.setFormat(Paths.font('vcr'), 32);
		levelDeaths.updateHitbox();
		add(levelDeaths);

		levelInfo.alpha = 0;
		levelDeaths.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDeaths.x = FlxG.width - (levelDeaths.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDeaths, {alpha: 1, y: levelDeaths.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		disc.alpha = 0;
		songArt.alpha = 0;
		songArtOutline.alpha = 0;

		FlxTween.tween(disc, {x: 0, alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
		FlxTween.tween(songArt, {x: 675, alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
		FlxTween.tween(songArtOutline, {x: 655, alpha: 1}, 0.8, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

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
		loadPauseTitleData();

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

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "continue" | 'wd-continue' | 'mal-continue':
					close();
					remove(disc);
					PlayState.loadWindowTitleData(); // resets the title bar to the PlayState info
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
								case 'Isolated' | 'Lunacy' | 'Delusional' | 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus' | 'Mercy' | 'Affliction':
									Main.switchState(this, new states.menus.freeplay.FreeplayState());
								case 'Birthday':
									Main.switchState(this, new states.ManIHateYouSoMuchYouMadeMuckneySad()); // grah
								default:
									if (PlayState.SONG.song.endsWith('Legacy')) // me when StringTools optimizes the code
										Main.switchState(this, new states.menus.freeplay.LegacyState());
									else
										Main.switchState(this, new states.menus.freeplay.ExtrasState()); // yeah, there's no way I'm making a case for EVERY fucking song in that menu, too much work!
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
	
	// copy of the function from PlayState so I'm not having to do all this shit again
	
	function loadPauseTitleData()
	{
		switch (PlayState.gameplayMode)
		{
			case STORY:
				switch (PlayState.SONG.song)
				{
					case 'Isolated' | 'Lunacy' | 'Delusional':
						Application.current.window.title = 'Funkin.avi - Episode 1: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + " - [" + CoolUtil.difficultyString + "] - {PAUSED}";
						
					case 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus':
						Application.current.window.title = 'Funkin.avi - Episode S: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + " - [" + CoolUtil.difficultyString + "] - {PAUSED}";
				
					case 'Mercy' | 'Affliction':
						Application.current.window.title = 'Funkin.avi - Episode W: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + " - [" + CoolUtil.difficultyString + "] - {PAUSED}";
				
					default:
						Application.current.window.title = 'Funkin.avi - Episode ???: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + " - [" + CoolUtil.difficultyString + "] - {PAUSED}";
				}
					
			case FREEPLAY:
				Application.current.window.title = 'Funkin.avi - Freeplay: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + " - [" + CoolUtil.difficultyString + "] - {PAUSED}";
				
			case CHARTING:
				if (SONG.song == 'Malfunction')
					Application.current.window.title = 'glitchedMickey.xml - CHEATER MODE ACTIVATED: ' + PlayState.SONG.song + " - Composed by: I CAN SEE YOU CHEATING! - [!CHEATER DETECTED!] - {PAUSED}";
				else
					Application.current.window.title = 'Funkin.avi - TESTING MODE: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + " - [" + CoolUtil.difficultyString + "] - {PAUSED}";
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

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
		//
	}
}
