package states;

import base.events.Events;
import base.dependency.FeatherDeps.Events;
import base.dependency.FeatherDeps.ScriptHandler;
import base.song.ChartParser;
import base.song.Conductor;
import base.song.Song;
import base.song.SongFormat.SwagSong;
import base.song.SongFormat.TimedEvent;
import base.utils.FNFUtils.FNFSprite;
import base.utils.ScoreUtils;
import flash.system.System;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import lime.app.Application;
import lime.ui.Window;
import objects.*;
import objects.Character;
import objects.ui.*;
import objects.ui.notes.*;
import objects.ui.notes.Strumline.Receptor;
import objects.ui.hud.hardcoded.*;
import objects.ui.hud.toggleable.*;
import openfl.media.Sound;
import states.CutsceneState;
import states.editors.CharacterOffsetEditor;
import states.menus.*;
import states.substates.GameOverSubstate;
// This fixes 2.6.0 users
#if (hxCodec >= "2.6.1")
import hxcodec.VideoHandler;
#elseif (hxCodec == "2.6.0")
import VideoHandler;
#else
import vlc.MP4Handler as VideoHandler;
#end
#if desktop
import base.dependency.Discord;
#end
	
using StringTools;

enum GameMode
{
	STORY;
	FREEPLAY;
	CHARTING;
}

class PlayState extends MusicBeatState
{
	// defines the Gameplay Mode for the game;
	public static var gameplayMode:GameMode;

	// for Static Access to this Class;
	public static var main:PlayState;

	// Scripts;
	public static var moduleArray:Array<ScriptHandler> = [];

	// Notes;
	public var notesGroup:Notefield;

	public static var timedEvents:Array<TimedEvent> = [];
	
	// note stuff
	@:isVar public static var songSpeed(get, default):Float = 0;
	public var songSpeedTween:FlxTween;

	// lazyness
	public var canaddshaders = !Init.trueSettings.get('Disable Screen Shaders');

	// Song;
	public static var SONG:SwagSong;
	public static var songMusic:FlxSound;
	public static var songLength:Float = 0;
	public static var vocals:FlxSound;
	public static var bf_vocals:FlxSound;
	public static var opp_vocals:FlxSound;
	public static var songMusicNew:FlxSound;

	public static var generatedMusic:Bool = false;

	public static var curStage:String = '';

	// Story Mode;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 2;

	// Player;
	public static var deaths:Int = 0;
	public static var campaignScore:Int = 0;
	public static var campaingMisses:Int = 0;
	public static var health:Float = 1; // mario;

	// Characters;
	public static var opponent:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	var grayScale:FlxRuntimeShader;
	var tilt:FlxRuntimeShader;
	var andromeda:FlxRuntimeShader;

	// used by events, stores characters and character names in maps;
	public static var playerMap:Map<String, Character> = new Map();
	public static var opponentMap:Map<String, Character> = new Map();
	public static var spectatorMap:Map<String, Character> = new Map();

	// Custom;
	public static var assetModifier:String = 'base';
	public static var changeableSkin:String = 'default';

	// Discord RPC;
	public static var songDetails:String = "";
	public static var detailsSub:String = "";
	public static var detailsPausedText:String = "";
	public static var iconRPC:String = "";
	public static var storyDifficultyText:String = "";

	// Events;
	public var startingSong:Bool = false;
	public var endingSong:Bool = false;
	public var startedCountdown:Bool = false;

	// Events 2: Electric Bogaloo
	private var isolatedEvents:IsolatedEvents;

	public static var clearStored:Bool = false;

	public var skipCountdown:Bool = false;
	public var inCutscene:Bool = false;
	public var canPause:Bool = true;
	public var paused:Bool = false;

	// Cameras;
	private var camFollow:FlxObject;
	private var camFollowPos:FlxObject;

	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;
	public static var dialogueHUD:FlxCamera;
	public static var camScratch:FlxCamera;
	public static var camOther:FlxCamera;
	public static var camAlt:FlxCamera;

	private static var prevCamFollow:FlxObject;

	public var camDisplaceX:Float = 0;
	public var camDisplaceY:Float = 0; // might not use depending on result

	public static var cameraSpeed:Float = 1;
	public static var defaultCamZoom:Float = 1.05;
	public static var forceZoom:Array<Float>;

	public static var cameraBumpSpeed:Float = 4;

	// User Interface and Objects (Toggleable)
	public static var uiHUD:ClassHUD; // default HUD
	public static var psychHUD:PsychHUD;
	public static var vanillaHUD:VanillaHUD;
	public static var kadeHUD:KadeHUD;
	public static var demolitionHUD:DemolitionHUD;

	// Hardcoded HUDs
	public static var cycledSinsHUD:CycledSinsHUD;
	public static var episode1HUD:Episode1HUD;
	
	public static var songCard:SongCard;

	public static var daPixelZoom:Float = 6;

	public static var stageBuild:Stage;

	public static var stageMap:Map<String, Stage> = new Map();

	public static var ratingPlacement:FlxPoint;
	public static var comboPlacement:FlxPoint;

	// strumlines
	public static var dadStrums:Strumline;
	public static var bfStrums:Strumline;

	public static var strumLines:FlxTypedGroup<Strumline>;
	public static var strumHUD:Array<FlxCamera> = [];

	// stores all UI Cameras in an array
	private var allUIs:Array<FlxCamera> = [];

	// Other;
	public static var lastRating:FlxSprite;
	public static var lastTiming:FlxSprite;
	public static var lastCombo:Array<FlxSprite>;

	// groups, used to sort through ratings and combo;
	public var judgementsGroup:FlxTypedGroup<FNFSprite>;
	public var comboGroup:FlxTypedGroup<FNFSprite>;

	public var gfSpeed:Int = 1;

	public var scratch:FlxSprite; // Peter Griffin: This reminds me of the time I met the Scratch cat
	public var scratchButLessVisible:FlxSprite;

	// troll
	private var isDebugMode:Bool = false;
	
	// Malfunction Gimmick
	var crashLives:FlxText;
	var crashLivesIcon:FlxSprite;
	public var crashLivesCounter:Int = 0;

	var heartTween:FlxTween;
	var malfunctionTxt:FlxTween;

	// Mercy Gimmick
	var waltScreenThing:FlxSprite; // idk, this is needed too for some reason
	var inkFormWarning:FlxText;
	var spaceBarCounter:FlxText;
	var limitThing:Int = 0; // Default Value
	
	// Stage BG Flash Stuff
	var stageBGFlash:FlxSprite;
	var BGFlashTween:FlxTween;

	var fade:FlxSprite;

	function loadWindowTitleData()
	{
		switch (gameplayMode)
		{
				case STORY:
					switch (SONG.song)
					{
						case 'Isolated' | 'Lunacy' | 'Delusional':
							Application.current.window.title = 'Funkin.avi - Episode 1: ' + SONG.song + " - Composed by: " + SONG.composer + " - [" + CoolUtil.difficultyString + "]";
						
						case 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus':
							Application.current.window.title = 'Funkin.avi - Episode S: ' + SONG.song + " - Composed by: " + SONG.composer + " - [" + CoolUtil.difficultyString + "]";
				
						case 'Mercy' | 'Affliction':
							Application.current.window.title = 'Funkin.avi - Episode W: ' + SONG.song + " - Composed by: " + SONG.composer + " - [" + CoolUtil.difficultyString + "]";
				
						default:
							Application.current.window.title = 'Funkin.avi - Episode ???: ' + SONG.song + " - Composed by: " + SONG.composer + " - [" + CoolUtil.difficultyString + "]";
					}
					
				case FREEPLAY:
					Application.current.window.title = 'Funkin.avi - Freeplay: ' + SONG.song + " - Composed by: " + SONG.composer + " - [" + CoolUtil.difficultyString + "]";
				
				case CHARTING:
					if (SONG.song == 'Malfunction')
						Application.current.window.title = 'glitchedMickey.xml - CHEATER MODE ACTIVATED: ' + SONG.song + " - Composed by: I CAN SEE YOU CHEATING! - [!CHEATER DETECTED!]";
					else
						Application.current.window.title = 'Funkin.avi - TESTING MODE: ' + SONG.song + " - Composed by: " + SONG.composer + " - [" + CoolUtil.difficultyString + "]";
		}
	}

	/**
	 * Loads all RPC's icons
	 */
	function loadRPCIcon()
	{
		#if DevBuild
			iconRPC = 'icon';
		#else
			iconRPC = CoolUtil.spaceToDash(SONG.song.toLowerCase()); // basically, it'll now look for the icon in the RPC via song name, if it doesn't it'll just return with no icon
		#end
	}

	/**
	 * Sets the Freeplay songs data
	 */
	function setFreeplayData()
	{
		switch (SONG.song.toLowerCase())
		{
			case 'hunted':
				if (FlxG.save.data.huntedLock != 'beaten')
					GameData.huntedLock = 'unlocked';
			case 'isolated old':
				if (FlxG.save.data.oldisolateLock != 'beaten')
					GameData.oldisolateLock = 'unlocked';
			case 'isolated beta':
				if (FlxG.save.data.betaisolateLock != 'beaten')
					GameData.betaisolateLock = 'unlocked';
			case 'neglection':
				if (FlxG.save.data.pnmLock != 'beaten')
					GameData.pnmLock = 'unlocked';
			case "don't cross!":
				if (FlxG.save.data.crossinLock != 'beaten')
					GameData.crossinLock = 'unlocked';
			case 'war dilemma':
				if (FlxG.save.data.warLock != 'beaten')
					GameData.warLock = 'unlocked';
			case 'cycled sins':
				if (FlxG.save.data.sinsLock != 'beaten')
					GameData.sinsLock = 'unlocked';
			case 'malfunction':
				if (FlxG.save.data.malfunctionLock != 'beaten')
					GameData.malfunctionLock = 'unlocked';
			case 'scrapped':
				if (FlxG.save.data.scrappedLock != 'beaten')
					GameData.scrappedLock = 'unlocked';
			case 'bless':
				if (FlxG.save.data.blessLock != 'beaten')
					GameData.blessLock = 'unlocked';
			case 'laugh track':
				if (FlxG.save.data.rickyLock != 'beaten')
					GameData.rickyLock = 'unlocked';
			case 'birthday':
				if (FlxG.save.data.muckneyLock != "completed")
					GameData.muckneyLock = "voidIsOpen";
			case 'mercy legacy':
				if (FlxG.save.data.legacyWLock != 'beaten')
					GameData.legacyWLock = 'unlocked';
			case 'isolated legacy':
				if (FlxG.save.data.legacyILock != 'beaten')
					GameData.legacyILock = 'unlocked';
			case 'lunacy legacy':
				if (FlxG.save.data.legacyLLock != 'beaten')
					GameData.legacyLLock = 'unlocked';
			case 'delusional legacy':
				if (FlxG.save.data.legacyDLock != 'beaten')
					GameData.legacyDLock = 'unlocked';
			case 'hunted legacy':
				if (FlxG.save.data.legacyHLock != 'beaten')
					GameData.legacyHLock = 'unlocked';
			case 'malfunction legacy':
				if (FlxG.save.data.legacyMLock != 'beaten')
					GameData.legacyMLock = 'unlocked';
		}
		GameData.saveShit();
	}

	/**
	 * Sets data when you complete a song
	 */
	function completeFPSong()
	{
		switch (SONG.song.toLowerCase())
		{
			case 'hunted':
				GameData.huntedLock = 'beaten';
			case 'isolated old':
				GameData.oldisolateLock = 'beaten';
			case 'isolated beta':
				GameData.betaisolateLock = 'beaten';
			case 'neglection':
				GameData.pnmLock = 'beaten';
			case "don't cross!":
				GameData.crossinLock = 'beaten';
			case 'war dilemma':
				GameData.warLock = 'beaten';
			case 'cycled sins':
				GameData.sinsLock = 'beaten';
			case 'malfunction':
				GameData.malfunctionLock = 'beaten';
			case 'scrapped':
				GameData.scrappedLock = 'beaten';
			case 'bless':
				GameData.blessLock = 'beaten';
			case 'laugh track':
				GameData.rickyLock = 'beaten';
			case 'birthday':
				GameData.muckneyLock = "completed";
			case 'mercy legacy':
				GameData.legacyWLock = 'beaten';
			case 'isolated legacy':
				GameData.legacyILock = 'beaten';
			case 'lunacy legacy':
				GameData.legacyLLock = 'beaten';
			case 'delusional legacy':
				GameData.legacyDLock = 'beaten';
			case 'hunted legacy':
				GameData.legacyHLock = 'beaten';
			case 'malfunction legacy':
				GameData.legacyMLock = 'beaten';
		}
		GameData.saveShit();
	}

	/**
	 * Checks if you completed a episode, if true, unlocks freeplay songs and more content
	 */
	function completeEpisode()
	{
		switch (SONG.song.toLowerCase())
		{
			case 'delusional':
				GameData.episode1FPLock = 'unlocked';
			case 'mortiferum risus':
				GameData.episodeSFPLock = 'unlocked';
			case 'affliction':
				GameData.episodeWFPLock = 'unlocked';
		}
		GameData.saveShit();
	}

	function resetStatics()
	{
		GameOverSubstate.resetDeathVariables();
		Events.getScriptEvents();

		ScoreUtils.resetAccuracy();
		PlayState.SONG.validScore = true;
		deaths = 0;
		health = 0.5;

		timedEvents = [];
		moduleArray = [];
		lastCombo = [];

		clearStored = false;
		Conductor.shouldStartSong = false;
		defaultCamZoom = 1.05;
		cameraBumpSpeed = 4;
		cameraSpeed = 1;

		forceZoom = [0, 0, 0, 0];

		assetModifier = 'base';
		changeableSkin = 'default';
	}

	inline function checkTween(isDad:Bool = false):Bool
	{
		if (isDad && Init.trueSettings.get('Centered Notefield'))
			return false;
		if (skipCountdown)
			return false;
		return true;
	}

	public function generateCharacters()
	{
		opponent = new Character();
		boyfriend = new Boyfriend();
		gf = new Character();

		gf.setCharacter(0, 0, SONG.gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		opponent.setCharacter(0, 0, SONG.player2);
		boyfriend.setCharacter(0, 0, SONG.player1);

		// add characters
		if (stageBuild.spawnGirlfriend)
			add(gf);

		add(stageBuild.layers);
		
		stageBGFlash = new FlxSprite(-800, -200).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFFFFFFFF);
		stageBGFlash.alpha = 0.0001; // it's at this value so the game doesn't lag when it becomes visible
		add(stageBGFlash);

		if (curStage == 'fuckingLine')
		{
			add(boyfriend);
			add(opponent);
		}
		else
		{
			add(opponent);
			add(boyfriend);
		}

		if (curStage == 'staticVoid')
			opponent.alpha = 0.001;

		if (stageBuild.hideBoyfriend)
			boyfriend.alpha = 0.001;

		add(stageBuild.foreground);

		// force them to dance
		opponent.dance();
		gf.dance();
		boyfriend.dance();
		
		opponent.antialiasing = !opponent.curCharacter.endsWith('-pixel');
		gf.antialiasing = !gf.curCharacter.endsWith('-pixel');
		boyfriend.antialiasing = !boyfriend.curCharacter.endsWith('-pixel');

		repositionChars();
	}

	public function regenerateCharacters()
	{
		remove(gf);
		remove(opponent);
		remove(boyfriend);
		remove(stageBuild.layers);
		remove(stageBuild.foreground);

		// add characters
		if (stageBuild.spawnGirlfriend)
			add(gf);

		add(stageBuild.layers);
		
		stageBGFlash = new FlxSprite(-800, -200).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFFFFFFFF);
		stageBGFlash.alpha = 0.0001; // it's at this value so the game doesn't lag when it becomes visible
		add(stageBGFlash);

		add(opponent);
		add(boyfriend);

		add(stageBuild.foreground);

		// force them to dance
		opponent.dance();
		gf.dance();
		boyfriend.dance();
		
		opponent.antialiasing = !opponent.curCharacter.endsWith('-pixel');
		gf.antialiasing = !gf.curCharacter.endsWith('-pixel');
		boyfriend.antialiasing = !boyfriend.curCharacter.endsWith('-pixel');

		repositionChars();
	}

	public function repositionChars()
	{
		stageBuild.repositionPlayers(curStage, boyfriend, gf, opponent);
		stageBuild.dadPosition(curStage, boyfriend, gf, opponent, new FlxPoint(gf.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100));
	}

	// at the beginning of the playstate
	override public function create()
	{
		super.create();

		setFreeplayData();
		loadRPCIcon();
		loadWindowTitleData();

		FlxG.mouse.visible = false;

		main = this;

		// trace("Current Gameplay Mode: " + gameplayMode);

		// reset any values and variables that are static
		resetStatics();

		// stop any existing music tracks playing
		resetMusic();
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// create all the game cameras
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		dialogueHUD = new FlxCamera();
		camAlt = new FlxCamera();
		camScratch = new FlxCamera();
		camOther = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		dialogueHUD.bgColor.alpha = 0;
		camAlt.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		camScratch.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);

		// HUD Camera so HUD objects stay on screen
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.add(camScratch, false);
		allUIs.push(camHUD);

		// always draw new objects on the main camera
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		// default song
		if (SONG == null)
			SONG = Song.loadFromJson('test', 'test');

		curStage = "";
		if (SONG.stage != null)
			curStage = SONG.stage;

		ScriptHandler.callScripts(moduleArray);

		ratingPlacement = new FlxPoint().set();
		comboPlacement = new FlxPoint().set();

		stageBuild = new Stage(curStage);
		add(stageBuild);

		if (SONG.gfVersion == null || SONG.gfVersion.length < 1)
			SONG.gfVersion = 'gf';

		// set up characters
		generateCharacters();

		if (SONG.assetModifier != null && SONG.assetModifier.length > 1)
			assetModifier = SONG.assetModifier;
		changeableSkin = Init.trueSettings.get("UI Skin");

		// set song position before beginning
		Conductor.songPosition = -(Conductor.crochet * 4);

		// EVERYTHING SHOULD GO UNDER THIS, IF YOU PLAN ON SPAWNING SOMETHING LATER ADD IT TO STAGEBUILD OR FOREGROUND
		// darken everything but the arrows and ui via a flxsprite
		var darknessBG:FlxSprite = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		darknessBG.alpha = (100 - Init.trueSettings.get('Stage Opacity')) / 100;
		darknessBG.scrollFactor.set(0, 0);
		add(darknessBG);

		// strum setup
		strumLines = new FlxTypedGroup<Strumline>();

		// generate the song
		generateSong(SONG.song);

		var camPos:FlxPoint = new FlxPoint(gf.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

		// set the camera position to the center of the stage
		camPos.set(gf.x + (gf.frameWidth / 2), gf.y + (gf.frameHeight / 2));

		// create the game camera
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(camPos.x, camPos.y);
		// check if the camera was following someone previously
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		add(camFollowPos);

		// actually set the camera up
		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		// initialize ui elements
		startingSong = true;
		startedCountdown = true;

		//
		var downscroll = Init.trueSettings.get('Downscroll');
		var centered = Init.trueSettings.get('Centered Notefield');

		var placement = (FlxG.width / 2);
		var height = (downscroll ? FlxG.height - 175 : 25);

		dadStrums = new Strumline(placement - (FlxG.width / 4), height, [opponent], downscroll, false, true, checkTween(true), false, 4);
		bfStrums = new Strumline(placement + (!centered ? (FlxG.width / 4) : 0), height, [boyfriend], downscroll, true, false, checkTween(false), true, 4);

		if (curStage == 'waltRoom')
			dadStrums.visible = false;
		else
			dadStrums.visible = !centered;

		strumLines.add(dadStrums);
		strumLines.add(bfStrums);

		// strumline camera setup
		strumHUD = [];

		grayScale = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/grayScale.frag'), null, 120);
		andromeda = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/andromedaShader.frag'), null, 140);
		tilt = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/tiltShift.frag'), null, 140);
		tilt.setFloat('bluramount', 0.1);
		andromeda.setFloat('glitchModifier', 0.6);
		andromeda.setBool('perspectiveOn', false);
		andromeda.setBool('vignetteMoving', true);
		andromeda.setFloat('iTime', 0);

		for (i in 0...strumLines.length)
		{
			// generate a new strum camera
			strumHUD[i] = new FlxCamera();
			strumHUD[i].bgColor.alpha = 0;

			strumHUD[i].cameras = [camHUD];
			allUIs.push(strumHUD[i]);
			FlxG.cameras.add(strumHUD[i], false);
			// set this strumline's camera to the designated camera
			switch (curStage)
			{
				case 'theLoop' | 'forestOld':
					strumLines.members[i].cameras = [camHUD];

				case 'abandonedStreet' | 'forestNew' | 'apartment' | 'smilesOffice' | 'clubhouse' | 'delusionalStreet':
					strumHUD[i].setFilters([new openfl.filters.ShaderFilter(grayScale)]);
					strumLines.members[i].cameras = [strumHUD[i]];

				default:
					strumLines.members[i].cameras = [strumHUD[i]];
					// nothing, you get no shaders lol
			}
		}
		add(strumLines);

		// add the dialogue UI
		FlxG.cameras.add(dialogueHUD, false);
		
		if (Init.trueSettings.get('Display Song Cards'))
		{
			songCard = new SongCard();
			add(songCard);
			songCard.cameras = [camAlt];
			if (gameplayMode == FREEPLAY)
			{
				songCard.playCardAnim(0.08);
			}
			else if (gameplayMode == STORY)
			{
				switch (SONG.song)
				{
					case 'Isolated' | 'Lunacy' | 'Delusional':
						// do nothing, it's already set under stepHit()
					default:
						songCard.playCardAnim(0.08);
				}
			}
		}

		uiHUD = new ClassHUD();
		uiHUD.alpha = 0;
		add(uiHUD);
		uiHUD.cameras = [camHUD];

		psychHUD = new PsychHUD();
		psychHUD.alpha = 0;
		add(psychHUD);
		psychHUD.cameras = [camHUD];

		demolitionHUD = new DemolitionHUD();
		demolitionHUD.alpha = 0;
		add(demolitionHUD);
		demolitionHUD.cameras = [camHUD];

		vanillaHUD = new VanillaHUD();
		vanillaHUD.alpha = 0;
		add(vanillaHUD);
		vanillaHUD.cameras = [camHUD];

		kadeHUD = new KadeHUD();
		kadeHUD.alpha = 0;
		add(kadeHUD);
		kadeHUD.cameras = [camHUD];

		cycledSinsHUD = new CycledSinsHUD();
		cycledSinsHUD.alpha = 0;
		add(cycledSinsHUD);
		cycledSinsHUD.cameras = [camHUD];

		episode1HUD = new Episode1HUD();
		episode1HUD.alpha = 0;
		add(episode1HUD);
		episode1HUD.cameras = [camHUD];

		if (Init.trueSettings.get('Judgement Recycling'))
		{
			judgementsGroup = new FlxTypedGroup<FNFSprite>();
			comboGroup = new FlxTypedGroup<FNFSprite>();
			add(judgementsGroup);
			add(comboGroup);
		}

		// add the alternative camera (goes above every other)
		FlxG.cameras.add(camAlt, false);

		//
		if (stageBuild.sendMessage)
		{
			if (stageBuild.messageText.length > 1)
				logTrace(stageBuild.messageText, 3, true);
		}
		Controls.keyEventTrigger.add(keyEventTrigger);

		callFunc('postCreate', []);

		Paths.clearUnusedMemory();

		if(downscroll)
		{
			crashLives = new FlxText(600, 170, 0, "", 20);
			crashLivesIcon = new FlxSprite(550, 170);
		}else{
			crashLives = new FlxText(600, 500, 0, "", 20);
			crashLivesIcon = new FlxSprite(550, 500);
		}	

		crashLives.setFormat(Paths.font("Retro Gaming"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		crashLives.borderSize = 2;
		crashLives.borderQuality = 2;
		crashLives.antialiasing = false;
		crashLives.scrollFactor.set();
		crashLives.cameras = [camHUD];

		crashLivesIcon.frames = Paths.getSparrowAtlas('UI/gimmicks/malfunctionGimmickIcon');
		crashLivesIcon.animation.addByPrefix('idle', 'lives-icon idle', 15);
		crashLivesIcon.animation.addByPrefix('OMFG IT GLITCHES', 'lives-icon glitchin', 15);
		crashLivesIcon.animation.play('idle');
		crashLivesIcon.scale.set(2.2, 2.2);
		crashLivesIcon.antialiasing = false;
		crashLivesIcon.cameras = [camHUD];

		if(!Init.trueSettings.get('Low Quality'))
			{
				scratchButLessVisible = new FlxSprite();
				scratchButLessVisible.frames = Paths.getSparrowAtlas('filters/scratchShit');
				scratchButLessVisible.animation.addByPrefix('e', 'scratch thing', 24, true);
				scratchButLessVisible.animation.play('e');
				scratchButLessVisible.cameras = [camScratch];
				scratchButLessVisible.alpha = 0.5;
				add(scratchButLessVisible);
		
				scratch = new FlxSprite();
				scratch.frames = Paths.getSparrowAtlas('filters/scratchShit');
				scratch.animation.addByPrefix('e', 'scratch thing', 24, true);
				scratch.animation.play('e');
				scratch.cameras = [camScratch];
				add(scratch);
			}

		fade = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, 0x000000);
		fade.screenCenter();
		fade.cameras = [camHUD];
		fade.alpha = 0;
		add(fade);

		waltScreenThing = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
		waltScreenThing.scrollFactor.set();
		waltScreenThing.cameras = [camAlt];
		waltScreenThing.alpha = 0;
		
		var waltInstructionsMain:FlxText = new FlxText(370, 500, 0, "Take Advantage of the SPACEBAR!", 30);
		waltInstructionsMain.cameras = [camAlt];
		waltInstructionsMain.setFormat(Paths.font("splatter"), 30);
		waltInstructionsMain.scrollFactor.set();

		var waltSubTxt:FlxText = new FlxText(waltInstructionsMain.x + 66, waltInstructionsMain.y + 40, 0, "(It will help you regain health when critically low)", 15);
		waltSubTxt.setFormat(Paths.font("splatter"), 15);
		waltSubTxt.cameras = [camAlt];
		waltSubTxt.alpha = 0;
		waltSubTxt.scrollFactor.set();

		inkFormWarning = new FlxText(0, 0, 0, "PRESS SPACE!", 15);
		inkFormWarning.setFormat(Paths.font("splatter"), 50);
		inkFormWarning.cameras = [camAlt];
		inkFormWarning.alpha = 0;
		inkFormWarning.scrollFactor.set();
		inkFormWarning.screenCenter();

		spaceBarCounter = new FlxText(0, 680, 0, 'Health Boosts Left: ' + limitThing, 15);
		spaceBarCounter.setFormat(Paths.font("splatter"), 30);
		spaceBarCounter.cameras = [camAlt];
		spaceBarCounter.alpha = 0;
		spaceBarCounter.scrollFactor.set();
			
		// Cleaner Initialization for the mechanics and note visibility stuff
		switch (SONG.song)
		{
			case 'Isolated' | 'Lunacy':
				for (i in strumHUD)
				{
					i.alpha = 0;
				}
				camGame.alpha = 0;
				camHUD.alpha = 0;
				
			case 'Mercy Legacy': 
				if (!Init.trueSettings.get('Disable Mechanics'))
					limitThing += 25;
				
			case 'Mercy':
				if (!Init.trueSettings.get('Disable Mechanics'))
					limitThing += 20;
				
			// Glitched Mickey will give you a big fat middle finger for disabling the mechanics lmao
			case 'Malfunction Legacy': crashLivesCounter += 30;
			case 'Malfunction':
				for (i in strumHUD)
					{
						i.alpha = 0;
					}
					camGame.alpha = 0;
					camHUD.alpha = 0;
				crashLivesCounter += 45;
		}

		switch (curStage)
		{
			case 'forbiddenRealm':
				FlxTween.tween(crashLives, {alpha: 0.3}, 2, {ease: FlxEase.quartInOut, startDelay: 5});
				FlxTween.tween(crashLivesIcon, {alpha: 0.3}, 2, {ease: FlxEase.quartInOut, startDelay: 5});
				add(crashLives);
				add(crashLivesIcon);
			
			case 'waltRoom':
				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					add(waltScreenThing);
					add(waltInstructionsMain);
					add(waltSubTxt);
					add(inkFormWarning);
					add(spaceBarCounter);

					FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
					FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
					FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});
				}
				strumLines.members[0].visible = false;
				bfStrums.receptors.members[0].x = 40;
				bfStrums.receptors.members[1].x = 320;
				bfStrums.receptors.members[2].x = 800;
				bfStrums.receptors.members[3].x = 1090;
			
			case 'staticVoid':
				strumLines.members[0].visible = false;
				bfStrums.receptors.members[0].x = 40;
				bfStrums.receptors.members[1].x = 320;
				bfStrums.receptors.members[2].x = 800;
				bfStrums.receptors.members[3].x = 1090;
				
		}

		// call the funny intro cutscene depending on the song
		songCutscene(false);
	}

	var keysHeld:Array<Bool> = [];

	/*
	 * Main Input System Function
	**/
	public function inputHandler(key:Int, state:KeyState)
	{
		keysHeld[key] = (state == PRESSED);

		if (state == PRESSED)
		{
			if (generatedMusic)
			{
				var previousTime:Float = Conductor.songPosition;
				if (SONG.instType == "Legacy" || SONG.instType == null)
					Conductor.songPosition = songMusic.time;
				
				if (SONG.instType == "New")
					Conductor.songPosition = songMusicNew.time;
				// improved this a little bit, maybe its a lil
				var possibleNoteList:Array<Note> = [];
				var pressedNotes:Array<Note> = [];

				bfStrums.allNotes.forEachAlive(function(daNote:Note)
				{
					if ((daNote.noteData == key) && daNote.canBeHit && !daNote.isSustainNote && !daNote.tooLate && !daNote.wasGoodHit)
						possibleNoteList.push(daNote);
				});
				possibleNoteList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				// if there is a list of notes that exists for that control
				if (possibleNoteList.length > 0)
				{
					var eligable = true;
					var firstNote = true;
					// loop through the possible notes
					for (coolNote in possibleNoteList)
					{
						for (noteDouble in pressedNotes)
						{
							if (Math.abs(noteDouble.strumTime - coolNote.strumTime) < 10)
								firstNote = false;
							else
								eligable = false;
						}

						if (eligable)
						{
							goodNoteHit(coolNote, bfStrums); // then hit the note
							pressedNotes.push(coolNote);
						}
						// end of this little check
					}
					//
				}
				else // else just call bad notes
					if (!Init.trueSettings.get('Ghost Tapping'))
					{
						if (!inCutscene && !endingSong)
							missNoteCheck(true, key, bfStrums, Init.trueSettings.get("Display Miss Judgement"));
					}
				Conductor.songPosition = previousTime;
			}

			if (bfStrums.receptors.members[key] != null && bfStrums.receptors.members[key].animation.curAnim.name != 'confirm')
				bfStrums.receptors.members[key].playAnim('pressed');
		}
		else
		{
			// receptor reset
			if (key >= 0 && bfStrums.receptors.members[key] != null)
				bfStrums.receptors.members[key].playAnim('static');
		}
	}

	public function keyEventTrigger(action:String, key:Int, state:KeyState)
	{
		if (paused || inCutscene || bfStrums.autoplay)
			return;

		switch (action)
		{
			// RESET = Quick Game Over Screen
			case "reset":
				if (!startingSong && gameplayMode != STORY)
					health = 0;
			case "left" | "down" | "up" | "right":
				var actions = ["left", "down", "up", "right"];
				var index = actions.indexOf(action);
				inputHandler(index, state);
		}
		callFunc(state == PRESSED ? 'onKeyPress' : 'onKeyRelease', [action]);
	}

	override public function destroy()
	{
		Controls.keyEventTrigger.remove(keyEventTrigger);
		super.destroy();
	}
				
	inline static function get_songSpeed()
		return FlxMath.roundDecimal(songSpeed, 2);

	inline static function set_songSpeed(value:Float):Float
	{
		var offset:Float = songSpeed / value;
		for (note in bfStrums.allNotes)
		{
			if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
			{
				note.scale.y *= offset;
				note.updateHitbox();
			}
		}
		for (note in dadStrums.allNotes)
		{
			if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
			{
				note.scale.y *= offset;
				note.updateHitbox();
			}
		}

		return cast songSpeed = value;
	}

	public function updateSectionCamera(value:String, isPlayer:Bool = false)
	{
		var char = opponent;

		if (value == "center")
			return;

		switch (value)
		{
			case 'bf':
				char = boyfriend;
			case 'dad':
				char = opponent;
			case 'gf':
				char = gf;
		}

		var getCenterX = isPlayer ? char.getMidpoint().x - 100 : char.getMidpoint().x + 100;
		var getCenterY = char.getMidpoint().y - 100;

		if (isPlayer)
		{
			switch (curStage)
			{
				case 'limo':
					getCenterX = char.getMidpoint().x - 300;
				case 'mall':
					getCenterY = char.getMidpoint().y - 200;
				case 'school':
					getCenterX = char.getMidpoint().x - 200;
					getCenterY = char.getMidpoint().y - 200;
				case 'schoolEvil':
					getCenterX = char.getMidpoint().x - 200;
					getCenterY = char.getMidpoint().y - 200;
			}
		}else{
			switch (curStage)
			{
				case 'apartment':
					if (shootin)
					{
						getCenterX = char.getMidpoint().x - 300;
						getCenterY = char.getMidpoint().y + 150;
					}else{
						getCenterX = char.getMidpoint().x + 100;
						getCenterY = char.getMidpoint().y - 100;
					}
			}
		}

		camFollow.setPosition(getCenterX
			+ camDisplaceX
			+ char.characterData.camOffsets[0], getCenterY
			+ camDisplaceY
			+ char.characterData.camOffsets[1]);

		if (char.curCharacter == 'mom')
		{
			vocals.volume = 1;
			opp_vocals.volume = 1;
		}
	}
	
	/**
	* The better and simplified Walt gimmick
	*
	* @author Wither362
	*/
	function tweenWaltScreen(percentage:Float, alpha:Float):Bool {
		if (health <= percentage)
			FlxTween.tween(waltScreenThing, {alpha: alpha}, 0.15, {ease: FlxEase.sineInOut});
		else
			return true;
		return false;
	}
	
	function checkCamPosition()
	{
		/*
		* Originally in "public function update(elapsed:Float)"
		* was moved here as a separate function so certain
		* mechanics can alter the camera too, for example:
		* Cycled Sins with the shooting and dodging gimmick.
		*
		* -DEMOLITIONDON96
		*/
		
		var cameraPos = Init.trueSettings.get('Camera Position');
		if (cameraPos != 'none')
		{
			// lock camera according to your options;
			updateSectionCamera(cameraPos, cameraPos == SONG.player1);
		}
		else
		{
			if (!PlayState.SONG.notes[curSection].mustHitSection)
				updateSectionCamera('dad');
			else
				updateSectionCamera('bf', true);
		}
	}

	override public function update(elapsed:Float)
	{
		callFunc('update', [elapsed]);

		stageBuild.stageUpdateConstant(elapsed, boyfriend, gf, opponent);

		super.update(elapsed);

		if(FlxG.keys.justPressed.F5)
			isDebugMode = true;

		if(FlxG.keys.justPressed.SPACE && isDebugMode)
			{
				try {
				health = 2;
				endSong();
				} catch(e) {
					trace('fail!!!');
				}
			}
		
		if (!Init.trueSettings.get('Disable Mechanics'))
			detectSpace(bfStrums.autoplay); // checks on the autoplay to determine whether or not it would play the mechanics for you

		if (curStage == 'forbiddenRealm')
			crashLives.text = 'Lives: ${crashLivesCounter}';

		if (curStage == 'waltRoom')
		{
			if (!Init.trueSettings.get('Disable Mechanics'))
			{
				spaceBarCounter.text = 'Health Boosts Left: ' + limitThing;
				spaceBarCounter.alpha = 1;

				/*
				* This set monitors the brightness of the screen based on the percentage of your health
				* The original code was unoptimized asf, you can go see for yourself through the commit
				* history, thx @Wither362 for the more simplified code!
				*
				* -DEMOLITIONDON96
				*/

				var healths:Array<Float> = [for (i in 1...21) i / 10]; // i dont really remember how were this done...
				var alphas:Array<Float> = [
					0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.55, 0.50, 0.45, 0.40, 0.35, 0.30, 0.25, 0.20, 0.15, 0.10, 0.05, 0.0
				];
				var lastOne:Bool = true;
				for(i in 0...healths.length) {
					if(lastOne) {
						lastOne = tweenWaltScreen(healths[i], alphas[i]);
					}
				}
			}
		}

		if (health > 2)
			health = 2;

		// dialogue checks
		if (dialogueBox != null && dialogueBox.alive)
		{
			// wheee the shift closes the dialogue
			if (Controls.getPressEvent("skip"))
				dialogueBox.closeDialog();

			// the change I made was just so that it would only take accept inputs
			if (Controls.getPressEvent("accept") && dialogueBox.textStarted)
			{
				FlxG.sound.play(openfl.media.Sound.fromFile(dialogueBox.acceptPath + dialogueBox.portraitData.acceptSound + "." + Paths.SOUND_EXT));
				dialogueBox.curPage += 1;
				if (dialogueBox.curPage == dialogueBox.dialogueData.dialogue.length)
					dialogueBox.closeDialog()
				else
					dialogueBox.updateDialog();
			}
		}

		if (!inCutscene)
		{
			if (startedCountdown)
			{
				// pause the game if the game is allowed to pause and enter is pressed
				if (Controls.getPressEvent("pause") && canPause)
					pauseGame();

				if (gameplayMode != STORY)
				{
					if (Controls.getPressEvent("autoplay"))
					{
						PlayState.SONG.validScore = false;
						bfStrums.autoplay = !bfStrums.autoplay;
						switch(SONG.song.toLowerCase().replace('-', ' '))
						{
							case 'cycled sins':
								//cycledSinsHUD.autoplayMark.visible = bfStrums.autoplay;
								//cycledSinsHUD.scoreBar.visible = !bfStrums.autoplay;
							case 'Isolated' | 'Lunacy' | 'Delusional':
								//episode1HUD.autoplayMark.visible = bfStrums.autoplay;
								//episode1HUD.scoreBar.visible = !bfStrums.autoplay;
							default:
								checkAutoplayText();
						}
					}

					if (FlxG.keys.justPressed.SEVEN)
					{
						resetMusic();
						Main.switchState(this, new states.editors.OriginalChartingState());
					}

					if (FlxG.keys.justPressed.EIGHT)
					{
						resetMusic();
						Main.switchState(this, new states.editors.CharacterOffsetEditor());
					}
				}
			}

			if (generatedMusic && PlayState.SONG.notes[curSection] != null)
			{
				var lastMustHit:Bool = PlayState.SONG.notes[Std.int(lastSection)].mustHitSection;
				if (PlayState.SONG.notes[curSection].mustHitSection != lastMustHit)
				{
					camDisplaceX = 0;
					camDisplaceY = 0;
				}

				if (!shootin) // just for safety so the game doesn't freak out
					checkCamPosition();
			}

			Conductor.songPosition += elapsed * 1000;

			if (Conductor.songPosition >= 0)
				Conductor.shouldStartSong = true;

			if (startingSong && startedCountdown && Conductor.shouldStartSong)
				startSong();

			if (!startingSong)
			{
				if (Conductor.songPosition >= Conductor.lastPosition)
					Conductor.lastPosition = Conductor.songPosition;
			}

			var lerpVal = (elapsed * 2.4) * cameraSpeed;
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

			ForeverTools.cameraBumpingZooms(FlxG.camera, defaultCamZoom, forceZoom);
			for (hud in allUIs)
				ForeverTools.cameraBumpingZooms(hud, 1, forceZoom);

			deathCheck();

			// spawn in the notes from the array
			notesGroup.callNotes(bfStrums, dadStrums, strumLines);

			noteCalls();
			parseEventColumn();
		}

		callFunc('postUpdate', [elapsed]);
	}

	private var isDead:Bool = false;

	inline private function deathCheck():Bool
	{
		if (health <= 0 && startedCountdown && !isDead)
		{
			paused = true;
			persistentUpdate = false;
			persistentDraw = false;

			resetMusic();

			deaths += 1;

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			FlxG.sound.play(Paths.sound('$assetModifier/' + GameOverSubstate.deathNoise));

			#if DISCORD_RPC
			#if DevBuild
			Discord.changePresence("- CLASSIFIED CONTENT -", detailsSub, iconRPC);
			#else
			Discord.changePresence("GAME OVER - " + songDetails, detailsSub, iconRPC);
			#end
			#end
			isDead = true;
			return true;
		}
		return false;
	}

	inline function noteCalls()
	{
		// reset strums
		for (strumline in strumLines)
		{
			for (receptor in strumline.receptors)
			{
				if (strumline.autoplay && receptor.animation.curAnim.name == 'confirm' && receptor.animation.curAnim.finished)
					receptor.playAnim('static', true);
			}
		}

		// if the song is generated
		if (generatedMusic && startedCountdown)
		{
			for (strumline in strumLines)
			{
				strumline.allNotes.forEachAlive(function(daNote:Note)
				{
					if (daNote != null)
					{
						notesGroup.noteCalls(daNote, strumline);

						// hell breaks loose here, we're using nested scripts!
						mainControls(daNote, strumline);

						// check where the note is and make sure it is either active or inactive
						if (daNote.y > FlxG.height)
						{
							daNote.active = false;
							daNote.visible = false;
						}
						else
						{
							daNote.visible = true;
							daNote.active = true;
						}

						if (!daNote.tooLate && daNote.strumTime < Conductor.songPosition - (ScoreUtils.msThreshold) && !daNote.wasGoodHit)
						{
							if ((!daNote.tooLate) && (daNote.mustPress))
							{
								if (!daNote.isSustainNote)
								{
									daNote.tooLate = true;
									for (note in daNote.childrenNotes)
										note.tooLate = true;
									daNote.noteMiss();

									// when the note is declared "late", stop this function if it's a mine;
									if (daNote.ignoreNote || daNote.isMine)
										return;

									if (vocals != null)
									        vocals.volume = 0;
										
									if (bf_vocals != null)
									        bf_vocals.volume = 0;
									
									missNoteCheck((Init.trueSettings.get('Ghost Tapping')) ? true : false, daNote.noteData, strumline,
										Init.trueSettings.get("Display Miss Judgement"));
								}
								else if (daNote.isSustainNote)
								{
									if (daNote.parentNote != null)
									{
										var parentNote = daNote.parentNote;
										if (!parentNote.tooLate)
										{
											var breakFromLate:Bool = false;
											for (note in parentNote.childrenNotes)
											{
												if (note.tooLate && !note.wasGoodHit)
													breakFromLate = true;
											}
											if (!breakFromLate)
											{
												missNoteCheck((Init.trueSettings.get('Ghost Tapping')) ? true : false, daNote.noteData, strumline,
													Init.trueSettings.get("Display Miss Judgement"));
												for (note in parentNote.childrenNotes)
													note.tooLate = true;
											}
											//
										}
									}
								}
							}
						}

						// if the note is off screen (above)
						if ((((!strumline.downscroll) && (daNote.y < -daNote.height))
							|| ((strumline.downscroll) && (daNote.y > (FlxG.height + daNote.height))))
							&& (daNote.tooLate || daNote.wasGoodHit))
						{
							strumline.removeNote(daNote);
							notesGroup.remove(daNote);
						}
					}
				});

				// unoptimised asf camera control based on strums
				strumCameraRoll(strumline.receptors, (strumline == bfStrums));
			}
		}

		// reset bf's animation
		for (boyfriend in bfStrums.characters)
		{
			if ((boyfriend != null && boyfriend.animation != null)
				&& (boyfriend.holdTimer > Conductor.stepCrochet * (4 / 1000) && (!keysHeld.contains(true) || bfStrums.autoplay)))
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					boyfriend.dance();
			}
		}
	}

	function goodNoteHit(coolNote:Note, strumline:Strumline)
	{
		if (!coolNote.wasGoodHit)
		{
			coolNote.wasGoodHit = true;
			
			if (vocals != null)
			        vocals.volume = 1;
			
			if (strumline == bfStrums)
			{
			        if (bf_vocals != null)
				        bf_vocals.volume = 1;
				
				switch (SONG.song)
				{
					case "Don't Cross!":
						boyfriend.x -= 1.2;
						boyfriend.y += 1.2;
						boyfriend.scale.x += 0.0012;
						boyfriend.scale.y += 0.0012;
				}
			}
			
			if (strumline == dadStrums)
			{
			        if (opp_vocals != null)
				        opp_vocals.volume = 1;
				
				switch (SONG.song)
				{
					case 'Lunacy':
						if (!Init.trueSettings.get('Disable Mechanics'))
						{
							if (opponent.curCharacter == 'lunamick-new')
							{
								if (health > 0.35)
									health -= 0.02;
							}
						}
					
					case 'Delusional':
						if (!Init.trueSettings.get('Disable Mechanics'))
						{
							if (opponent.curCharacter == 'lunamick-new')
							{
								if (health > 0.35)
									health -= 0.02;
							}
							else if (opponent.curCharacter == 'mick-delusional-new')
							{

								if (health > 0.1)
									health -= 0.035;
							}
						}
						
					case 'Laugh Track':
						if (Init.trueSettings.get('Screen Shake'))
						{
							camGame.shake(0.005, 0.07);
							camHUD.shake(0.010, 0.07);
							for (i in strumHUD)
								i.shake(0.010, 0.07);
						}
						
					case 'Malfunction':
						if (opponent.curCharacter == 'glitched-mickey-new-pixel')
						{
							if (health > 0.05)
									health -= 0.018;
							if (Init.trueSettings.get('Screen Shake'))
							{
								camGame.shake(0.008, 0.07);
								camHUD.shake(0.015, 0.07);
								for (i in strumHUD)
									i.shake(0.015, 0.07);
							}
							// shaders soon
						}
						else if (opponent.curCharacter == 'gm-tired-pixel')
						{
							if (health > 0.36)
								health -= 0.01;
							if (Init.trueSettings.get('Screen Shake'))
							{
								camGame.shake(0.004, 0.07);
								camHUD.shake(0.007, 0.07);
								for (i in strumHUD)
									i.shake(0.07, 0.07);
							}
						}
						
					case 'Malfunction Legacy': // the reason this gets a separate case is cause shader effects are gonna be different
						if (health > 0.05)
    							health -= 0.016;
						if (Init.trueSettings.get('Screen Shake'))
						{
							camGame.shake(0.008, 0.07);
							camHUD.shake(0.015, 0.07);
							for (i in strumHUD)
								i.shake(0.015, 0.07);
						}
						// shaders soon
						
					case "Don't Cross!":
						boyfriend.x += 1.2;
					        boyfriend.y -= 1.2;
					        boyfriend.scale.x -= 0.0012;
					        boyfriend.scale.y -= 0.0012;

						if (!Init.trueSettings.get('Disable Mechanics'))
						{
							if(health > 0.05) // trol
								health -= 0.035;
						}
				}
			}

			callFunc(coolNote.mustPress ? 'goodNoteHit' : 'opponentNoteHit', [coolNote, strumline]);

			var receptors = strumline.receptors.members[coolNote.noteData];
			if (receptors != null)
				receptors.playAnim('confirm', true);

			coolNote.noteHit();

			for (character in strumline.characters)
			{
				// reset color if it's not white;
				if (character.color != 0xFFFFFFFF)
					character.color = 0xFFFFFFFF;
				if (!coolNote.noAnim)
					characterPlayAnimation(coolNote, character);
			}

			// special thanks to sam, they gave me the original system which kinda inspired my idea for this new one
			if (strumline.displayJudges)
			{
				// get the note ms timing
				var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);
				// get the timing
				var isLate:Bool = coolNote.strumTime < Conductor.songPosition ? true : false;

				// loop through all avaliable judgements
				var foundRating:Int = 4;
				var lowestThreshold:Float = Math.POSITIVE_INFINITY;

				for (myRating in 0...ScoreUtils.judges.length)
				{
					var myThreshold:Float = ScoreUtils.judges[myRating].timing;
					if (noteDiff <= myThreshold && (myThreshold < lowestThreshold))
					{
						foundRating = myRating;
						lowestThreshold = myThreshold;
					}
				}

				if (!coolNote.ignoreNote)
				{
					if (coolNote.isMine)
						ScoreUtils.minesHit++;
					else if (!coolNote.isSustainNote)
					{
						increaseCombo(foundRating, coolNote.noteData, strumline);
						popUpScore(foundRating, isLate, strumline, coolNote);
						if (coolNote.childrenNotes.length > 0)
							ScoreUtils.notesHit++;
						healthCall(ScoreUtils.judges[foundRating].health);
					}
					else if (coolNote.parentNote != null)
					{
						// call updated accuracy stuffs
						if (coolNote.parentNote != null)
						{
							ScoreUtils.updateInfo(100, true, coolNote.parentNote.childrenNotes.length);
							healthCall(100 / coolNote.parentNote.childrenNotes.length);
						}
					}
				}

				// create note splash if you hit a "sick" note;
				if (!coolNote.isSustainNote && coolNote.mustPress && foundRating == 0 || coolNote.noteSplash)
					createSplash(coolNote.noteType, coolNote.noteData, strumline);
			}

			if (!coolNote.isSustainNote)
			{
				strumline.removeNote(coolNote);
				notesGroup.remove(coolNote);
			}
		}
	}

	public function missNoteCheck(?includeAnimation:Bool = false, direction:Int = 0, strumline:Strumline, popMiss:Bool = false, lockMiss:Bool = false)
	{
		if (strumline.autoplay)
			return;

		if (includeAnimation)
		{
			var stringDirection:String = Receptor.actions[direction];

			FlxG.sound.play(Paths.soundRandom('$assetModifier/miss', 'sounds', 1, 3), FlxG.random.float(0.1, 0.2));

			for (character in strumline.characters)
			{
				var missString:String = '';
				if (character.hasMissAnims)
					missString = 'miss';

				character.playAnim('sing' + stringDirection.toUpperCase() + missString, lockMiss);

				// fake misses;
				var missColor = character.characterData.missColor;
				if (missString == null || missString == '')
					character.color = FlxColor.fromRGB(Std.int(missColor[0]), Std.int(missColor[1]), Std.int(missColor[2])); // *sad spongebob image* bwoomp.
			}
		}
		decreaseCombo(popMiss);
	}

	function characterPlayAnimation(coolNote:Note, character:Character)
	{
		// alright so we determine which animation needs to play
		// get alt strings and stuffs
		var stringArrow:String = '';
		var altString:String = '';

		var baseString = 'sing' + Receptor.actions[coolNote.noteData].toUpperCase();

		if (((SONG.notes[curSection] != null) && (SONG.notes[curSection].altAnim)) && (character.animOffsets.exists(baseString + '-alt')))
		{
			if (altString != '-alt')
				altString = '-alt';
			else
				altString = '';
		}

		var noteSuffix:String = coolNote.noteSuffix != null && coolNote.noteSuffix != '' ? coolNote.noteSuffix : '';

		if (coolNote.noteString != null && coolNote.noteString != '')
			stringArrow = coolNote.noteString;
		else
			stringArrow = baseString + altString + noteSuffix;

		if (character != null)
		{
			if (character.animOffsets.exists(stringArrow))
				character.playAnim(stringArrow, true);
			if (coolNote.noteTimer > 0)
			{
				character.specialAnim = true;
				character.heyTimer = coolNote.noteTimer;
			}
			character.holdTimer = 0;
		}
	}

	private function mainControls(daNote:Note, strumline:Strumline):Void
	{
		var notesPressedAutoplay = [];

		// here I'll set up the autoplay functions
		if (strumline.autoplay)
		{
			// check if the note was a good hit
			if (daNote.strumTime <= Conductor.songPosition)
			{
				// kill the note, then remove it from the array
				if (strumline.displayJudges)
					notesPressedAutoplay.push(daNote);

				if (!daNote.isMine)
					goodNoteHit(daNote, strumline);
			}
		}

		if (!strumline.autoplay)
		{
			// check if anything is held
			if (keysHeld.contains(true))
			{
				// check notes that are alive
				strumline.allNotes.forEachAlive(function(coolNote:Note)
				{
					if ((coolNote.parentNote != null && coolNote.parentNote.wasGoodHit)
						&& coolNote.canBeHit
						&& coolNote.mustPress
						&& !coolNote.tooLate
						&& coolNote.isSustainNote
						&& keysHeld[coolNote.noteData])
						goodNoteHit(coolNote, strumline);
				});
			}
		}
	}

	private function strumCameraRoll(cStrum:FlxTypedSpriteGroup<Receptor>, mustHit:Bool)
	{
		if (!Init.trueSettings.get('No Camera Note Movement'))
		{
			var camDisplaceExtend:Float = 35;
			if (PlayState.SONG.notes[curSection] != null)
			{
				if ((PlayState.SONG.notes[curSection].mustHitSection && mustHit)
					|| (!PlayState.SONG.notes[curSection].mustHitSection && !mustHit))
				{
					camDisplaceX = 0;
					if (cStrum.members[0].animation.curAnim.name == 'confirm')
						camDisplaceX -= camDisplaceExtend;
					if (cStrum.members[3].animation.curAnim.name == 'confirm')
						camDisplaceX += camDisplaceExtend;

					camDisplaceY = 0;
					if (cStrum.members[1].animation.curAnim.name == 'confirm')
						camDisplaceY += camDisplaceExtend;
					if (cStrum.members[2].animation.curAnim.name == 'confirm')
						camDisplaceY -= camDisplaceExtend;
				}
			}
		}
		//
	}

	override public function onFocus():Void
	{
		if (!paused)
			updateRPC(false);
		callFunc('onFocus', []);
		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (canPause && !paused && !inCutscene && !bfStrums.autoplay && !Init.trueSettings.get('Auto Pause'))
			pauseGame();
		callFunc('onFocusLost', []);
		super.onFocusLost();
	}

	public function pauseGame()
	{
		// pause discord rpc
		updateRPC(true);

		// pause game
		paused = true;

		// update drawing stuffs
		persistentUpdate = false;
		persistentDraw = true;

		globalManagerPause();

		// open pause substate
		openSubState(new states.substates.PauseSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}

	public function globalManagerPause()
	{
		// stop all tweens and timers
		FlxTimer.globalManager.forEach(function(tmr:FlxTimer)
		{
			if (!tmr.finished)
				tmr.active = false;
		});

		FlxTween.globalManager.forEach(function(twn:FlxTween)
		{
			if (!twn.finished)
				twn.active = false;
		});
	}

	public static function updateRPC(pausedRPC:Bool)
	{
		#if DISCORD_RPC
		var displayRPC:String = (pausedRPC) ? detailsPausedText : songDetails;

		if (health > 0)
		{
			if (Conductor.songPosition > 0 && !pausedRPC)
				Discord.changePresence(displayRPC, detailsSub, iconRPC, true, songLength - Conductor.songPosition);
			else
				Discord.changePresence(displayRPC, detailsSub, iconRPC);
		}
		#end
	}

	private function increaseScore(ratingID:Int)
	{
		// set up the rating
		var ratingScore:Int = 50;
		ScoreUtils.updateInfo(Std.int(ScoreUtils.judges[ratingID].accuracy));
		ratingScore = ScoreUtils.judges[ratingID].score;
		ScoreUtils.score += ratingScore;
	}

	private function popUpScore(ratingID:Int, late:Bool, strumline:Strumline, coolNote:Note)
	{
		var gottenRating = strumline.autoplay ? 0 : ratingID;

		// if it isn't a sick, and you had a sick combo, then it becomes not sick :(
		if (gottenRating != 0 && ScoreUtils.perfectCombo)
			ScoreUtils.perfectCombo = false;

		displayScore(gottenRating, late);
	}

	public function createSplash(noteType:String, noteData:Int, strumline:Strumline):NoteSplash
	{
		if (Init.trueSettings.get("Splash Opacity") <= 0)
			return null;

		for (i in 0...strumLines.length) {
			if(curStage == "theLoop" || curStage == "forestOld")
				strumLines.members[i].splashNotes.cameras = [camHUD];
			else
				strumLines.members[i].splashNotes.cameras = [strumHUD[i]];
		}

		/*
			this might be a note hit memory leak, so it's good to check on this later
			@BeastlyGhost
		 */

		if (strumline.splashNotes != null)
		{
			var noteSplash:NoteSplash = ForeverAssets.generateNoteSplashes(strumline, assetModifier, changeableSkin, noteType, noteData);
			noteSplash.cameras = strumline.splashNotes.members[noteData].cameras;
			return noteSplash;
		}
		return null;
	}

	public function decreaseCombo(?popMiss:Bool = false)
	{
		// painful if statement
		if (ScoreUtils.combo > 5 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');

		ScoreUtils.decreaseCombo();
		healthCall(ScoreUtils.judges[4].health);

		// display negative combo
		if (popMiss)
			displayScore(4, true);
	}

	function increaseCombo(?baseRating:Int, ?direction = 0, ?strumline:Strumline)
	{
		// trolled this can actually decrease your combo if you get a bad/shit/miss
		if (baseRating != null)
		{
			if (ScoreUtils.judges[baseRating].accuracy > 0)
			{
				ScoreUtils.increaseCombo();
				increaseScore(baseRating);
			}
			else
				missNoteCheck(true, direction, strumline, false, Init.trueSettings.get("Display Miss Judgement"));
		}
	}

	// "Miss" Judgement Color;
	private var createdColor = FlxColor.fromRGB(204, 66, 66);

	public function displayScore(id:Int, late:Bool, ?preload:Bool = false)
	{
		//
		var rating:FNFSprite;

		rating = ForeverAssets.generateRating(id, judgementsGroup, assetModifier, changeableSkin, 'UI');
		rating.setPosition(rating.x + ratingPlacement.x, rating.y + ratingPlacement.y);

		if (rating != null)
		{
			if (!Init.trueSettings.get('Judgement Recycling'))
				insert(members.indexOf(strumLines), rating);

			if (Init.trueSettings.get("Simply Judgements"))
			{
				if (lastRating != null)
					lastRating.kill();
				lastRating = rating;
			}
			ForeverTools.tweenJudgement(rating);
		}

		if (!preload)
		{
			if (Init.trueSettings.get('Fixed Judgements'))
			{
				// bound to camera
				rating.cameras = [camHUD];
				rating.screenCenter();
			}

			var ratingName = ScoreUtils.judges[id].name;

			// return the actual rating to the array of judgements
			ScoreUtils.gottenJudgements.set(ratingName, ScoreUtils.gottenJudgements.get(ratingName) + 1);

			if (id > ScoreUtils.smallestRating)
				ScoreUtils.smallestRating = id;
		}
		else
			rating.alpha = 0.00001;

		if (Init.trueSettings.get("Display Timings"))
		{
			var timing:FNFSprite;

			timing = ForeverAssets.generateTimings(ScoreUtils.judges[id].name, late, rating, judgementsGroup, assetModifier, changeableSkin, 'UI');
			timing.setPosition(rating.x + ratingPlacement.x, rating.y + ratingPlacement.y + 50);

			if (!Init.trueSettings.get('Judgement Recycling'))
				if (id != 0 && id != 4 && Init.trueSettings.get("Display Timings"))
					insert(members.indexOf(strumLines), timing);

			if (Init.trueSettings.get('Fixed Judgements'))
			{
				// bound to camera
				timing.cameras = [camHUD];
				timing.screenCenter();
			}

			if (preload)
				timing.alpha = 0.00001;

			if (Init.trueSettings.get("Simply Judgements"))
			{
				if (lastTiming != null)
					lastTiming.kill();
				lastTiming = timing;
			}
			ForeverTools.tweenJudgement(timing);
		}

		// COMBO
		var comboString:String = Std.string(ScoreUtils.combo);
		var negative = false;
		if ((comboString.startsWith('-')) || (ScoreUtils.combo == 0))
			negative = true;
		var stringArray:Array<String> = comboString.split("");
		// deletes all combo sprites prior to initalizing new ones
		if (lastCombo != null)
		{
			while (lastCombo.length > 0)
			{
				lastCombo[0].kill();
				lastCombo.remove(lastCombo[0]);
			}
		}

		for (scoreInt in 0...stringArray.length)
		{
			// numScore.loadGraphic(Paths.image('UI/' + pixelModifier + 'num' + stringArray[scoreInt]));
			var numScore = ForeverAssets.generateCombo('combo', comboGroup, stringArray[scoreInt], (!negative ? ScoreUtils.perfectCombo : false),
				assetModifier, changeableSkin, 'UI', negative, createdColor, scoreInt);
			numScore.setPosition(numScore.x + comboPlacement.x, numScore.y + comboPlacement.y);
			if (!Init.trueSettings.get('Judgement Recycling'))
				insert(members.indexOf(strumLines), numScore);

			if (Init.trueSettings.get('Fixed Judgements'))
			{
				numScore.cameras = [camHUD];
				numScore.y += 50;
			}
			numScore.x += 100;

			if (preload)
				numScore.alpha = 0.00001;

			if (Init.trueSettings.get("Simply Judgements"))
			{
				// centers combo
				numScore.y += 10;
				numScore.x -= 95;
				numScore.x -= ((comboString.length - 1) * 22);
				lastCombo.push(numScore);
			}
		}

		if (judgementsGroup != null)
			judgementsGroup.sort(FNFSprite.depthSorting, FlxSort.DESCENDING);
		if (comboGroup != null)
			comboGroup.sort(FNFSprite.depthSorting, FlxSort.DESCENDING);
	}

	function healthCall(?ratingMultiplier:Float = 0)
	{
		var healthBase:Float = 0.06;
		health += (healthBase * (ratingMultiplier / (curStage == 'waltRoom' ? 50 : 100)));
	}

	function startSong():Void
	{
		startingSong = false;

		if (!paused)
		{
			if (songMusic != null)
				songMusic.play();
			
			if (songMusic != null)
				songMusicNew.play();
			
			if (vocals != null)
			        vocals.play();
			
			if (bf_vocals != null)
			        bf_vocals.play();
				
			if (opp_vocals != null)
			        opp_vocals.play();

			if (SONG.instType == "Legacy" || SONG.instType == null)
				songMusic.onComplete = finishSong.bind();
			
			if (SONG.instType == "New")
				songMusicNew.onComplete = finishSong.bind();

			resyncVocals();

			#if desktop
			// Song duration in a float, useful for the time left feature
			if (SONG.instType == "Legacy" || SONG.instType == null)
				songLength = songMusic.length;
			
			if (SONG.instType == "New")
				songLength = songMusicNew.length;

			// Updating Discord Rich Presence (with Time Left)
			updateRPC(false);
			#end
		}

		callFunc('startSong', []);
	}

	private function generateSong(dataPath:String):Void
	{
		// set the song speed
		songSpeed = SONG.speed;

		Conductor.changeBPM(SONG.bpm);
		Conductor.mapBPMChanges(SONG);
		
		#if DevBuild
			// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
			songDetails = "- CLASSIFIED CONTENT -";

			// String for when the game is paused
			detailsPausedText = songDetails;

			// set details for song stuffs
			detailsSub = "";
		#else
			// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
			songDetails = CoolUtil.dashToSpace(SONG.song) + ' - ' + CoolUtil.difficultyString;

			// String for when the game is paused
			detailsPausedText = "Paused - " + songDetails;

			// set details for song stuffs
			detailsSub = "";
		#end

		// Updating Discord Rich Presence.
		updateRPC(false);

		if (SONG.instType == "Legacy" || SONG.instType == null)
		{
			songMusic = new FlxSound().loadEmbedded(Paths.inst(SONG.song), false, true);
			songMusicNew = new FlxSound();
		}
		
		if (SONG.instType == "New")
		{
			songMusicNew = new FlxSound().loadEmbedded(Paths.instNew(SONG.song, CoolUtil.difficultyString.toLowerCase()), false, true);
			songMusic = new FlxSound();
		}

		if (SONG.needsVoices)
		{
			vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song), false, true);
			bf_vocals = new FlxSound().loadEmbedded(Paths.voicesPlayer(SONG.song, CoolUtil.difficultyString.toLowerCase()), false, true);
			opp_vocals = new FlxSound().loadEmbedded(Paths.voicesOpp(SONG.song, CoolUtil.difficultyString.toLowerCase()), false, true);
		}
		else
		{
			vocals = new FlxSound();
			bf_vocals = new FlxSound();
			opp_vocals = new FlxSound();
		}

		FlxG.sound.list.add(songMusic);
		FlxG.sound.list.add(songMusicNew);
		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(bf_vocals);
		FlxG.sound.list.add(opp_vocals);

		notesGroup = new Notefield();
		add(notesGroup);

		// generate the chart
		notesGroup.members = ChartParser.parseBaseChart(SONG);

		if (SONG.events != null && SONG.events.length > 0)
			timedEvents = ChartParser.parseEvents(SONG.events);

		for (i in timedEvents)
		{
			if (timedEvents.length > 0)
				loadedEventAction(i);
		}

		// give the game the heads up to be able to start
		generatedMusic = true;

		callFunc('generateSong', []);
	}

	function parseEventColumn(?delay:Float = 0)
	{
		while (timedEvents.length > 0)
		{
			var line:TimedEvent = timedEvents[0];
			if (line != null)
			{
				if (Conductor.songPosition < line.step + delay + Init.trueSettings['Offset'])
					break;

				eventTrigger(line.name, line.values);
				timedEvents.shift();
			}
		}
	}

	function loadedEventAction(event:TimedEvent)
	{
		if (Events.loadedEvents.get(event.name) != null)
		{
			var eventModule:ScriptHandler = Events.loadedEvents.get(event.name);
			eventModule.call('loadedEventAction', [event.values]);
		}
	}

	public function eventTrigger(name:String, params:Array<String>)
	{
		switch (name)
		{
			case 'Multiply Scroll Speed':
				var mult:Float = Std.parseFloat(params[0]);
				var timer:Float = Std.parseFloat(params[1]);
				if (Math.isNaN(mult))
					mult = 1;
				if (Math.isNaN(timer))
					timer = 0;

				var speed = SONG.speed * mult;

				if (mult <= 0)
					songSpeed = speed;
				else
				{
					if (songSpeedTween != null)
						songSpeedTween.cancel();
					songSpeedTween = FlxTween.tween(this, {songSpeed: speed}, timer, {
						ease: ForeverTools.returnTweenEase(params[2]),
						onComplete: function(twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}
		}

		if (Events.loadedEvents.get(name) != null)
		{
			var eventModule:ScriptHandler = Events.loadedEvents.get(name);
			eventModule.call('eventTrigger', [params]);
		}

		callFunc('eventTrigger', [name, params]);
	}
		
	var dodged:Bool;
	var shootin:Bool;
		
	/**
	* Checks on the spacebar if there's a spacebar mechanic required
	* if you have a mechanic you want to add with the spacebar
	* simply tag in your gimmick here with the stage/song you want it
	* to occur at, in other words, go nuts
	*
	* @param isAutoplay - Do I REALLY need to explain this one?
	*
	* @author DEMOLITIONDON96
	*/
	function detectSpace(isAutoplay:Bool = false)
	{
		if (!isAutoplay)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				/*
				* This set is for song-specific gimmicks
				* Try messing around with it
				*
				* - DEMOLITIONDON96
				*/

				switch (SONG.song)
				{
					default:
						// nothing
				}

				/*
				* This is if you want the gimmicks to affect
				* ALL songs globally, if they use a certain stage
				* 2 examples are already provided below
				*
				* - DEMOLITIOONDON96
				*/

				switch (curStage)
				{
					case 'waltRoom':
						if (health < 0.3 && limitThing > 0)
						{
							health += 1.25;
							limitThing -= 1;
						}
					
					case 'apartment':
						if (shootin)
							dodged = true;

					default:
						// nothing
				}
			}
		}else{
			switch (SONG.song)
			{
				default:
					//nothing
			}
			
			switch (curStage)
			{
				case 'waltRoom':
					if (health < 0.3 && limitThing > 0)
					{
						health += 1.25;
						limitThing -= 1;
					}
					
				case 'apartment':
					if (shootin)
						dodged = true;
				
				default:
					// nothing
			}
		}
	}
					
	/**
	* # Stage Background Flash Function
	*
	* Basically the BG Flash used in Isolated but it's now hardcoded and can be used globally now.
	* The reasoning for this is cause I'm NOT gonna go and duplicate the flash assets from the episode 1
	* stage onto other stages I want to use it at, too much work!
	*
	* @param flashType - Defines how you want the BG flash handler to behave
	* @param alpha - the visiblity of your BG you want it to flash at
	* @param time - How long you want the tween to take
	* @param ease - Uses ForeverTools to handle the ease function, so I suggest looking at ForeverDeps.hx to see your options
	* @param r - a value used for FlxColor.fromRGBFloat() as an individual number to make a color
	* @param g - same as the "r" value
	* @param b - you get the idea
	* @param a - color's alpha, you get the point
	*
	* @author DEMOLITIONDON96
	*/
	function flashBGEffect(flashType:String = 'normal', alpha:Float = 0.5, time:Float = 1, ease:String = 'linear', ?r:Float = 255, ?g:Float = 255, ?b:Float = 255, ?a:Float = 255) // TODO: Make this function shorter
	{
		if (!Init.trueSettings.get('Disable Flashing Lights') && stageBGFlash != null)
		{
			switch (flashType.toLowerCase())
			{
				case 'normal' | 'flash':
						if (alpha > 1 || alpha < 0) // prevents a crash from making a dumb mistake
							stageBGFlash.alpha = 0.5;
						else
							stageBGFlash.alpha = alpha;

						if (time <= 0) // another check to prevent a crash
							time = 1;

						if (r == 0 && g == 0 && b == 0) // blend check cause it makes it look cool
							stageBGFlash.blend = NORMAL;
						else
							stageBGFlash.blend = ADD;

						stageBGFlash.color = FlxColor.fromRGBFloat(r, g, b, a);

						if (BGFlashTween != null) // makes it so it won't look wonky, visually
							BGFlashTween.cancel();

						BGFlashTween = FlxTween.tween(stageBGFlash, {alpha: 0}, time, {ease: ForeverTools.returnTweenEase(ease), 
							onComplete: function(twn:FlxTween)
							{
								BGFlashTween = null;
							}
						});
					
				case 'dim' | 'darken' | 'dark':
					if (stageBGFlash != null)
					{
						if (BGFlashTween != null)
							BGFlashTween.cancel();

						if (stageBGFlash.blend != NORMAL)
							stageBGFlash.blend = NORMAL;

						if (time <= 0)
							time = 1;

						stageBGFlash.color = FlxColor.BLACK; // hardcoded to be black

						BGFlashTween = FlxTween.tween(stageBGFlash, {alpha: alpha}, time, {ease: ForeverTools.returnTweenEase(ease),
							onComplete: function(twn:FlxTween)
							{
								BGFlashTween = null;
							}
						});
					}
			}
		}
	}

	/**
	* # Camera Zoom Tween Fix
	* 
	* Don't know why, but this was NEEDED to fix the zooming from breaking, smh.
	*
	* @param zoom - Sets the zoom value of the camera
	* @param time - How long you want the tween to take
	* @param ease - I suggest reading the HaxeFlixel API on this one, this uses FlxEase's library components if you don't know how to use this
	*
	* @author JustJasonLol
	*/
	function tweenCamera(zoom:Float = 0.9, time:Float = 0.6, ease:Null<String>):Void
	{
		FlxTween.tween(FlxG.camera, {zoom: zoom}, time, {ease: ForeverTools.returnTweenEase(ease), onComplete: e -> defaultCamZoom = zoom});
	}

	/**
	* # Malfunction Life System Checker
	* 
	* Self explanitory, don't you think?
	* 
	* Checks on your lives in Malfunction and is used by the Error Notes
	* It will make sure to close your game if it goes below 0
	* 
	* @author DEMOLITIONDON96
	*/
	function updateMalfunctionLives()
	{
		callFunc('updateMalfunctionLives', []);

		crashLivesCounter -= 1;

		if (malfunctionTxt != null)
			malfunctionTxt.cancel();

		if (heartTween != null)
			heartTween.cancel();

		malfunctionTxt = FlxTween.tween(crashLives, {alpha: 1}, 0.6, {ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween)
			{
				malfunctionTxt = FlxTween.tween(crashLives, {alpha: 0.3}, 2, {ease: FlxEase.quartInOut, startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						malfunctionTxt = null;
					}
				});
			}
		});

		heartTween = FlxTween.tween(crashLivesIcon, {alpha: 1}, 0.6, {ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween)
			{
				heartTween = FlxTween.tween(crashLivesIcon, {alpha: 0.3}, 2, {ease: FlxEase.quartInOut, startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						heartTween = null;
					}
				});
			}
		});

		FlxTween.tween(crashLives, {x: 620}, 0.01);
		FlxTween.tween(crashLivesIcon, {x: 570}, 0.01);
		FlxTween.tween(crashLives, {x: 585}, 0.01, {startDelay: 0.1});
		FlxTween.tween(crashLivesIcon, {x: 535}, 0.01, {startDelay: 0.1});
		FlxTween.tween(crashLives, {x: 610}, 0.01, {startDelay: 0.2});
		FlxTween.tween(crashLivesIcon, {x: 560}, 0.01, {startDelay: 0.2});
		FlxTween.tween(crashLives, {x: 595}, 0.01, {startDelay: 0.3});
		FlxTween.tween(crashLivesIcon, {x: 545}, 0.01, {startDelay: 0.3});
		FlxTween.tween(crashLives, {x: 600}, 0.01, {startDelay: 0.4});
		FlxTween.tween(crashLivesIcon, {x: 550}, 0.01, {startDelay: 0.4});

		crashLivesIcon.animation.play("OMFG IT GLITCHES");
		
		new FlxTimer().start(0.25, function(tmr:FlxTimer)
		{
			crashLivesIcon.animation.play('idle');
		});

		if (crashLivesCounter == -1)
		{
			finishSong();
			trace('0 lives left, closing game...');
			FlxG.sound.play(Paths.sound('funkinAVI/wiiCrash'), 1);

			if(FlxG.random.bool(10)) 
				Application.current.window.alert("Fuck You, You Suck LMAO", 'Note About Your Skill:'); //10% of probability
			else 
				Application.current.window.alert("Message: if(note.noteType = 'Error Note') {trace('0 lives left, closing game...')}", 'Error On Funkin.avi.exe!:');

			System.exit(0);
		}
	}

	/**
	* # **The Cycled Sins Gimmick**
	*
	* As you can see, it's different than how it was before, it can actually be
	* used now without the need of a fucking event or some shit, so, have fun lol
	*
	* @param reactionTime - Amount of time you have to react before he shoots you
	* @param damageAmount - how much health it'll remove if you fail to dodge
	*
	* @author DEMOLITIONDON96
	*/
	function relapseGimmick(reactionTime:Float = 2, damageAmount:Float = 0.4)
	{
		callFunc('relapseGimmick', [reactionTime, damageAmount]);

		dodged = false;
		shootin = true;	
		FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Reload'), 0.4);
		updateSectionCamera('dad', false);
		//holyShitMOVEBITCH.alpha = 1;
		//holyShitMOVEBITCH.y = -420;
		defaultCamZoom = 1.5;
		opponent.playAnim("reload", true);
		opponent.specialAnim = true;
		/*new FlxTimer().start(reactionTime - 0.6, function(tmr:FlxTimer)
		{
			FlxTween.tween(holyShitMOVEBITCH, {alpha: 0, y: -400}, 0.3, {ease: FlxEase.quadInOut});
		});*/
		
		new FlxTimer().start(reactionTime, function(tmr:FlxTimer){
			FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Shoot'), 0.4);
			opponent.playAnim("attack", true);
			opponent.specialAnim = true;
			defaultCamZoom = 0.6;
			checkCamPosition();
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			if(!dodged) {
				FlxG.camera.shake(0.05, 0.05);
				health -= damageAmount;
				trace("lmfao you got shot depsite the fact this is nerfed");
				dodged = false;
			} else {
				boyfriend.playAnim('dodge');
				dodged = false;
				shootin = false;
				health += 0.05;
			}
			});
		});
	}

	function resyncVocals():Void
	{
		if (!endingSong)
		{
			songMusic.pause();
			songMusicNew.pause();
			vocals.pause();
			bf_vocals.pause();
			opp_vocals.pause();
			
			if (SONG.instType == "Legacy" || SONG.instType == null)
				Conductor.songPosition = songMusic.time;
			
			if (SONG.instType == "New")
				Conductor.songPosition = songMusicNew.time;
			
			vocals.time = Conductor.songPosition;
			bf_vocals.time = Conductor.songPosition;
			opp_vocals.time = Conductor.songPosition;
			songMusic.play();
			songMusicNew.play();
			vocals.play();
			bf_vocals.play();
			opp_vocals.play();
		}
	}

	override function stepHit()
	{
		super.stepHit();
		///*
		if (SONG.instType == "Legacy" || SONG.instType == null)
			if (songMusic.time >= Conductor.songPosition + 20)
				resyncVocals();

		if (SONG.instType == "New")
			if (songMusicNew.time <= Conductor.songPosition + 20)
				resyncVocals();
		//*/

		for (strumline in strumLines)
		{
			strumline.allNotes.forEachAlive(function(coolNote:Note)
			{
				coolNote.stepHit(curStep);
			});
		}
		
		if (Init.trueSettings.get('Display Song Cards'))
		{
			// Modified Card Delays
			switch (SONG.song)
			{
				case 'Isolated' | 'Lunacy':
					if (gameplayMode == STORY)
					{
						switch (curStep)
						{
							case 1: songCard.playCardAnim(0.2);
						}
					}
				case 'Delusional':
					if (gameplayMode == STORY)
					{
						switch (curStep)
						{
							case 1: songCard.playCardAnim(0.001);
						}
					}
			}
		}

		callFunc('stepHit', [curStep]);
	}

	private function charactersDance(curBeat:Int)
	{
		for (i in strumLines)
		{
			for (targetChar in i.characters)
			{
				if (targetChar != null)
				{
					if ((!targetChar.danceIdle && curBeat % targetChar.characterData.headBopSpeed == 0)
						|| (targetChar.danceIdle && curBeat % Math.round(gfSpeed * targetChar.characterData.headBopSpeed) == 0))
					{
						if (targetChar.animation.curAnim.name.startsWith("idle") // check if the idle exists before dancing
							|| targetChar.animation.curAnim.name.startsWith("dance"))
							targetChar.dance();
					}
				}
			}
		}

		if (gf != null && curBeat % Math.round(gfSpeed * gf.characterData.headBopSpeed) == 0)
		{
			if (gf.animation.curAnim.name.startsWith("idle") || gf.animation.curAnim.name.startsWith("dance"))
				gf.dance();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if ((FlxG.camera.zoom < 1.35 && curBeat % cameraBumpSpeed == 0) && (!Init.trueSettings.get('Reduced Movements')))
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.05;
			for (hud in strumHUD)
				hud.zoom += 0.05;
		}

		if (SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].changeBPM)
				Conductor.changeBPM(SONG.notes[curSection].bpm);
		}

		uiHUD.beatHit(curBeat);
		demolitionHUD.beatHit(curBeat);
		psychHUD.beatHit(curBeat);
		vanillaHUD.beatHit(curBeat);
		kadeHUD.beatHit(curBeat);
		cycledSinsHUD.beatHit(curBeat);
		episode1HUD.beatHit(curBeat);

		//
		charactersDance(curBeat);

		// stage stuffs
		stageBuild.stageUpdate(curBeat, boyfriend, gf, opponent);

		for (strumline in strumLines)
		{
			strumline.allNotes.forEachAlive(function(coolNote:Note)
			{
				coolNote.beatHit(curBeat);
			});
		}

		// Mechanics we don't want peeps to actually modify when snooping through the release files
		switch (SONG.song)
		{
			case 'Isolated':
				switch (curBeat)
				{
					// Fixed Cam Stuff to not trigger before cutscene is even done
					case 16: FlxTween.tween(camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut});
				
					case 30:
						FlxTween.tween(camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 3, {ease: FlxEase.quadOut});
						}
						
					case 160 | 352:
						flashBGEffect('darken', 0.85, 0.5, 'quartOut');
						
					case 184:
						flashBGEffect('darken', 0.77, 0.5, 'quartOut');
						
					case 188:
						flashBGEffect('darken', 0.6, 0.5, 'quartOut');
						
					case 376:
						flashBGEffect('darken', 0, 4, 'quartInOut');		
					
					case 36 | 40 | 44 | 52 | 56 | 60 | 64 | 68 | 72 | 76 | 80 | 84 | 88 | 92:
						flashBGEffect('normal', 0.32, 1.2, 'linear', 255, 255, 255);
					
					case 100 | 104 | 108 | 116 | 120 | 124 | 132 | 136 | 140 | 148 | 152 | 156 | 228 | 232 | 236 | 240 | 244 | 252 | 260 | 264 | 268 | 276 | 280 | 284 | 292 | 296 | 300 | 308 | 312 | 316 | 324 | 328 | 332 | 340 | 344 | 348:
						flashBGEffect('normal', 0.4, 0.35, 'linear', 255, 255, 255);
					
					case 98 | 102 | 106 | 110 | 114 | 118 | 122 | 126 | 130 | 134 | 138 | 142 | 146 | 150 | 154 | 158 | 226 | 230 | 234 | 238 | 242 | 246 | 250 | 254 | 258 | 262 | 266 | 270 | 274 | 278 | 282 | 286 | 290 | 294 | 298 | 302 | 306 | 310 | 314 | 318 | 322 | 326 | 330 | 334 | 338 | 342 | 346 | 350:
						flashBGEffect('normal', 0.67, 0.35, 'linear', 255, 255, 255);
					
					case 194 | 196 | 198 | 200 | 202 | 204 | 206 | 210 | 212 | 214 | 222:
						flashBGEffect('normal', 0.32, 0.35, 'linear', 255, 255, 255);
					
					case 216 | 217 | 218 | 219 | 220:
						flashBGEffect('normal', 0.32, 0.1, 'linear', 255, 255, 255);
					
					case 192:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						flashBGEffect('normal', 0.32, 0.35, 'linear', 255, 255, 255);
					
					case 208:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 1.5);
						flashBGEffect('normal', 0.32, 0.35, 'linear', 255, 255, 255);
					
					case 96 | 128 | 256 | 288:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						flashBGEffect('normal', 0.4, 0.35, 'linear', 255, 255, 255);
					
					case 48 | 336 | 304 | 272 | 248 | 112 | 144:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 1.5);
						flashBGEffect('normal', 0.32, 1.2, 'linear', 255, 255, 255);
				
					case 32:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
				
					case 416:
						camGame.visible = false;
						camHUD.visible = false;
						for (i in strumHUD)
						{
							i.visible = false;
						}
						
					// Fuck you *hardcodes the song speed changes*
					/*case 88:
						FlxTween.tween(this, {songSpeed: 1.3}, 1.5, {ease: FlxEase.quartInOut});
					
					case 95:
						FlxTween.tween(this, {songSpeed: 2.7}, 0.2, {ease: FlxEase.sineOut});*/
					
					case 224:
						flashBGEffect('normal', 0.4, 0.35, 'linear', 255, 255, 255);
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						//FlxTween.tween(this, {songSpeed: 2.7}, 0.2, {ease: FlxEase.sineOut});
						
					/*case 160 | 352:
						FlxTween.tween(this, {songSpeed: 1.7}, 0.5, {ease: FlxEase.quartOut});
						
					case 184:
						FlxTween.tween(this, {songSpeed: 1.9}, 0.3, {ease: FlxEase.quartOut});
						
					case 188:
						FlxTween.tween(this, {songSpeed: 2.1}, 0.3, {ease: FlxEase.quartOut});
						
					case 192:
						FlxTween.tween(this, {songSpeed: 2.4}, 0.3, {ease: FlxEase.quartOut});*/
					
					case 320:
						flashBGEffect('normal', 0.4, 0.35, 'linear', 255, 255, 255);
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						//FlxTween.tween(this, {songSpeed: 2.6}, 1.5, {ease: FlxEase.quartInOut});
						
					//case 376:
						//FlxTween.tween(this, {songSpeed: 2.3}, 2, {ease: FlxEase.quartInOut});
				}
		
			case 'Lunacy':
				switch (curBeat)
				{
					// I'm NOT gonna have a fun time recoding all this for the BG dimming in and out later lmao
					
					case 16: FlxTween.tween(camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut});
						
					case 32:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 1.5);

					case 38 | 46 | 54 | 62:
						FlxG.camera.zoom += 0.065;

					case 40 | 48 | 56:
						defaultCamZoom += 0.15;

					case 64:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 0.9);
						defaultCamZoom = 0.87;
					
					case 70 | 78 | 86:
						FlxG.camera.zoom += 0.045;
					
					case 72 | 80 | 88:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 0.9);
						defaultCamZoom += 0.15;
						
						
					case 96:
						defaultCamZoom = 0.75;
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.sineOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1.5, {ease: FlxEase.sineOut});
						}
						
					case 128 | 256:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);	
					
					case 156 | 392:
						defaultCamZoom = 1.05;
					
					case 160:
						defaultCamZoom = 0.7;
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 1.5);

					case 192:
						defaultCamZoom = 0.75;
					case 200 | 238 | 270 | 316 | 332 | 344:
						defaultCamZoom = 0.8;
					case 208 | 360:
						defaultCamZoom = 0.85;
					case 216 | 368 | 252 | 284:
						defaultCamZoom = 0.9;
					case 220 | 376:
						defaultCamZoom = 0.95;
					case 222 | 384 | 235 | 267 | 239 | 271 | 334:
						defaultCamZoom = 1;

					case 224 | 288:
						defaultCamZoom = 0.75;
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						FlxTween.tween(camHUD, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
						}

					case 228 | 260 | 292 | 286 | 400:
						defaultCamZoom = 1.1;

					case 230 | 262 | 296 | 312 | 236 | 268:
						defaultCamZoom = 0.65;

					case 232 | 264:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						defaultCamZoom = 0.9;

					case 233 | 266 | 412 | 240 | 272 | 300 | 304 | 336 | 248 | 280 | 328:
						defaultCamZoom = 0.7;
						
					case 320:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.WHITE, 1.5);
						defaultCamZoom = 0.7;

					case 254:
						defaultCamZoom = 1.1;
						FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						}

					case 318:
						defaultCamZoom = 1.25;
						FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						}

					case 310 | 342 | 350:
						defaultCamZoom = 1.25;

					case 352:
						defaultCamZoom = 0.8;
						FlxTween.tween(camHUD, {alpha: 0.15}, 8, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.15}, 8, {ease: FlxEase.sineInOut});
						}

					case 408:
						defaultCamZoom = 0.9;
						FlxTween.tween(camHUD, {alpha: 0.36}, 4, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.36}, 4, {ease: FlxEase.sineInOut});
						}

					case 480:
						if (!Init.trueSettings.get('Disable Flashing Lights')) camGame.flash(FlxColor.BLACK, 1.5);
						camHUD.alpha = 0;
						for (i in strumHUD)
						{
							i.alpha = 0;
						}

					case 506:
						FlxTween.tween(camHUD, {alpha: 0.5}, 4, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.5}, 4, {ease: FlxEase.sineInOut});
						}

					case 536:
						FlxTween.tween(camHUD, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
							FlxTween.tween(i, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
						}

					case 540:
						FlxTween.tween(camGame, {alpha: 0}, 5, {ease: FlxEase.quartInOut});
				}
				
			case 'Scrapped':
				switch (curBeat)
				{
					case 64: FlxTween.tween(opponent, {alpha: 1}, 10);
					case 424: FlxTween.tween(opponent, {alpha: 0}, 5);
				}

			case 'Mercy Legacy':
				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					if (curBeat >= 0 && curBeat <= 63)
						PlayState.health -= 0.02;
					else if (curBeat >= 64 && curBeat <= 95)
						PlayState.health -= 0.2;
					else if (curBeat >= 96 && curBeat <= 127)
						PlayState.health -= 0.06;
					else if (curBeat >= 128 && curBeat <= 191)
						PlayState.health -= 0.16;
					else if (curBeat >= 192 && curBeat <= 255)
						PlayState.health -= 0.1;
					else if (curBeat >= 256 && curBeat <= 319)
						PlayState.health -= 0.18;
					else if (curBeat >= 320)
						PlayState.health -= 0.01;
				}

			case 'Mercy':
				// Cam Stuff Handler
				switch (curBeat)
				{
					case 16:
						FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
						FlxTween.tween(camHUD, {alpha: 1}, 5, {ease: FlxEase.sineInOut, startDelay: 1.5});
						defaultCamZoom = 1.3;

					case 32: defaultCamZoom = 1.2;
					case 40: defaultCamZoom = 1.1;
					case 48: defaultCamZoom = 1;
					case 56: defaultCamZoom = 0.9;
					case 64: defaultCamZoom = 0.75;

					// Very Spooky Phase 2 Walt (real)
					case 256: 
					        FlxTween.tween(camGame, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
						        FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						}

					case 264:
						FlxTween.tween(camGame, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
						defaultCamZoom = 1.3;

					case 275:
						defaultCamZoom = 0.8;
						FlxTween.tween(camHUD, {alpha: 1}, 0.31, {ease: FlxEase.sineInOut});
						for (i in strumHUD)
						{
						        FlxTween.tween(i, {alpha: 1}, 0.31, {ease: FlxEase.sineInOut});
						}
						if (!Init.trueSettings.get('Disable Mechanics'))
							inkFormWarning.alpha = 1;

					case 276:
						if (!Init.trueSettings.get('Disable Mechanics'))
							FlxTween.tween(inkFormWarning, {alpha: 0}, 2, {ease: FlxEase.sineInOut});

					// Final Stretch
					case 494:
						camHUD.flash(ForeverTools.returnColor("white"), 3);
						camGame.visible = false;
						FlxTween.tween(bfStrums, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: 3});
						for (i in strumHUD)
						{
						        FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: 3});
						}
						if (!Init.trueSettings.get('Disable Mechanics'))
							FlxTween.tween(spaceBarCounter, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
				}

				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					// Health Drain Shit
					if (curBeat >= 0 && curBeat <= 63)
						PlayState.health -= 0.005;
					else if (curBeat >= 64 && curBeat <= 79)
						PlayState.health -= 0.01;
					else if (curBeat >= 80 && curBeat <= 87)
						PlayState.health -= 0.07;
					else if (curBeat >= 88 && curBeat <= 95)
						PlayState.health -= 0.01;
					else if (curBeat >= 96 && curBeat <= 127)
						PlayState.health -= 0.03;
					else if (curBeat >= 128 && curBeat <= 159)
						PlayState.health -= 0.1;
					else if (curBeat >= 160 && curBeat <= 191)
						PlayState.health -= 0.06;
					else if (curBeat >= 192 && curBeat <= 207)
						PlayState.health -= 0.01;
					else if (curBeat >= 208 && curBeat <= 239)
						PlayState.health -= 0.04;
					else if (curBeat >= 240 && curBeat <= 255)
						PlayState.health -= 0.005;
					else if (curBeat >= 256 && curBeat <= 291)
						PlayState.health -= 0.03;
					else if (curBeat >= 292 && curBeat <= 307)
						PlayState.health -= 0.05;
					else if (curBeat >= 308 && curBeat <= 339)
						PlayState.health -= 0.085;
					else if (curBeat >= 340 && curBeat <= 371)
						PlayState.health -= 0.1;
					else if (curBeat >= 372 && curBeat <= 387)
						PlayState.health -= 0.11;
					else if (curBeat >= 388 && curBeat <= 403)
						PlayState.health -= 0.12;
					else if (curBeat >= 404 && curBeat <= 451)
						PlayState.health -= 0.14;
					else if (curBeat >= 452 && curBeat <= 467)
						PlayState.health -= 0.17;
					else if (curBeat >= 468 && curBeat <= 475)
						PlayState.health -= 0.21;
					else if (curBeat >= 476 && curBeat <= 489)
						PlayState.health -= 0.25;
					else if (curBeat >= 490)
						PlayState.health -= 0.02;
				}
					
			case 'Cycled Sins':
				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					switch (curBeat)
					{
						case 158:
							relapseGimmick(0.7, 0.3);
						case 172 | 204:
							relapseGimmick(1.12, 0.6);
						case 190:
							relapseGimmick(0.7, 0.54);
						case 212:
							relapseGimmick(0.7, 0.8);
						case 222 | 264:
							relapseGimmick(0.7, 1);
						case 236:
							relapseGimmick(0.7, 0.4);
						case 248:
							relapseGimmick(1.12, 1.2);
						case 270:
							relapseGimmick(0.7, 1.5);
					}
				}

			case 'Malfunction':
				switch (curBeat)
				{
					// Intro Cam Stuff
					case 1:	FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
					case 16: tweenCamera(1.2, 5, 'quartInOut'); // yes you gonna have to add a ; at the end of the {} because flixel
					case 32:
						defaultCamZoom = 0.8;
						FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
						for (i in strumHUD)
						{
						        FlxTween.tween(i, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
						}	
					case 39 | 48 | 64 | 72 | 88 | 96 | 103 | 113 | 128 | 184 | 192: defaultCamZoom = 0.8;
					case 38 | 102: tweenCamera(1.5, 0.25, 'sineInOut');
					case 45 | 61 | 110 | 126 | 187: defaultCamZoom = 0.9;
					case 46 | 62 | 67 | 76 | 83 | 92 | 111 | 127 | 158 | 190: defaultCamZoom = 1;
					case 47 | 63 | 68 | 84 | 112 | 159: defaultCamZoom = 1.3;
					case 69 | 85: defaultCamZoom = 1.1;				
					case 160: defaultCamZoom = 0.65;
					case 164: tweenCamera(1.5, 6, 'sineInOut');
						
					// Ight Jason, the fun part's all yours
					// The fun begins 0_0
				}
		}

		callFunc('beatHit', [curBeat]);
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (generatedMusic && PlayState.SONG.notes[Std.int(curSection)] != null)
		{
			var lastMustHit:Bool = PlayState.SONG.notes[Std.int(lastSection)].mustHitSection;
			if (PlayState.SONG.notes[Std.int(curSection)].mustHitSection != lastMustHit)
			{
				camDisplaceX = 0;
				camDisplaceY = 0;
			}
		}

		callFunc('sectionHit', [curSection]);
	}

	/* ====== substate stuffs ====== */
	public static function resetMusic()
	{
		// simply stated, resets the playstate's music for other states and substates
		if (songMusic != null)
			songMusic.stop();
		
		if (songMusicNew != null)
			songMusicNew.stop();
		
		if (bf_vocals != null)
			bf_vocals.stop();
		
		if (opp_vocals != null)
			opp_vocals.stop();
		
		if (vocals != null)
			vocals.stop();
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (songMusic != null || songMusicNew != null)
			{
				songMusic.pause();
				songMusicNew.pause();
				vocals.pause();
				bf_vocals.pause();
				opp_vocals.pause();
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (songMusic != null && !startingSong || songMusicNew != null && !startingSong)
				resyncVocals();

			// resume all tweens and timers
			FlxTimer.globalManager.forEach(function(tmr:FlxTimer)
			{
				if (!tmr.finished)
					tmr.active = true;
			});

			FlxTween.globalManager.forEach(function(twn:FlxTween)
			{
				if (!twn.finished)
					twn.active = true;
			});

			paused = false;

			updateRPC(false);
		}

		Paths.clearUnusedMemory();

		super.closeSubState();
	}

	/*
		Extra functions and stuffs
	 */
	public function createVideoCutscene(name:String)
	{
		callFunc('createVideoCutscene', [name]);
		
		inCutscene = true;

		var filepath:String = Paths.video(name);
		var video:VideoHandler = new VideoHandler();
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			startCountdown();
			return;
		}
	}

	// song end function at the end of the playstate lmao ironic I guess
	function finishSong(ignoreOffset:Bool = false):Void
	{
		var onFinish:Void->Void = endSong;

		songMusic.volume = 0;
		songMusicNew.volume = 0;
		vocals.volume = 0;
		bf_vocals.volume = 0;
		opp_vocals.volume = 0;
		vocals.pause();
		bf_vocals.pause();
		opp_vocals.pause();

		if (ignoreOffset || Init.trueSettings['Offset'] <= 0)
			onFinish();
		else
		{
			new FlxTimer().start(Init.trueSettings['Offset'] / 1000, function(offset:FlxTimer)
			{
				onFinish();
			});
		}
	}

	function endSong():Void
	{
		callFunc('endSong', []);

		canPause = false;
		endingSong = true;

		deaths = 0;

		switch (gameplayMode)
		{
			case STORY:
				// set the campaign's score higher
				campaignScore += ScoreUtils.score;

				// remove the current song from the story playlist
				storyPlaylist.remove(storyPlaylist[0]);

				// check if there aren't any songs left
				if ((storyPlaylist.length <= 0))
				{
					leavePlayState();

					// save the week's score if the score is valid
					if (SONG.validScore && gameplayMode != CHARTING) // accessing charting mode is impossible on story but you never know;
						ScoreUtils.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

					// flush the save
					FlxG.save.flush();
				}
				else // if there is, try to play an ending cutscene
					songCutscene(true);
			case FREEPLAY:
				if (SONG.validScore && gameplayMode != CHARTING)
					ScoreUtils.saveScore(SONG.song, ScoreUtils.score, storyDifficulty);
				leavePlayState();
			default:
				leavePlayState();
		}
		//
	}

	public function callDefaultSongEnd()
	{
		if (gameplayMode == STORY)
		{
			//
			var song:String = PlayState.storyPlaylist[0];
			var diff:String = '-' + CoolUtil.difficultyFromNumber(storyDifficulty);

			if (!sys.FileSystem.exists(Paths.songJson(song, song + '-' + CoolUtil.defaultDifficulty.toLowerCase())))
				CoolUtil.defaultDifficulty = '';

			if (storyDifficulty == 1)
				diff = CoolUtil.defaultDifficulty;

			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;

			PlayState.SONG = Song.loadFromJson(song.toLowerCase() + diff, song);
			ForeverTools.killMusic([songMusic, songMusicNew, bf_vocals, opp_vocals, vocals]);

			// deliberately did not use the main.switchstate as to not unload the assets
			FlxG.switchState(new PlayState());
		}
		else
			leavePlayState();
	}

	var dialogueBox:DialogueBox;

	public function songCutscene(onEnd:Bool = false)
	{
		if (skipCutscenes())
			return onEnd ? endSong() : startCountdown();

		inCutscene = true;
		canPause = false;

		var cutscenePath = Paths.module('cutscene' + (onEnd ? '-end' : ''), 'songs/' + SONG.song.toLowerCase());
		callFunc(onEnd ? 'songEndCutscene' : 'songCutscene', []);

		// lol dumb check;
		if (!sys.FileSystem.exists(cutscenePath))
			callTextbox();
		//
	}

	inline function checkTextbox():Bool
	{
		var dialogueFileStr:String = 'dialogue';
		dialogueFileStr = (endingSong ? 'dialogueEnd' : 'dialogue');
		var dialogPath = Paths.file('songs/' + SONG.song.toLowerCase() + '/$dialogueFileStr.json');

		if (sys.FileSystem.exists(dialogPath))
			return true;

		return false;
	}

	public function callTextbox()
	{
		if (checkTextbox())
		{
			if (!endingSong)
				startedCountdown = false;

			var dialogueFileStr:String = 'dialogue';
			dialogueFileStr = (endingSong ? 'dialogueEnd' : 'dialogue');

			var dialogPath = Paths.file('songs/' + SONG.song.toLowerCase() + '/$dialogueFileStr.json');

			dialogueBox = DialogueBox.createDialogue(sys.io.File.getContent(dialogPath));
			dialogueBox.cameras = [dialogueHUD];
			add(dialogueBox);

			if (dialogueBox != null)
				dialogueBox.fadeInMusic();

			dialogueBox.whenDaFinish = endingSong ? endSong : startCountdown;
		}
		else
			(endingSong ? callDefaultSongEnd() : startCountdown());
	}

	inline public static function skipCutscenes():Bool
	{
		// pretty messy but an if statement is messier
		if (Init.trueSettings.get('Skip Text') != null && Std.isOfType(Init.trueSettings.get('Skip Text'), String))
		{
			switch (cast(Init.trueSettings.get('Skip Text'), String))
			{
				case 'never':
					return false;
				case 'freeplay only':
					if (gameplayMode != STORY)
						return true;
					else
						return false;
				default:
					return true;
			}
		}
		return false;
	}

	var countdownPos:Int;
	var songPosCount:Int;

	public function startCountdown():Void
	{
		inCutscene = false;
		canPause = true;

		countdownPos = 0;
		songPosCount = 4; // in case you want the song to start later, increase this number;

		Conductor.songPosition = -(Conductor.crochet * 5);

		camHUD.visible = true;
		startedCountdown = true;

		callFunc('startCountdown', []);

		// cache shit
		displayScore(0, false, true);
		for (uniqueNote in notesGroup.members)
		{
			for (strumline in strumLines)
			{
				var splash:NoteSplash = createSplash(uniqueNote.noteType, 0, strumline);
				if (splash != null)
					splash.visible = false;
			}
		}
		//

		switch(SONG.song.toLowerCase().replace('-', ' '))
		{
			case 'cycled sins':
				FlxTween.tween(cycledSinsHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});
				
			case 'isolated' | 'lunacy' | 'delusional':
				FlxTween.tween(episode1HUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});

			default:
				checkHUDS();
		}

		if (skipCountdown)
		{
			Conductor.songPosition = -(Conductor.crochet * 1);
			Conductor.shouldStartSong = true;
			return;
		}

		var introGraphicNames:Array<String> = ['prepare', 'ready', 'set', 'go'];
		var introSoundNames:Array<String> = ['intro3', 'intro2', 'intro1', 'introGo'];

		var introGraphics:Array<FlxGraphic> = [];
		var introSounds:Array<Sound> = [];

		for (graphic in introGraphicNames)
		{
			switch (curStage)
			{
				/*case 'abandonedStreet' | 'forestNew' | 'smilesOffice':
					introGraphics.push(Paths.image(ForeverTools.returnSkinAsset('$graphic', 'vintage', changeableSkin, 'UI')));
				case 'delusionalStreet':
					introGraphics.push(Paths.image(ForeverTools.returnSkinAsset('$graphic', 'satan', changeableSkin, 'UI')));
				case 'waltRoom' | 'colorlessSight':
					introGraphics.push(Paths.image(ForeverTools.returnSkinAsset('$graphic', 'walt', changeableSkin, 'UI')));
				case 'apartment' | 'relapseNew':
					introGraphics.push(Paths.image(ForeverTools.returnSkinAsset('$graphic', 'relapse', changeableSkin, 'UI')));
				case 'forestOld' | 'theLoop':
					introGraphics.push(Paths.image(ForeverTools.returnSkinAsset('$graphic', 'legacy', changeableSkin, 'UI')));*/
				default:
					introGraphics.push(Paths.image(ForeverTools.returnSkinAsset('$graphic', assetModifier, changeableSkin, 'UI')));
			}
		}

		for (sound in introSoundNames)
		{
			switch (curStage)
			{
				/*case 'abandonedStreet' | 'forestNew' | 'smilesOffice':
					introSounds.push(Paths.sound('vintage/$sound'));
				case 'delusionalStreet':
					introSounds.push(Paths.sound('satan/$sound'));
				case 'waltRoom' | 'colorlessSight':
					introSounds.push(Paths.sound('walt/$sound'));
				case 'apartment' | 'relapseNew':
					introSounds.push(Paths.sound('relapse/$sound'));
				case 'forestOld' | 'theLoop':
					introSounds.push(Paths.sound('legacy/$sound'));*/
				default:
					introSounds.push(Paths.sound('$assetModifier/$sound'));
			}
		}

		new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (gameplayMode == STORY)
			{
				switch (SONG.song)
				{
					case 'Isolated' | 'Lunacy' | 'Mortiferum Risus' | 'Affliction': // no countdown sounds for the songs in story mode
						songPosCount--;
						
					case 'Delusional' | 'Twisted Grins' | 'Resentment' | 'Mercy':
						if (introGraphics[countdownPos] != null)
						{
							var count:FlxSprite = new FlxSprite().loadGraphic(introGraphics[countdownPos]);
							count.scrollFactor.set();
							count.updateHitbox();

							count.screenCenter();
							add(count);
							FlxTween.tween(count, {y: count.y += 50, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									count.destroy();
								}
							});
							if (introSounds[countdownPos] != null)
								FlxG.sound.play(introSounds[countdownPos], 0.6);
							Conductor.songPosition = -(Conductor.crochet * songPosCount);

							// bop with countdown;
							charactersDance(curBeat);
						}

						songPosCount--;
						countdownPos++;
				}
			} else {
				if (introGraphics[countdownPos] != null)
				{
					var count:FlxSprite = new FlxSprite().loadGraphic(introGraphics[countdownPos]);
					count.scrollFactor.set();
					count.updateHitbox();

					if (assetModifier == 'pixel' || assetModifier == 'glitchy')
						count.setGraphicSize(Std.int(count.width * PlayState.daPixelZoom));

					count.screenCenter();
					add(count);
					FlxTween.tween(count, {y: count.y += 50, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							count.destroy();
						}
					});
					if (introSounds[countdownPos] != null)
						FlxG.sound.play(introSounds[countdownPos], 0.6);
					Conductor.songPosition = -(Conductor.crochet * songPosCount);

					// bop with countdown;
					charactersDance(curBeat);
				}

				songPosCount--;
				countdownPos++;
			}

			callFunc('countdownTick', [countdownPos]);
		}, 5);
	}

	private function checkAutoplayText():ClassHUD
	{
		switch (Init.trueSettings.get('HUD Style').toLowerCase())
		{
			case 'psych': // psych engine fans gonna go nuts about this
				psychHUD.autoplayMark.visible = bfStrums.autoplay;
				psychHUD.scoreBar.visible = !bfStrums.autoplay;
	
			case 'demolition': // demoliton HUD
				demolitionHUD.autoplayMark.visible = bfStrums.autoplay;
				demolitionHUD.scoreBar.visible = !bfStrums.autoplay;
	
			default: // forever HUD
				uiHUD.autoplayMark.visible = bfStrums.autoplay;
				uiHUD.scoreBar.visible = !bfStrums.autoplay;
		}

		return Init.trueSettings.get('HUD Style');
	}

	private function checkHUDS():ClassHUD
	{
		switch (Init.trueSettings.get('HUD Style').toLowerCase())
		{
			case 'psych': // psych engine fans gonna go nuts about this
				FlxTween.tween(psychHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});
	
			case 'demolition': // demoliton HUD
				FlxTween.tween(demolitionHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});
	
			default: // forever HUD
				FlxTween.tween(uiHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});
		}

		return Init.trueSettings.get('HUD Style');
	}

	public function leavePlayState()
	{
		// set up transitions
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// change to the menu state
		switch (gameplayMode)
		{
			case STORY:
				completeEpisode();
				Main.switchState(this, new StoryMenu());
				ForeverTools.resetMenuMusic();
				clearStored = true;
			case FREEPLAY:
				completeFPSong();
				switch (CoolUtil.dashToSpace(SONG.song))
				{
					case 'Isolated' | 'Lunacy' | 'Delusional' | 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus' | 'Mercy' | 'Affliction':
						Main.switchState(this, new states.menus.freeplay.FreeplayState());
					default:
						if (PlayState.SONG.song.endsWith('Legacy'))
							Main.switchState(this, new states.menus.freeplay.LegacyState());
						else
							Main.switchState(this, new states.menus.freeplay.ExtrasState()); // yeah, there's no way I'm making a case for EVERY fucking song in that menu, too much work!
				}
				clearStored = true;
			case CHARTING:
				openSubState(new states.substates.PauseSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y,
					["Back to Charter", "Leave Charter Mode", "Exit to Options", "Exit to Menu"]));
		}
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		return super.add(Object);
	}

	public function callFunc(key:String, args:Array<Dynamic>)
	{
		if (moduleArray != null)
		{
			for (i in moduleArray)
				i.call(key, args);
			if (generatedMusic)
				callLocalVariables();
		}
	}

	public function setVar(key:String, value:Dynamic)
	{
		var allSucceed:Bool = true;
		if (moduleArray != null)
		{
			for (i in moduleArray)
			{
				i.set(key, value);

				if (!i.exists(key))
				{
					trace('${i.scriptFile} failed to set $key for its interpreter, continuing.');
					allSucceed = false;
					continue;
				}
			}
		}
		return allSucceed;
	}

	function callLocalVariables()
	{
		// GENERAL
		setVar('add', add);
		setVar('remove', remove);
		setVar('openSubState', openSubState);

		setVar('logTrace', function(text:String, time:Float, onConsole:Bool = false)
		{
			logTrace(text, time, onConsole);
		});

		// gonna be useful someday
		setVar('playVideoCutscene', function(video:String, isEnd:Bool = false)
		{
			@:privateAccess
			CutsceneState.playCutscene(video);
		});

		setVar('inCutscene', inCutscene);

		setVar('GameSystem', Sys);

		setVar('GameWindow', lime.app.Application.current.window);
		setVar('getGameMeta', function(meta:String)
		{
			return lime.app.Application.current.meta.get(meta);
		});

		// CHARACTERS
		setVar('songName', PlayState.SONG.song.toLowerCase());

		if (boyfriend != null)
		{
			setVar('bf', boyfriend);
			setVar('boyfriend', boyfriend);
			setVar('player', boyfriend);
			setVar('bfName', boyfriend.curCharacter);
			setVar('boyfriendName', boyfriend.curCharacter);
			setVar('playerName', boyfriend.curCharacter);

			setVar('bfData', boyfriend.characterData);
			setVar('boyfriendData', boyfriend.characterData);
			setVar('playerData', boyfriend.characterData);
		}

		if (opponent != null)
		{
			setVar('dad', opponent);
			setVar('dadOpponent', opponent);
			setVar('opponent', opponent);
			setVar('dadName', opponent.curCharacter);
			setVar('dadOpponentName', opponent.curCharacter);
			setVar('opponentName', opponent.curCharacter);

			setVar('dadData', opponent.characterData);
			setVar('dadOpponentData', opponent.characterData);
			setVar('opponentData', opponent.characterData);
		}

		if (gf != null)
		{
			setVar('gf', gf);
			setVar('girlfriend', gf);
			setVar('spectator', gf);
			setVar('gfName', gf.curCharacter);
			setVar('girlfriendName', gf.curCharacter);
			setVar('spectatorName', gf.curCharacter);

			setVar('gfData', gf.characterData);
			setVar('girlfriendData', gf.characterData);
			setVar('spectatorData', gf.characterData);
		}

		if (bfStrums != null)
			setVar('bfStrums', bfStrums);
		if (dadStrums != null)
			setVar('dadStrums', dadStrums);
		if (strumLines != null)
			setVar('strumLines', strumLines);
		if (allUIs != null)
			setVar('allUIs', allUIs);
		if (camGame != null)
			setVar('camGame', camGame);
		if (camHUD != null)
			setVar('camHUD', camHUD);
		if (dialogueHUD != null)
			setVar('dialogueHUD', dialogueHUD);
		if (strumHUD != null)
			setVar('strumHUD', strumHUD);
		if (camAlt != null)
		{
			setVar('camAlt', camAlt);
			setVar('camOther', camAlt); // psych users going craazy rn;
		}
		if (uiHUD != null)
			setVar('ui', uiHUD);

		setVar('score', ScoreUtils.score);
		setVar('combo', ScoreUtils.combo);
		setVar('hits', ScoreUtils.notesHit);
		setVar('mineHits', ScoreUtils.minesHit);
		setVar('misses', ScoreUtils.misses);
		setVar('health', health);
		setVar('deaths', deaths);

		setVar('curBeat', curBeat);
		setVar('curStep', curStep);
		setVar('curSection', curSection);
		setVar('lastBeat', lastBeat);
		setVar('lastStep', lastStep);
		setVar('lastSection', lastSection);

		setVar('set', function(key:String, value:Dynamic)
		{
			var dotList:Array<String> = key.split('.');

			if (dotList.length > 1)
			{
				var reflector:Dynamic = Reflect.getProperty(this, dotList[0]);

				for (i in 1...dotList.length - 1)
					reflector = Reflect.getProperty(reflector, dotList[i]);

				Reflect.setProperty(reflector, dotList[dotList.length - 1], value);
				return true;
			}

			Reflect.setProperty(this, key, value);
			return true;
		});

		setVar('get', function(variable:String)
		{
			var dotList:Array<String> = variable.split('.');

			if (dotList.length > 1)
			{
				var reflector:Dynamic = Reflect.getProperty(this, dotList[0]);

				for (i in 1...dotList.length - 1)
					reflector = Reflect.getProperty(reflector, dotList[i]);

				return Reflect.getProperty(reflector, dotList[dotList.length - 1]);
			}

			return Reflect.getProperty(this, variable);
		});

		setVar('exists', function(variable:String)
		{
			var dotList:Array<String> = variable.split('.');

			if (dotList.length > 1)
			{
				var reflector:Dynamic = Reflect.getProperty(this, dotList[0]);

				for (i in 1...dotList.length - 1)
					reflector = Reflect.getProperty(reflector, dotList[i]);

				return Reflect.hasField(reflector, dotList[dotList.length - 1]);
			}

			return Reflect.hasField(this, variable);
		});

		setVar('copy', function(variable:String)
		{
			var dotList:Array<String> = variable.split('.');

			var reflector:Dynamic = null;

			if (dotList.length > 1)
			{
				reflector = Reflect.getProperty(this, dotList[0]);

				for (i in 1...dotList.length - 1)
					reflector = Reflect.getProperty(reflector, dotList[i]);

				return Reflect.getProperty(reflector, dotList[dotList.length - 1]);
			}

			return Reflect.copy(reflector);
		});
	}
}
