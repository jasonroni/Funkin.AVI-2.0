package states.menus.freeplay;

import flixel.tweens.FlxEase;
import base.dependency.Discord;
import base.song.Song;
import base.song.SongFormat.SwagSong;
import base.utils.ScoreUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.fonts.Alphabet;
import objects.ui.HealthIcon;
import openfl.media.Sound;
import states.MusicBeatState;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import flixel.FlxCamera;

class FreeplayState extends MusicBeatState
{
	//
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

	var defaultShader:FlxRuntimeShader;
	var defaultShader2:FlxRuntimeShader;
	var smilesShader:FlxRuntimeShader;

	var shaderTime:Float = 0;

	public var loadCustom:Bool = true;

	public function new(?loadCustom:Bool = false)
	{
		super();

		this.loadCustom = loadCustom;
	}

	override function create()
	{
		super.create();

		smilesShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/tvStatic.frag'), null, 120);
		defaultShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/grayScale.frag'), null, 140);
		defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);

		lime.app.Application.current.window.title = "Funkin.avi - Freeplay: Episode Songs";

		// if (GameData.episode1FPLock == 'unlocked')
		// {
		addSong('Isolated', 3, 'mickey-new', FlxColor.fromRGB(60, 60, 60));
		addSong('Lunacy', 3, 'lunamick-new', FlxColor.fromRGB(60, 60, 60));
		addSong('Delusional', 3, 'insanemick', FlxColor.fromRGB(60, 60, 60));
		// }

		// if (GameData.episodeSFPLock == 'unlocked')
		// {
		addSong('Twisted-Grins', 3, 'mr-smiles', FlxColor.fromRGB(115, 86, 86));
		addSong('Resentment', 3, 'mr-smiles', FlxColor.fromRGB(115, 86, 86));
		addSong('Mortiferum-Risus', 3, 'mr-smiles', FlxColor.fromRGB(115, 86, 86));
		// }

		// if (GameData.episodeWFPLock == 'unlocked')
		// {
		addSong('Mercy', 3, 'walt', FlxColor.fromRGB(153, 148, 112));
		addSong('Affliction', 3, 'walt', FlxColor.fromRGB(153, 148, 112));
		// }

		mutex = new Mutex();

		// load week data;
		Main.loadGameWeeks(false);

		/**
		 * Wanna add songs? they are on the Weeks Folder inside the assets folder
		 * if you wish to hardcode your weeks, make sure to look through the Main State
		**/

		loadSongs(loadCustom); // set to false in case you don't want custom songs;

		bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, CoolUtil.swapSpaceDash(songs[i].name), true, false);
			songText.isMenuItem = true;
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
	}

	function loadSongs(includeCustom:Bool)
	{
		// load in all songs that exist in folder
		var folderSongs:Array<String> = CoolUtil.returnAssetsLibrary('songs', 'assets');

		try
		{
			for (i in 0...Main.weeks.length)
			{
				// is the week locked?;
				if (checkProgression(Main.weeks[i]))
					continue;

				var gameWeek = Main.weeksMap.get(Main.weeks[i]);

				var storedSongs:Array<String> = [];
				var storedIcons:Array<String> = [];
				var storedColors:Array<FlxColor> = [];

				if (!gameWeek.hideOnFreeplay)
				{
					//
					for (i in 0...gameWeek.songs.length)
					{
						var songInfo = gameWeek.songs[i];

						storedSongs.push(songInfo.name);
						storedIcons.push(songInfo.opponent);

						//
						if (songInfo.colors != null)
							storedColors.push(FlxColor.fromRGB(songInfo.colors[0], songInfo.colors[1], songInfo.colors[2]));
						else
							storedColors.push(FlxColor.WHITE);
					}

					// actually add the week;
					addWeek(storedSongs, i, storedIcons, storedColors);
				}

				// add week songs to the existing songs array;
				for (j in storedSongs)
					existingSongs.push(j.toLowerCase());
			}

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

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songColor:Array<FlxColor>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];
		if (songColor == null)
			songColor = [FlxColor.WHITE];

		var num:Array<Int> = [0, 0];
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num[0]], songColor[num[1]]);

			if (songCharacters.length != 1)
				num[0]++;
			if (songColor.length != 1)
				num[1]++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		shaderTime += elapsed;

		smilesShader.setFloat('iTime', shaderTime);
		smilesShader.setFloat('uTime', shaderTime);

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

		if (Controls.getPressEvent("ui_left"))
			changeDiff(-1);
		if (Controls.getPressEvent("ui_right"))
			changeDiff(1);

		if (Controls.getPressEvent("back"))
		{
			if (!FlxG.keys.pressed.SHIFT)
			{
				FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
				FlxG.sound.music.stop();
			}
			threadActive = false;
			Main.switchState(this, new states.menus.FreeplayMenu());
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

		diffText.text = '< ' + existingDifficulties[curSelected][curDifficulty] + ' >';
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

		changeDiff();
		changeSongPlaying();
		updateDiscord();

		if (!Init.trueSettings.get('Disable Screen Shaders')) // to prevent lag
		{
			// ah yes, formatting made by vsc itself - jason
			switch (songs[curSelected].name.toLowerCase())
			{
				case 'twisted-grins' | 'resentment' | 'mortiferum-risus':
					FlxG.camera.setFilters([new ShaderFilter(smilesShader), new ShaderFilter(defaultShader2)]);

				default:
					FlxG.camera.setFilters([new ShaderFilter(defaultShader), new ShaderFilter(defaultShader2)]);
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

	function updateDiscord()
	{
		var mySong:String = ' [Listening to: ${songs[curSelected].name}]';
		#if DISCORD_RPC
		Discord.changePresence('CHOOSING A SONG', 'Freeplay Menu (MAIN STORY)' + mySong, 'icon', 'disc-player');
		#end
	}
}
