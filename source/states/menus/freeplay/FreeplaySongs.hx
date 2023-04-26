package states.menus.freeplay;

import base.dependency.Discord;
import base.song.Song;
import base.song.SongFormat.SwagSong;
import base.utils.ScoreUtils;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.fonts.Alphabet;
import objects.ui.HealthIcon;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import openfl.media.Sound;
import states.MusicBeatState;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;
import base.song.Conductor;

class FreeplaySongs extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	var shaders:Array<ShaderEffect> = [];

	static var curSelected:Int = 0;
	var curSongPlaying:Int = -1;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var songThread:Thread;
	var threadActive:Bool = true;
	var mutex:Mutex;
	var songToPlay:Sound = null;

	private var grpSongs:FlxTypedGroup<Alphabet>;

	private var iconArray:Array<HealthIcon> = [];

	private var mainColor:Null<FlxColor> = FlxColor.WHITE;
	private var bg:Null<FlxSprite>;
	private var scoreBG:FlxSprite;

	private var existingSongs:Array<String> = [];
	private var existingDifficulties:Array<Array<String>> = [];

	// The fact is i have to do this for organization and stuff -jason
	var camGame:FlxCamera; // Main camera
	var camHUD:FlxCamera; // Shaders and stuff

	var defaultShader2:FlxRuntimeShader;
	var smilesShader:FlxRuntimeShader;
	var mercyShader:FlxRuntimeShader;
	var mercyShader2:FlxRuntimeShader;	
	var getBlessed:FlxRuntimeShader;
	var glitchyStuff:FlxRuntimeShader;
	var chromAberration:FlxRuntimeShader;
	var urFucked:FlxRuntimeShader;
	var shaderTime:Float = 0;
	
	var gradient:FlxSprite;
	public var loadCustom:Bool = true;
	public static var freeplayMenuList = 0;

	public static var difficultyRank:String = 'HARD';

	public function new(?loadCustom:Bool = false)
	{
		super();
		this.loadCustom = loadCustom;
	}

	override function create()
	{
		Paths.clearUnusedMemory();

		super.create();

		// Categories, Shaders, and Songlist Setup
		switch (freeplayMenuList)
		{
			case 0: // Story Songs Menu
				{
					lime.app.Application.current.window.title = "Funkin.avi - Freeplay: Episode Songs";

					smilesShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/tvStatic.frag'), null, 120);
					defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);
					mercyShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/vhs.frag'), null, 130);
					mercyShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/filmgrain.frag'), null, 150);
					chromAberration = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/aberration.frag'), null, 150);
					chromAberration.setFloat('aberration', 0.12);
					chromAberration.setFloat('effectTime', 0.24);

					if (GameData.episode1FPLock == 'unlocked')
					{
						addSong('Devilish-Deal', 3, 'mickey-new', FlxColor.fromRGB(65, 88, 94));
						addSong('Isolated', 3, 'mickey-new', FlxColor.fromRGB(60, 60, 60));
						addSong('Lunacy', 3, 'lunamick-new', FlxColor.fromRGB(69, 54, 54));
						addSong('Delusional', 3, 'insanemick', FlxColor.fromRGB(79, 32, 32));
					}

					if (GameData.episodeSFPLock == 'unlocked')
					{
						addSong('Twisted-Grins', 3, 'mr-smiles', FlxColor.fromRGB(54, 38, 38));
						addSong('Resentment', 3, 'mr-smiles', FlxColor.fromRGB(99, 66, 66));
						addSong('Mortiferum-Risus', 3, 'mr-smiles', FlxColor.fromRGB(143, 91, 91));
					}

					if (GameData.episodeWFPLock == 'unlocked')
					{
						addSong('Mercy', 3, 'walt', FlxColor.fromRGB(176, 169, 116));
						addSong('Affliction', 3, 'walt', FlxColor.fromRGB(66, 63, 36));
					}
				}
			case 1: // Extras Menu
				{
					lime.app.Application.current.window.title = "Funkin.avi - Freeplay: Extra Songs";
					
					getBlessed = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/bloom.frag'), null, 120);
					glitchyStuff = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/vignetteGlitch.frag'), null, 130);
					chromAberration = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/aberration.frag'), null, 150);
					chromAberration.setFloat('aberration', 0.12);
					chromAberration.setFloat('effectTime', 0.24);
					mercyShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/vhs.frag'), null, 130);
					mercyShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/filmgrain.frag'), null, 150);
					urFucked = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/gaussian.frag'), null, 150);
					urFucked.setFloat('amount', 1);
					smilesShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/tvStatic.frag'), null, 120);
					defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);

					if (GameData.episode1FPLock == 'unlocked')
					{
						addSong('Hunted', 3, (GameData.huntedLock != 'unlocked' && GameData.huntedLock != 'beaten' ? 'untouched-song' : 'goofy-new'), FlxColor.fromRGB(94, 28, 35));
						addSong('Isolated-Old', 3, (GameData.oldisolateLock != 'unlocked' && GameData.oldisolateLock != 'beaten' ? 'untouched-song' : 'mickey-legacy'), FlxColor.fromRGB(60, 60, 60));
						addSong('Isolated-Beta', 3, (GameData.betaisolateLock != 'unlocked' && GameData.betaisolateLock != 'beaten' ? 'untouched-song' : 'mickey-legacy'), FlxColor.fromRGB(60, 60, 60));
						addSong('War-Dilemma', 3, (GameData.warLock != 'unlocked' && GameData.warLock != 'beaten' ? 'untouched-song' : 'placeholder'), FlxColor.fromRGB(204, 41, 103));
					}
						
					if (GameData.episodeSFPLock == 'unlocked')
					{
						addSong('Laugh-Track', 3, (GameData.rickyLock != 'unlocked' && GameData.rickyLock != 'beaten' ? 'untouched-song' : 'placeholder'), FlxColor.fromRGB(181, 0, 0));
						addSong('Bless', 3, (GameData.blessLock != 'unlocked' && GameData.blessLock != 'beaten' ? 'untouched-song' : 'white-noise'), FlxColor.WHITE);
						addSong('Scrapped', 3, (GameData.scrappedLock != 'unlocked' && GameData.scrappedLock != 'beaten' ? 'untouched-song' : 'rs'), FlxColor.fromRGB(0, 0, 0));
						addSong("Don't-Cross!", 3, (GameData.crossinLock != 'unlocked' && GameData.crossinLock != 'beaten' ? 'untouched-song' : 'dctl-mickey'), FlxColor.fromRGB(255, 0, 0));
					}
						
					if (GameData.episodeWFPLock == 'unlocked')
					{
						addSong('Neglection', 3, (GameData.pnmLock != 'unlocked' && GameData.pnmLock != 'beaten' ? 'untouched-song' : 'pnm'), FlxColor.fromRGB(117, 86, 27));
						addSong('Cycled-Sins', 3, (GameData.sinsLock != 'unlocked' && GameData.sinsLock != 'beaten' ? 'untouched-song' : 'relapse-new-pixel'), FlxColor.fromRGB(105, 30, 30)); //messing with the saves for this later
						addSong('Malfunction', 3, (GameData.malfunctionLock != 'unlocked' && GameData.malfunctionLock != 'beaten' ? 'untouched-song' : 'glitched-mickey-new-pixel'), FlxColor.fromRGB(150, 149, 186)); // Because Malfunction is getting some major upgrades later
					}
					
					if (GameData.muckneyLock == 'beaten')
					{
						addSong('Birthday', 3, 'muckney', FlxColor.fromRGB(84, 255, 181));
					}
					
					if (GameData.highOnCrackLock == 'completed')
					{
						addSong('Delutrance', 3, 'mick-trance', FlxColor.fromRGB(0, 16, 245)); // It's still gonna force ya to fully play it if you replay the song lmfao
					}
				}
			case 2: // Legacy Menu
				{
					lime.app.Application.current.window.title = "Funkin.avi - Freeplay: Legacy Songs";

					if (GameData.episode1FPLock == 'unlocked')
					{
						addSong('Isolated-Legacy', 3, (GameData.legacyILock != 'unlocked' && GameData.legacyILock != 'beaten' ? 'untouched-song' : 'mickey-legacy'), FlxColor.fromRGB(60, 60, 60));
						addSong('Lunacy-Legacy', 3, (GameData.legacyLLock != 'unlocked' && GameData.legacyLLock != 'beaten' ? 'untouched-song' : 'mickey-lunacy-legacy'), FlxColor.fromRGB(60, 60, 60));
						addSong('Delusional-Legacy', 3, (GameData.legacyDLock != 'unlocked' && GameData.legacyDLock != 'beaten' ? 'untouched-song' : 'mickey-delusional-unused'), FlxColor.fromRGB(60, 60, 60));
						addSong('hunted-legacy', 3, (GameData.legacyHLock != 'unlocked' && GameData.legacyHLock != 'beaten' ? 'untouched-song' : 'goofy'), FlxColor.fromRGB(0, 60, 40));
					}
						
					if (GameData.episodeSFPLock == 'unlocked')
					{
						addSong('Twisted-Grins-Legacy', 3, (GameData.legacyTLock != 'unlocked' && GameData.legacyTLock != 'beaten' ? 'untouched-song' : 'mr-smiles'), FlxColor.fromRGB(115, 86, 86));
						addSong('Resentment-Legacy', 3, (GameData.legacyRLock != 'unlocked' && GameData.legacyRLock != 'beaten' ? 'untouched-song' : 'mr-smiles'), FlxColor.fromRGB(115, 86, 86));
						addSong('Bless-Legacy', 3, (GameData.legacyBLock != 'unlocked' && GameData.legacyBLock != 'beaten' ? 'untouched-song' : 'white-noise'), FlxColor.WHITE);
					}
						
					if (GameData.episodeWFPLock == 'unlocked')
					{
						addSong('Mercy-Legacy', 3, (GameData.legacyWLock != 'unlocked' && GameData.legacyWLock != 'beaten' ? 'untouched-song' : 'walt'), FlxColor.fromRGB(153, 148, 112));
						addSong('Neglection-Legacy', 3, (GameData.legacyNLock != 'unlocked' && GameData.legacyNLock != 'beaten' ? 'untouched-song' : 'pnm'), FlxColor.CYAN);
						addSong('Cycled-Sins-Legacy', 3, (GameData.legacySLock != 'unlocked' && GameData.legacySLock != 'beaten' ? 'untouched-song' : 'relapse-pixel'), FlxColor.fromRGB(115, 86, 86));
						addSong('Malfunction-Legacy', 3, (GameData.legacyMLock != 'unlocked' && GameData.legacyMLock != 'beaten' ? 'untouched-song' : 'glitched-mickey-legacy-pixel'), FlxColor.fromRGB(140, 120, 180));
					}
				}
			case 3: // Void/Muckney Hidden Song Menu
				{
					lime.app.Application.current.window.title = "Funkin.avi - Freeplay: ???";
					
					chromAberration = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/aberration.frag'), null, 150);
					chromAberration.setFloat('aberration', 0.12);
					chromAberration.setFloat('effectTime', 0.24);				
					defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);
					
					addSong('Birthday', 3, 'muckney', FlxColor.BLACK);
				}
		}

		mutex = new Mutex();
		loadSongs(loadCustom); // set to false in case you don't want custom songs;

		bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, CoolUtil.swapSpaceDash(songs[i].name), true, false);
			if (freeplayMenuList == 2)
			{
				songText.isMenuItemCenter = true;
				songText.xAdd = -80;
			}
			else 
			{
				songText.isMenuItem = true;
			}
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].character);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - scoreText.width, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.alignment = CENTER;
		diffText.font = scoreText.font;
		diffText.x = scoreBG.getGraphicMidpoint().x;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		if(!Init.trueSettings.get('Low Quality'))
		{
			var scratchStuff:FlxSprite = new FlxSprite();
			scratchStuff.frames = Paths.getSparrowAtlas('filters/scratchShit');
			scratchStuff.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
			scratchStuff.animation.play('idle');
			scratchStuff.screenCenter();
			scratchStuff.scale.x = 1.1;
			scratchStuff.scale.y = 1.1;
			add(scratchStuff);

			var grain:FlxSprite = new FlxSprite();
			grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
			grain.animation.addByPrefix('idle', 'grains 1', 24, true);
			grain.animation.play('idle');
			grain.screenCenter();
			grain.scale.x = 1.1;
			grain.scale.y = 1.1;
			add(grain);

			gradient = new FlxSprite().loadGraphic(Paths.image('UI/gimmicks/gradient'));
			gradient.screenCenter();
	 		if (freeplayMenuList != 2) add(gradient);
		}
	}

	function loadSongs(includeCustom:Bool)
	{
		// load in all songs that exist in folder
		var folderSongs:Array<String> = CoolUtil.returnAssetsLibrary('songs', 'assets');
		try
		{
			if (includeCustom)
			{
				for (i in folderSongs)
				{
					if (!existingSongs.contains(i.toLowerCase()))
					{
						var icon:String = 'gf';
						var chartExists:Bool = FileSystem.exists(Paths.songJson(i, i));
						if (chartExists)
						{
							var castSong:SwagSong = Song.loadFromJson(i, i);
							icon = (castSong != null) ? castSong.player2 : 'gf';
							addSong(CoolUtil.spaceToDash(castSong.song), 1, icon, FlxColor.WHITE);
						}
					}
				}
			}
		}
		catch (e)
			return Main.baseGame.forceSwitch(new MainMenu('[FREEPLAY ERROR] Songs not Found! ($e)'));
	}

	function checkProgression(week:String):Bool
	{
		// here we check if the target week is locked;
		var weekProgress = Main.weeksMap.get(week);
		return weekProgress.startsLocked;
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor)
	{
		var coolDifficultyArray = [];
		for (i in CoolUtil.difficulties)
			if (FileSystem.exists(Paths.songJson(songName, songName + '-' + i))
				|| (FileSystem.exists(Paths.songJson(songName, songName)) && i == "NORMAL"))
				coolDifficultyArray.push(i);

		if (coolDifficultyArray.length > 0)
		{
			songs.push({
				name: songName,
				week: weekNum,
				character: songCharacter,
				color: songColor
			});
			existingDifficulties.push(coolDifficultyArray);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!Init.trueSettings.get('Disable Screen Shaders')) // bye bye lag
		{
			switch (freeplayMenuList)
			{
				case 2 | 3:
					{
						//nothing
					}
				default:
					{
						shaderTime += elapsed;

						if (freeplayMenuList == 1)
						{
							glitchyStuff.setFloat('time', shaderTime);
							glitchyStuff.setFloat('prob', shaderTime);
						}
						mercyShader.setFloat('time', shaderTime);
						mercyShader2.setFloat('time', shaderTime);

						smilesShader.setFloat('iTime', shaderTime);
						smilesShader.setFloat('uTime', shaderTime);
					}
			}
		}

		if (bg != null && mainColor != null)
			FlxTween.color(bg, 0.35, bg.color, mainColor);

		var lerpVal = Main.framerateAdjust(0.1);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, lerpVal));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		var upP = Controls.getPressEvent("ui_up");
		var downP = Controls.getPressEvent("ui_down");
		var accepted = Controls.getPressEvent("accept");

		if (upP)
			changeSelection(-1);
		else if (downP)
			changeSelection(1);

		if (Controls.getPressEvent("back"))
		{
			if (!FlxG.keys.pressed.SHIFT)
			{
				FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
				FlxG.sound.music.stop();
			}
			//Conductor.changeBPM(50);
			//trace('Current BPM: ${Conductor.bpm}');
			threadActive = false;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
			Main.switchState(this, new states.menus.freeplay.FreeplayCategories());
		}

		if (accepted)
		{
			var song = songs[curSelected].name.toLowerCase();

			var poop:String = ScoreUtils.formatSong(song, CoolUtil.difficulties.indexOf(existingDifficulties[curSelected][curDifficulty]));

			PlayState.SONG = Song.loadFromJson(poop, song);

			PlayState.gameplayMode = FREEPLAY;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;

			CoolUtil.difficultyString = existingDifficulties[curSelected][curDifficulty];

			threadActive = false;

			if (FlxG.keys.pressed.SHIFT)
			{
				PlayState.SONG.validScore = false;
				Main.switchState(this, new states.editors.OriginalChartingState());
			}
			else
			{
				FlxTween.tween(FlxG.camera, {zoom: 2.5}, 1.5, {ease: FlxEase.expoInOut});
				new flixel.util.FlxTimer().start(0.7, function(e)
				{
					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();

					Main.switchState(this, new PlayState());
				});
			}
		}

		// Adhere the position of all the things (I'm sorry it was just so ugly before I had to fix it Shubs)
		scoreText.text = "PERSONAL BEST:" + lerpScore;
		scoreText.x = FlxG.width - scoreText.width - 5;
		scoreBG.width = scoreText.width + 8;
		scoreBG.x = FlxG.width - scoreBG.width;
		diffText.x = scoreBG.x + (scoreBG.width / 2) - (diffText.width / 2);

		mutex.acquire();
		if (songToPlay != null)
		{
			FlxG.sound.playMusic(songToPlay);

			if (FlxG.sound.music.fadeTween != null)
				FlxG.sound.music.fadeTween.cancel();

			FlxG.sound.music.volume = 0.0;
			FlxG.sound.music.fadeIn(1.0, 0.0, 1.0);

			songToPlay = null;
		}
		mutex.release();
	}

	var lastDifficulty:String;

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		if (lastDifficulty != null && change != 0)
			while (existingDifficulties[curSelected][curDifficulty] == lastDifficulty)
				curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = existingDifficulties[curSelected].length - 1;
		if (curDifficulty > existingDifficulties[curSelected].length - 1)
			curDifficulty = 0;

		intendedScore = ScoreUtils.getScore(songs[curSelected].name, curDifficulty);

		switch (songs[curSelected].name.toLowerCase()) // update text color
		{
			case 'devilish-deal' | 'hunted-legacy' | 'isolated-beta' | 'isolated-old' | 'isolated': 
				difficultyRank = 'EASY';
				diffText.color = FlxColor.WHITE;
			case 'lunacy' | 'neglection' | 'resentment' | 'lunacy-legacy' | 'hunted' | 'mortiferum-risus' | 'isolated-legacy': 
				difficultyRank = 'NORMAL';
				diffText.color = FlxColor.fromRGB(255, 220, 220);
			case 'delusional' | 'mercy': 
				difficultyRank = 'INSANE';
				diffText.color = FlxColor.fromRGB(255, 110, 110);
			case 'malfunction': 
				difficultyRank = 'null';
				diffText.color = FlxColor.WHITE;
			case "don't-cross!": 
				difficultyRank = 'GOOD LUCK';
				diffText.color = FlxColor.fromRGB(201, 0, 0);
			case 'birthday': 
				difficultyRank = 'PARTY';
				diffText.color = FlxColor.fromRGB(250, 234, 92);
			case 'delutrance': 
				difficultyRank = 'DELUSIONAL';
				diffText.color = FlxColor.fromRGB(5, 139, 242);
			default: 
				difficultyRank = 'HARD';
				diffText.color = FlxColor.fromRGB(255, 187, 187);
		}
		diffText.text = '< ' + difficultyRank + ' >'; // display the text
		lastDifficulty = existingDifficulties[curSelected][curDifficulty];
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.4);
		FlxG.camera.flash(FlxColor.BLACK, 0.1);
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);

		intendedScore = ScoreUtils.getScore(songs[curSelected].name, curDifficulty);

		// set up color stuffs
		mainColor = songs[curSelected].color;

		// song switching stuffs
		var bullShit:Int = 0;

		if (freeplayMenuList != 2)
		{
			switch(songs[curSelected].name.toLowerCase())
			{
				case 'scrapped':
					for (i in 0...iconArray.length)
						iconArray[i].alpha = 0;

					iconArray[curSelected].alpha = 1;

					for (item in grpSongs.members)
					{
						item.targetY = bullShit - curSelected;
						bullShit++;

						item.alpha = 0;
						if (item.targetY == 0)
							item.alpha = 1;
					}

				default:
					for (i in 0...iconArray.length)
					{
						iconArray[i].alpha = 0.6;
						iconArray[i].animation.curAnim.curFrame = 0;
					}

					iconArray[curSelected].alpha = 1;

					if(songs[curSelected].name == "Birthday")
						iconArray[curSelected].animation.curAnim.curFrame = 1; // funi
					//i swear to god theres too much .replace
					else if(songs[curSelected].name.toLowerCase().replace(' ', '-').replace("'", '').replace('!', '') == "dont-cross")
						iconArray[curSelected].animation.curAnim.curFrame = 0;
					else
						iconArray[curSelected].animation.curAnim.curFrame = 2;

					for (item in grpSongs.members)
					{
						item.targetY = bullShit - curSelected;
						bullShit++;

						item.alpha = 0.6;
						if (item.targetY == 0)
							item.alpha = 1;
					}
			}
		}
		else
		{
			for (i in 0...iconArray.length)
				iconArray[i].alpha = 0.6;
	
			iconArray[curSelected].alpha = 1;
	
			for (item in grpSongs.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0.6;
				if (item.targetY == 0)
					item.alpha = 1;
			}
		}

		//if (freeplayMenuList != 2) changeCurBPM();
		changeDiff();
		changeSongPlaying();
		updateDiscord();

		if (!Init.trueSettings.get('Disable Screen Shaders')) // to prevent lag
		{
			// ah yes, formatting made by vsc itself - jason
			if (freeplayMenuList != 2)
			{
				switch (songs[curSelected].name.toLowerCase())
				{
					case 'bless':
						if(Init.trueSettings.get('Low Quality')) {
						FlxG.camera.setFilters(
							[
								new ShaderFilter(defaultShader2)
							]);
						} else {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(getBlessed), 
									new ShaderFilter(defaultShader2)
								]);
						}

					case 'malfunction':
						if(Init.trueSettings.get('Low Quality')) {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(defaultShader2)
								]);
						} else {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(glitchyStuff), 
									new ShaderFilter(chromAberration),
									new ShaderFilter(defaultShader2)
								]);
						}
						FlxG.camera.shake(0.01, 0.001);

					case "don't-cross!":
						if(Init.trueSettings.get('Low Quality')) {
						FlxG.camera.setFilters(
							[
								new ShaderFilter(defaultShader2)
							]);
						} else {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(chromAberration),
									new ShaderFilter(urFucked),
									new ShaderFilter(defaultShader2)
								]);
						}

						if(Init.trueSettings.get('Screen Shake'))
						FlxG.camera.shake(0.015, 99999999);

					case 'scrapped':
						if(Init.trueSettings.get('Low Quality')) {
						FlxG.camera.setFilters(
							[
								new ShaderFilter(defaultShader2)
							]);
						} else {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(smilesShader),
									new ShaderFilter(chromAberration),
									new ShaderFilter(defaultShader2)
								]);
						}
						FlxG.camera.shake(0.01, 0.001);

					case 'cycled-sins':
						if(Init.trueSettings.get('Low Quality')) {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(defaultShader2)
								]);
						} else {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(chromAberration),
									new ShaderFilter(mercyShader2),
									new ShaderFilter(defaultShader2)
								]);
						}

					case 'twisted-grins' | 'resentment' | 'mortiferum-risus':
						if(Init.trueSettings.get('Low Quality'))
							FlxG.camera.setFilters([new ShaderFilter(defaultShader2)]);
						else
							FlxG.camera.setFilters([new ShaderFilter(smilesShader), new ShaderFilter(defaultShader2)]);

					case 'mercy' | 'affliction':
						if(!Init.trueSettings.get('Low Quality')) {
						FlxG.camera.setFilters(
							[
								new ShaderFilter(mercyShader),
								new ShaderFilter(mercyShader2),
								new ShaderFilter(defaultShader2)
							]);
						} else {
							FlxG.camera.setFilters(
								[
									new ShaderFilter(defaultShader2)
								]);
						}
					
					case 'birthday':
						if (freeplayMenuList == 3)
						{
							if (!Init.trueSettings.get('Low Quality'))
							{
								FlxG.camera.setFilters(
								[
									new ShaderFilter(defaultShader2)
								]);
							}
							else
							{
								FlxG.camera.setFilters(
								[
									new ShaderFilter(chromAberration),
									new ShaderFilter(defaultShader2)
								]);
							}
						}
						else
						{
							FlxG.camera.setFilters([new ShaderFilter(defaultShader2)]);
							FlxG.camera.shake(0.01, 0.001);
						}
					
					case 'devilish-deal' | 'delusional':
						if(!Init.trueSettings.get('Low Quality'))
							FlxG.camera.setFilters([new ShaderFilter(chromAberration), new ShaderFilter(defaultShader2)]);
						else
							FlxG.camera.setFilters([new ShaderFilter(defaultShader2)]);
						FlxG.camera.shake(0.01, 0.001);

					default:
						FlxG.camera.setFilters([new ShaderFilter(defaultShader2)]);
						FlxG.camera.shake(0.01, 0.001);
				}
			}
		}
	}

	function changeSongPlaying()
	{
		if (songThread == null)
		{
			songThread = Thread.create(function()
			{
				while (true)
				{
					if (!threadActive)
						return;

					var index:Null<Int> = Thread.readMessage(false);
					if (index != null)
					{
						if (index == curSelected && index != curSongPlaying)
						{
							var inst:Sound = Paths.inst(songs[curSelected].name);

							if (index == curSelected && threadActive)
							{
								mutex.acquire();
								songToPlay = inst;
								mutex.release();

								curSongPlaying = curSelected;
							}
						}
					}
				}
			});
		}
		songThread.sendMessage(curSelected);
	}

	public static function getDiffRank()
	{
		switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
		{
			case 'devilish-deal' | 'hunted-legacy' | 'isolated-beta' | 'isolated-old' | 'isolated': difficultyRank = 'EASY';
			case 'lunacy' | 'neglection' | 'resentment' | 'lunacy-legacy' | 'hunted' | 'mortiferum-risus' | 'isolated-legacy': difficultyRank = 'NORMAL';
			case 'delusional' | 'mercy': difficultyRank = 'INSANE';
			case 'malfunction': difficultyRank = 'null';
			case "don't-cross!": difficultyRank = 'GOOD LUCK';
			case 'birthday': difficultyRank = 'PARTY';
			case 'delutrance': difficultyRank = 'DELUSIONAL';
			default: difficultyRank = 'HARD';
		}
	}

	function changeCurBPM():Void
	{
		switch (songs[curSelected].name.toLowerCase())
		{
			case 'devilish-deal': Conductor.changeBPM(90);
			case 'isolated' | "don't-cross!": Conductor.changeBPM(165);
			case 'lunacy': Conductor.changeBPM(188);
			case 'delusional' | 'birthday': Conductor.changeBPM(175);
			case 'twisted-grins' | 'mercy' | 'hunted' | 'war-dilemma': Conductor.changeBPM(160);
			case 'resentment' | 'scrapped': Conductor.changeBPM(180);
			case 'mortiferum-risus': Conductor.changeBPM(167);
			case 'affliction': Conductor.changeBPM(150); // this one will be changed later
			case 'isolated-old' | 'isolated-beta' | 'bless': Conductor.changeBPM(120);
			case 'laugh-track': Conductor.changeBPM(200);
			case 'neglection': Conductor.changeBPM(155);
			case 'cycled-sins': Conductor.changeBPM(161);
			case 'malfunction': Conductor.changeBPM(166);
			case 'delutrance': Conductor.changeBPM(123);
		}
		trace('Current BPM: ${Conductor.bpm}');
	}

	function updateDiscord()
	{
		var mySong:String = ' [Listening to: ${songs[curSelected].name}]';
		#if DISCORD_RPC
		#if DevBuild
		Discord.changePresence('CHOOSING A SONG', 'Freeplay Menu [CLASSIFIED]', 'icon', 'disc-player');
		#else
		switch (freeplayMenuList)
		{
			case 0:
				{
					Discord.changePresence('CHOOSING A SONG', 'Freeplay Menu (MAIN SONGS)' + mySong, 'icon', 'disc-player');
				}
			case 1:
				{
					Discord.changePresence('CHOOSING A SONG', 'Freeplay Menu (EXTRAS)' + mySong, 'icon', 'disc-player');
				}
			case 2:
				{
					Discord.changePresence('CHOOSING A SONG', 'Freeplay Menu (LEGACY)' + mySong, 'icon', 'disc-player');
				}
			case 3:
				{
					Discord.changePresence('???', 'Freeplay Menu (???)', 'icon', 'birthday-hat');
				}
		}
		#end
		#end
	}
}
