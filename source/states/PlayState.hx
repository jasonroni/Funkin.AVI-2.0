package states;

import openfl.events.KeyboardEvent;
import base.utils.CamUtils;
import flixel.addons.text.FlxTypeText;
import base.dependency.FeatherDeps.Events;
import base.dependency.FeatherDeps.ScriptHandler;
import base.events.Events;
import base.events.SongLoop;
import base.song.ChartParser;
import base.song.Conductor;
import base.song.Song;
import base.song.SongFormat.SwagSong;
import base.song.SongFormat.TimedEvent;
import base.utils.FNFUtils.FNFSprite;
import base.utils.PlayStateUtils;
import base.utils.ScoreUtils;
import flash.system.System;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import gamejolt.GameJolt.GameJoltAPI;
import lime.app.Application;
import lime.ui.Window;
import objects.*;
import objects.Character;
import objects.ui.*;
import objects.ui.hud.hardcoded.*;
import objects.ui.hud.toggleable.*;
import objects.ui.notes.*;
import objects.ui.notes.Strumline.Receptor;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import openfl.media.Sound;
import openfl.utils.Assets as OpenFlAssets;
import states.CutsceneState;
import states.editors.CharacterOffsetEditor;
import states.menus.*;
import states.substates.GameOverSubstate;
import sys.io.File;

using StringTools;

#if (flixel <= "5.2.2")
import flixel.system.FlxSound;
#else
import flixel.sound.FlxSound;
#end
#if VIDEO_PLUGIN
// This fixes 2.6.0 users
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end
#if desktop
import base.dependency.Discord;
#end

enum GameMode
{
	STORY;
	FREEPLAY;
	CHARTING;
}

enum FlashType
{
	NORMAL;
	DARK;
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
	@:isVar public var songSpeed(get, set):Float = 0;
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
	public static var healthDrain:Float = 0;
	public var smoothyHealth:Float = 1; // IF YOU READ THIS ITS ONLY FOR MERCY !!
	public static var thing:Int;

	// Characters;
	public static var opponent:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

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

	public var cinematicBars:Map<String, FlxSprite> = ["top" => null, "bottom" => null,];

	public static var camBars:FlxCamera; // I got lazy, sorry.

	private static var prevCamFollow:FlxObject;

	public var camDisplaceX:Float = 0;
	public var camDisplaceY:Float = 0; // might not use depending on result

	public static var cameraSpeed:Float = 1;
	public static var defaultCamZoom:Float = 1.05;
	public static var forceZoom:Array<Float>;

	public static var cameraBumpSpeed:Float = 4;

	// User Interface and Objects (Toggleable)
	// uiHUD has the most werid initialization ever
	public static var uiHUD:ClassHUD; // default HUD
	public static var psychHUD:PsychHUD;
	public static var vanillaHUD:VanillaHUD;
	public static var kadeHUD:KadeHUD;
	public static var spectraHUD:SpectraHUD;

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

	// lyrics stuff
	var lyricsIcon:HealthIcon;
	var lyrics:FlxTypeText;
	var lyricsTween:FlxTween;
	var iconTween:FlxTween;

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

	// Hunted Gimmick
	var camHudMoves:Bool = false;

	var fade:FlxSprite;

	// for Tweening shaders and stuff
	public static var grayScale:FlxRuntimeShader = new FlxRuntimeShader(Shaders.grayScale, null, 120);
	public static var andromeda:FlxRuntimeShader = new FlxRuntimeShader(Shaders.andromedaVCR, null, 140);
	public static var chromZoomShader:FlxRuntimeShader = new FlxRuntimeShader(Shaders.aberration, null, 150);
	public static var chromNormalShader:FlxRuntimeShader = new FlxRuntimeShader(Shaders.aberrationDefault, null, 150);
	public static var blurShader:FlxRuntimeShader = new FlxRuntimeShader(Shaders.tiltShift, null, 120);
	public static var blurShaderHUD:FlxRuntimeShader = new FlxRuntimeShader(Shaders.tiltShift, null, 120);
	public static var bloomEffect:FlxRuntimeShader = new FlxRuntimeShader(Shaders.bloom_alt, null, 120);
	public static var dramaticCamMovement:FlxRuntimeShader = new FlxRuntimeShader(Shaders.cameraMovement, null, 150);
	public static var monitorFilter:FlxRuntimeShader = new FlxRuntimeShader(Shaders.monitorFilter, null, 140);
	public static var staticEffect:FlxRuntimeShader = new FlxRuntimeShader(Shaders.tvStatic, null, 120);
	public static var delusionalShift:FlxRuntimeShader = new FlxRuntimeShader(Shaders.delusionalShift, null, 120);
	public static var redVignette:FlxRuntimeShader = new FlxRuntimeShader(Shaders.redFromAngryBirds, null, 120);
	public static var waltStatic:FlxRuntimeShader = new FlxRuntimeShader(Shaders.vhsFilter, null, 130);

	var chromEffect:Float = 0.0001;
	var blurEffect:Float = 0.0;
	var blurHUD:Float = 0.0;
	var staticModifer:Float = 0.0;
	var effectRed:Float = 0.0;

	var shaderAnim:Float = 0;

	var blurTween:FlxTween;
	var chromTween:FlxTween;
	var blurHUDTween:FlxTween;
	var staticTween:FlxTween;
	var vignetteTween:FlxTween;
	var offsetTwn:FlxTween;

	var globalGradient:FlxSprite;

	var isCamForced = false;

	public static var isCustomHUD:Bool = false;

	public static var noteSkinType:String = 'DEFAULTSKIN';

	function resetStatics()
	{
		GameOverSubstate.resetDeathVariables();
		Events.getScriptEvents();

		ScoreUtils.resetAccuracy();
		PlayState.SONG.validScore = true;
		deaths = 0;
		health = smoothyHealth = 0.5;

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
		add(stageBuild.layers);

		stageBGFlash = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
		stageBGFlash.scale.set(FlxG.width * 3, FlxG.height * 3);
		stageBGFlash.alpha = 0.0001; // it's at this value so the game doesn't lag when it becomes visible
		stageBGFlash.scrollFactor.set();
		add(stageBGFlash);

		if (stageBuild.spawnGirlfriend)
			add(gf);

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
		add(stageBuild.layers);

		stageBGFlash = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
		stageBGFlash.scale.set(FlxG.width * 5, FlxG.height * 5);
		stageBGFlash.alpha = 0.0001; // it's at this value so the game doesn't lag when it becomes visible
		stageBGFlash.x -= 750;
		stageBGFlash.y -= 450;
		stageBGFlash.scrollFactor.set();
		add(stageBGFlash);

		if (stageBuild.spawnGirlfriend)
			add(gf);

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

		PlayStateUtils.instance.migrateSettings();
		GameData.setFreeplayData();
		PlayStateUtils.instance.loadRPCIcon();
		PlayStateUtils.instance.loadWindowTitleData();

		switch (SONG.song)
		{
			case 'Isolated' | 'Devilish Deal' | 'Lunacy' | 'Delusional' | 'Twisted Grins' | 'Dentophobia' | 'Hunted':
				noteSkinType = 'CARTOON';
			case 'Isolated Old' | 'Isolated Legacy' | 'Isolated Beta' | 'Lunacy Legacy' | 'Delusional Legacy' | 'Mercy Legacy' | 'Twisted Grins Legacy' | 'Facade' | "Don't Cross!" | 'Birthday' | 'Delutrance':
				noteSkinType = 'VANILLA';
			case 'Mercy':
				noteSkinType = 'MERCY';
			default:
				noteSkinType = 'DEFAULTSKIN';
		}

		switch (SONG.song)
		{
			case 'Isolated' | 'Luancy' | 'Delusional' | 'Devilish Deal' | 'Cycled Sins':
				isCustomHUD = true;
		}

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
		camBars = new FlxCamera();
		camAlt = new FlxCamera();
		camScratch = new FlxCamera();
		camOther = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		dialogueHUD.bgColor.alpha = 0;
		camBars.bgColor.alpha = 0;
		camAlt.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		camScratch.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);

		// HUD Camera so HUD objects stay on screen
		FlxG.cameras.add(camBars, false);
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
		var darknessBG:FlxSprite = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(1, 1, FlxColor.BLACK);
		darknessBG.alpha = (100 - Init.trueSettings.get('Stage Opacity')) / 100;
		darknessBG.scrollFactor.set(0, 0);
		darknessBG.scale.set(FlxG.width, FlxG.height);
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

		dadStrums = new Strumline(placement - (FlxG.width / 4) - (noteSkinType != 'VANILLA' && assetModifier != 'pixel' ? 12 : 0), height + (assetModifier == 'pixel' ? 10 : 0), [opponent], downscroll, false, true, checkTween(true), false, 4);
		bfStrums = new Strumline(placement + (!centered ? (FlxG.width / 4) : 0) - (noteSkinType != 'VANILLA' && assetModifier != 'pixel' ? 12 : 0), height + (assetModifier == 'pixel' ? 10 : 0), [boyfriend], downscroll, true, false, checkTween(false), true, 4);

		if (curStage == 'waltRoom')
			dadStrums.visible = false;
		else
			dadStrums.visible = !centered;

		strumLines.add(dadStrums);
		strumLines.add(bfStrums);

		strumHUD = [];
		for (i in 0...strumLines.length)
		{
			// generate a new strum camera
			strumHUD[i] = new FlxCamera();
			strumHUD[i].bgColor.alpha = 0;

			allUIs.push(strumHUD[i]);
			FlxG.cameras.add(strumHUD[i], false);
			// nuh uh, this shit is staying, i am NOT gonna go and redo all the fucking events that uses this
			switch (curStage)
			{
				case 'theLoop' | 'forestOld':
					strumLines.members[i].cameras = [camHUD];

				default:
					strumLines.members[i].cameras = [strumHUD[i]];
			}
		}
		add(strumLines);

		// add the dialogue UI
		FlxG.cameras.add(dialogueHUD, false);

		if (!isCustomHUD)
		{
			switch (Init.trueSettings.get('HUD Style'))
			{
				case 'psych':
					psychHUD = new PsychHUD();
					psychHUD.alpha = 0;
					add(psychHUD);
					psychHUD.cameras = [camHUD];
				case 'spectra':
					spectraHUD = new SpectraHUD();
					spectraHUD.alpha = 0;
					add(spectraHUD);
					spectraHUD.cameras = [camHUD];
				case 'vanilla':
					vanillaHUD = new VanillaHUD();
					vanillaHUD.alpha = 0;
					add(vanillaHUD);
					vanillaHUD.cameras = [camHUD];
				case 'kade':
					kadeHUD = new KadeHUD();
					kadeHUD.alpha = 0;
					add(kadeHUD);
					kadeHUD.cameras = [camHUD];
				default:
					uiHUD = new ClassHUD();
					uiHUD.alpha = 0;
					add(uiHUD);
					uiHUD.cameras = [camHUD];
			}
		}

		switch (SONG.song)
		{
			case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional':
				episode1HUD = new Episode1HUD();
				episode1HUD.alpha = 0;
				add(episode1HUD);
				episode1HUD.cameras = [camHUD];
			case 'Cycled Sins':
				cycledSinsHUD = new CycledSinsHUD();
				cycledSinsHUD.alpha = 0;
				add(cycledSinsHUD);
				cycledSinsHUD.cameras = [camHUD];
		}

		if (SONG.song == 'Twisted Grins')
		{
			opponent.characterData.headBopSpeed = 4;
			boyfriend.characterData.headBopSpeed = 4;
			cameraBumpSpeed = 8;
		}

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

		//FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		//FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		callFunc('postCreate', []);

		Paths.clearUnusedMemory();

		if (downscroll)
		{
			crashLives = new FlxText(600, 170, 0, "", 20);
			crashLivesIcon = new FlxSprite(550, 170);
		}
		else
		{
			crashLives = new FlxText(600, 500, 0, "", 20);
			crashLivesIcon = new FlxSprite(550, 500);
		}

		crashLives.setFormat(Paths.font("Retro Gaming"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		crashLives.borderSize = 2;
		crashLives.borderQuality = 2;
		crashLives.antialiasing = false;
		crashLives.scrollFactor.set();
		crashLives.cameras = [camHUD];

		crashLivesIcon.frames = Paths.getSparrowAtlas('UI/funkinAVI/gimmicks/malfunctionGimmickIcon');
		crashLivesIcon.animation.addByPrefix('idle', 'lives-icon idle', 15);
		crashLivesIcon.animation.addByPrefix('OMFG IT GLITCHES', 'lives-icon glitchin', 15);
		crashLivesIcon.animation.play('idle');
		crashLivesIcon.scale.set(2.2, 2.2);
		crashLivesIcon.antialiasing = false;
		crashLivesIcon.cameras = [camHUD];

		if (!Init.trueSettings.get('Low Quality'))
		{
			switch (curStage)
			{
				case 'stage' | 'desktop' | 'waltRoom' | 'apartment' | 'treasureIsland' | 'forbiddenRealm' | 'fuckingLine' | 'staticVoid' | 'vaultRoom':
				// don't add scratch assets

				default:
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
		}

		fade = new FlxSprite().makeGraphic(1, 1, 0x000000);
		fade.screenCenter();
		fade.cameras = [camHUD];
		fade.scale.set(FlxG.width, FlxG.height);
		fade.alpha = 0;
		add(fade);

		waltScreenThing = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
			-FlxG.height * FlxG.camera.zoom).makeGraphic(1, 1, 0xFF000000);
		waltScreenThing.scrollFactor.set();
		waltScreenThing.cameras = [camAlt];
		waltScreenThing.scale.set(FlxG.width, FlxG.height);
		waltScreenThing.alpha = 0;

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

		var waltInstructionsMain:FlxText = new FlxText(370, 500, 0, "Take Advantage of the SPACEBAR!", 30);
		waltInstructionsMain.cameras = [camAlt];
		waltInstructionsMain.setFormat(Paths.font("splatter"), 30);
		waltInstructionsMain.scrollFactor.set();

		var waltSubTxt:FlxText = new FlxText(waltInstructionsMain.x + 66, waltInstructionsMain.y + 40, 0,
			"(It will help you regain health when critically low)", 15);
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

		lyrics = new FlxTypeText(0, FlxG.height - 65, 0, '', 15);
		lyrics.setFormat(Paths.font('vcr'), 30, FlxColor.WHITE, EngineTools.setTextAlign('left'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lyrics.cameras = [camAlt];
		lyrics.alpha = 0;
		lyrics.borderSize = 4;
		lyrics.scrollFactor.set();
		lyrics.screenCenter(X).x -= 90;
		add(lyrics);

		lyricsIcon = new HealthIcon('placeholder', false);
		lyricsIcon.x = lyrics.x - 150;
		lyricsIcon.y = lyrics.y - 65;
		lyricsIcon.visible = false;
		lyricsIcon.cameras = [camAlt];
		add(lyricsIcon);

		if (!Init.trueSettings.get('Low Quality'))
		{
			globalGradient = new FlxSprite().loadGraphic(Paths.image('UI/gimmicks/gradient'));
			globalGradient.screenCenter();
			globalGradient.setGraphicSize(Std.int(globalGradient.width * 0.68));
			globalGradient.cameras = [camAlt];
			globalGradient.alpha = 0;
			add(globalGradient);
		}

		// Cleaner Initialization for the mechanics and note visibility stuff
		PlayStateUtils.instance.songSetup();

		if (curStage == 'waltRoom')
		{
			if (!Init.trueSettings.get('Disable Mechanics'))
				{
					add(waltInstructionsMain);
					add(waltSubTxt);

					FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
					FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
					FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});
				}
		}

		// call the funny intro cutscene depending on the song
		songCutscene(false);
		if (canaddshaders)
			PlayStateUtils.initializeShaders();
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
			if (generatedMusic && !boyfriend.stunned && !endingSong)
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
					health = smoothyHealth = 0;
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
		FlxG.game.setFilters([]); // clears game filters
		super.destroy();
	}

	function get_songSpeed():Float
	{
		return songSpeed;
	}

	function set_songSpeed(value:Float):Float
	{
		if (generatedMusic)
		{
			var ratio:Float = value / songSpeed; // funny word huh
			for (note in bfStrums.allNotes)
			{
				if (note.customScrollspeed && note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
			for (note in dadStrums.allNotes)
			{
				if (note.customScrollspeed && note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
		}
		songSpeed = value;
		return value;
	}

	var cameraOnDad = false;

	public function updateSectionCamera(value:String, isPlayer:Bool = false)
	{
		var char = opponent;

		if (value == "center")
			return;

		switch (value)
		{
			case 'bf':
				char = boyfriend;
				cameraOnDad = false;
			case 'dad':
				char = opponent;
				cameraOnDad = true;
			case 'gf':
				char = gf;
				cameraOnDad = SONG.notes[Std.int(curStep / 16)].mustHitSection;
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
				case 'forestNew':
					defaultCamZoom = .72;
				case 'vaultRoom': defaultCamZoom = .9;
			}
		}
		else
		{
			switch (curStage)
			{
				case 'apartment':
					if (shootin)
					{
						getCenterX = char.getMidpoint().x - 300;
						getCenterY = char.getMidpoint().y + 150;
					}
					else
					{
						getCenterX = char.getMidpoint().x + 100;
						getCenterY = char.getMidpoint().y - 100;
					}
				case 'forestNew':
					defaultCamZoom = .67;
					
				case 'vaultRoom': defaultCamZoom = .7;
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

	function checkCamPosition()
	{
		/*
		 * Originally in the update function
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
			updateSectionCamera(cameraPos, cameraPos == 'bf');
		}
		else
			updateSectionCamera(SONG.notes[curSection].mustHitSection ? 'bf' : 'dad', SONG.notes[curSection].mustHitSection);
	}

	// stuff that isn't on PlayStateUtils cus the game hates me

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
	public function updateMalfunctionLives()
	{
		callFunc('updateMalfunctionLives', []);

		crashLivesCounter -= 1;

		if (malfunctionTxt != null)
			malfunctionTxt.cancel();

		if (heartTween != null)
			heartTween.cancel();

		malfunctionTxt = FlxTween.tween(crashLives, {alpha: 1}, 0.6, {
			ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween)
			{
				malfunctionTxt = FlxTween.tween(crashLives, {alpha: 0.3}, 2, {
					ease: FlxEase.quartInOut,
					startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						malfunctionTxt = null;
					}
				});
			}
		});

		heartTween = FlxTween.tween(crashLivesIcon, {alpha: 1}, 0.6, {
			ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween)
			{
				heartTween = FlxTween.tween(crashLivesIcon, {alpha: 0.3}, 2, {
					ease: FlxEase.quartInOut,
					startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						heartTween = null;
					}
				});
			}
		});

		// to be honest we can just use shake
		//                                - jason

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

			if (FlxG.random.bool(10))
				Application.current.window.alert("You Suck LMAO", 'Note About Your Skill:'); // 10% of probability
			else
				Application.current.window.alert("Message: if(note.noteType = 'Error Note') {trace('0 lives left, closing game...')}",
					'Error On Funkin.avi.exe!:');

			Sys.exit(0);
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
	 *  @param doubleBarrel - if Relapse Mouse shoots twice instead of once
	 *
	 * @author DEMOLITIONDON96
	 */
	public function relapseGimmick(reactionTime:Float = 2, damageAmount:Float = 0.4, ?doubleBarrel:Bool = false)
	{
		callFunc('relapseGimmick', [reactionTime, damageAmount]);

		dodged = false;
		shootin = true;
		FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Reload'), 0.4);
		updateSectionCamera('dad', false);
		// holyShitMOVEBITCH.alpha = 1;
		// holyShitMOVEBITCH.y = -420;
		defaultCamZoom = 1.5;
		opponent.playAnim("reload", true);
		opponent.specialAnim = true;
		/*new FlxTimer().start(reactionTime - 0.6, function(tmr:FlxTimer)
			{
				FlxTween.tween(holyShitMOVEBITCH, {alpha: 0, y: -400}, 0.3, {ease: FlxEase.quadInOut});
		});*/

		new FlxTimer().start(reactionTime, function(tmr:FlxTimer)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Shoot'), 0.4);
			opponent.playAnim("attack", true);
			opponent.specialAnim = true;
			checkCamPosition();
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				if (!dodged)
				{
					FlxG.camera.shake(0.05, 0.05);
					PlayState.health -= damageAmount;
					trace("lmfao you got shot depsite the fact this is nerfed");
					if (!FlxG.stage.window.title.contains(' - lmfao you got shot depsite the fact this is nerfed'))
					{
						FlxG.stage.window.title += ' - lmfao you got shot depsite the fact this is nerfed'; // troll
						new FlxTimer().start(5, _ -> PlayStateUtils.instance.loadWindowTitleData());
					}
					if (doubleBarrel)
					{
						defaultCamZoom = 1.25;
						new FlxTimer().start(0.275, function(tmr:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Shoot'), 0.4);
							opponent.playAnim("attack", true);
							opponent.specialAnim = true;
							checkCamPosition();
							if (!dodged)
							{
								FlxG.camera.shake(0.05, 0.05);
								PlayState.health -= damageAmount / 2;
								trace("lmfao you got shot depsite the fact this is nerfed");
								if (!FlxG.stage.window.title.contains(' - lmfao you got shot depsite the fact this is nerfed'))
								{
									FlxG.stage.window.title += " - bet you didn't expect him to shoot twice this time around lol"; // troll
									new FlxTimer().start(5, _ -> PlayStateUtils.instance.loadWindowTitleData());
								}
								dodged = false;
								shootin = false;
								defaultCamZoom = 0.6;
							}
							else
							{
								boyfriend.playAnim('dodge');
								dodged = false;
								shootin = false;
								health += 0.05;
								defaultCamZoom = 0.6;
							}
						});
					}
					else
					{
						dodged = false;
						shootin = false;
						defaultCamZoom = 0.6;
					}
				}
				else
				{
					if (doubleBarrel)
					{
						defaultCamZoom = 1.25;
						dodged = false;
						health += 0.05;
						new FlxTimer().start(0.275, function(tmr:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Shoot'), 0.4);
							opponent.playAnim("attack", true);
							opponent.specialAnim = true;
							checkCamPosition();
							if (!dodged)
							{
								FlxG.camera.shake(0.05, 0.05);
								PlayState.health -= damageAmount / 2;
								trace("lmfao you got shot depsite the fact this is nerfed");
								if (!FlxG.stage.window.title.contains(' - lmfao you got shot depsite the fact this is nerfed'))
								{
									FlxG.stage.window.title += " - bet you didn't expect him to shoot twice this time around lol"; // troll
									new FlxTimer().start(5, _ -> PlayStateUtils.instance.loadWindowTitleData());
								}
								dodged = false;
								shootin = false;
								defaultCamZoom = 0.6;
							}
							else
							{
								boyfriend.playAnim('dodge');
								dodged = false;
								shootin = false;
								health += 0.05;
								defaultCamZoom = 0.6;
							}
						});
					}
					else
					{
						boyfriend.playAnim('dodge');
						dodged = false;
						shootin = false;
						health += 0.05;
						defaultCamZoom = 0.6;
					}
				}
			});
		});
	}

	/**
	 * Manages the `lyrics` of the song in-game
	 * @param icon Lyrics icon as string
	 * @param text The lyrics text
	 * @param font Lyric font
	 * @param size Lyric size
	 * @param duration Delay time to disappear
	 * @param tweenType Tween ease (as string)
	 * @param textDelay Text delay. The amount of seconds to type the next word
	 * 
	 * @author DEMOLITIONDON96 Ft. Jason
	 */
	public function manageLyrics(icon:String = 'bf', text:String = 'swaggers', font:String = 'vcr', size:Int = 15, duration:Float = 5,
			tweenType:String = 'linear', textDelay:Float = 0.03)
	{
		lyricsIcon.updateIcon(icon, false);
		if (!lyricsIcon.visible)
		{
			lyricsIcon.visible = true;
			lyricsIcon.alpha = 0;
		}

		lyrics.font = Paths.font(font);
		lyrics.resetText(text);
		lyrics.start(textDelay); // currently placeholder time !!

		if (lyricsTween != null)
			lyricsTween.cancel();

		if (iconTween != null)
			iconTween.cancel();

		iconTween = FlxTween.tween(lyricsIcon, {
			'scale.x': 1,
			'scale.y': 1,
			alpha: 1
		}, 0.5, {
			ease: EngineTools.returnTweenEase(tweenType),
			onComplete: function(twn:FlxTween)
			{
				iconTween = FlxTween.tween(lyricsIcon, {alpha: 0, 'scale.x': 0, 'scale.y': 0}, 0.25, {
					startDelay: duration,
					ease: EngineTools.returnTweenEase(tweenType),
					onComplete: function(twn:FlxTween)
					{
						iconTween = null;
					}
				});
			}
		});

		lyricsTween = FlxTween.tween(lyrics, {
			size: size,
			alpha: 1
		}, 0.5, {
			ease: EngineTools.returnTweenEase(tweenType),
			onComplete: function(twn:FlxTween)
			{
				lyricsTween = FlxTween.tween(lyrics, {alpha: 0, size: 0}, 0.25, {
					startDelay: duration,
					ease: EngineTools.returnTweenEase(tweenType),
					onComplete: function(twn:FlxTween)
					{
						lyricsTween = null;
					}
				});
			}
		});
	}

	/**
	 * # Stage Background Flash Function
	 *
	 * Basically the BG Flash used in Isolated but it's now hardcoded and can be used globally now.
	 * The reasoning for this is cause I'm NOT gonna go and duplicate the flash assets from the episode 1
	 * stage onto other stages I want to use it at, too much work!
	 *
	 * @param flashType - Defines how you want the BG flash handler to behave
	 * @param settings - A structure with the flashing options.
	 *
	 * @author DEMOLITIONDON96 ft. Jason
	 */
	public function flashBGEffect(flashType:FlashType, settings:FlashingSettings)
	{
		// null checkes
		if (settings.colors == null) settings.colors = [255, 255, 255];
		if (settings.timer == null) settings.timer = 3;
		if (settings.ease == null) settings.ease = FlxEase.linear;
		if (settings.alpha == null) settings.alpha = .5;

		// due to the fact that some silly 19 year old guy called demo overuses the shit
		// out of the zooms this has to exist in cases of emergency   - jason the silly !!
		// stageBGFlash.setPosition(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom);

		if (!Init.trueSettings.get('Disable Flashing Lights') && stageBGFlash != null)
		{
			switch (flashType)
			{
				case NORMAL:
					if (settings.alpha > 1 || settings.alpha < 0) // prevents a crash from making a dumb mistake
						stageBGFlash.alpha = 0.5;
					else
						stageBGFlash.alpha = settings.alpha;

					if (settings.timer <= 0) // another check to prevent a crash
						settings.timer = 1;

					if (settings.colors[0] == 0 && settings.colors[1] == 0 && settings.colors[2] == 0) // blend check cause it makes it look cool
						stageBGFlash.blend = NORMAL;
					else
						stageBGFlash.blend = ADD;

					stageBGFlash.color = FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2], 255);

					if (BGFlashTween != null) // makes it so it won't look wonky, visually
						BGFlashTween.cancel();

					BGFlashTween = FlxTween.tween(stageBGFlash, {alpha: 0}, settings.timer, {
						ease: settings.ease,
						onComplete: function(twn:FlxTween)
						{
							BGFlashTween = null;
						}
					});

				case DARK:
					if (stageBGFlash != null)
					{
						if (BGFlashTween != null)
							BGFlashTween.cancel();

						if (stageBGFlash.blend != NORMAL)
							stageBGFlash.blend = NORMAL;

						if (settings.timer <= 0)
							settings.timer = 1;

						stageBGFlash.color = FlxColor.BLACK; // hardcoded to be black

						BGFlashTween = FlxTween.tween(stageBGFlash, {alpha: settings.alpha}, settings.timer, {
							ease: settings.ease,
							onComplete: function(twn:FlxTween)
							{
								BGFlashTween = null;
							}
						});
					}
			}
		}
	}

	public var strumsBlocked:Array<Bool> = [];
	/*private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(keysArray, eventKey);
	}

	private function keyPressed(key:Int)
	{
		if(paused || key < 0) return;
		if(!generatedMusic || endingSong || boyfriend.stunned) return;

		// more accurate hit time for the ratings?
		var lastTime:Float = Conductor.songPosition;
		if(Conductor.songPosition >= 0) Conductor.songPosition = FlxG.sound.music.time;

		// obtain notes that the player can hit
		var plrInputNotes:Array<Note> = notesGroup.members.filter(function(n:Note):Bool {
			var canHit:Bool = !strumsBlocked[n.noteData] && n.canBeHit && n.mustPress && !n.tooLate && !n.wasGoodHit;
			return n != null && canHit && !n.isSustainNote && n.noteData == key;
		});
		plrInputNotes.sort(sortHitNotes);

		var shouldMiss:Bool = !ClientPrefs.data.ghostTapping;

		if (plrInputNotes.length != 0) { // slightly faster than doing `> 0` lol
			var funnyNote:Note = plrInputNotes[0]; // front note
			// trace('✡⚐🕆☼ 💣⚐💣');

			if (plrInputNotes.length > 1) {
				var doubleNote:Note = plrInputNotes[1];

				if (doubleNote.noteData == funnyNote.noteData) {
					// if the note has a 0ms distance (is on top of the current note), kill it
					if (Math.abs(doubleNote.strumTime - funnyNote.strumTime) < 1.0)
						invalidateNote(doubleNote);
					else if (doubleNote.strumTime < funnyNote.strumTime)
					{
						// replace the note if its ahead of time (or at least ensure "doubleNote" is ahead)
						funnyNote = doubleNote;
					}
				}
			}

			goodNoteHit(funnyNote);
		}
		else {
			if (shouldMiss && !boyfriend.stunned) {
				callOnScripts('onGhostTap', [key]);
				noteMissPress(key);
			}
		}

		// Needed for the  "Just the Two of Us" achievement.
		//									- Shadow Mario
		if(!keysPressed.contains(key)) keysPressed.push(key);

		//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
		Conductor.songPosition = lastTime;

		var spr: = playerStrums.members[key];
		if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
		{
			spr.playAnim('pressed');
			spr.resetAnim = 0;
		}
	}

	public static function sortHitNotes(a:Note, b:Note):Int
		{
			if (a.lowPriority && !b.lowPriority)
				return 1;
			else if (!a.lowPriority && b.lowPriority)
				return -1;
	
			return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
		}
	
		private function onKeyRelease(event:KeyboardEvent):Void
		{
			var eventKey:FlxKey = event.keyCode;
			var key:Int = getKeyFromEvent(keysArray, eventKey);
			if(!controls.controllerMode && key > -1) keyReleased(key);
		}
	
		private function keyReleased(key:Int)
		{
			if(!cpuControlled && startedCountdown && !paused)
			{
				var spr:StrumNote = playerStrums.members[key];
				if(spr != null)
				{
					spr.playAnim('static');
					spr.resetAnim = 0;
				}
				callOnScripts('onKeyRelease', [key]);
			}
		}
	
		public static function getKeyFromEvent(arr:Array<String>, key:FlxKey):Int
		{
			if(key != NONE)
			{
				for (i in 0...arr.length)
				{
					var note:Array<FlxKey> = Controls.instance.keyboardBinds[arr[i]];
					for (noteKey in note)
						if(key == noteKey)
							return i;
				}
			}
			return -1;
		}
	
		// Hold notes
		private function keysCheck():Void
		{
			// HOLDING
			var holdArray:Array<Bool> = [];
			var pressArray:Array<Bool> = [];
			var releaseArray:Array<Bool> = [];
			for (key in keysArray)
			{
				holdArray.push(controls.pressed(key));
				if(controls.controllerMode)
				{
					pressArray.push(controls.justPressed(key));
					releaseArray.push(controls.justReleased(key));
				}
			}
	
			// TO DO: Find a better way to handle controller inputs, this should work for now
			if(controls.controllerMode && pressArray.contains(true))
				for (i in 0...pressArray.length)
					if(pressArray[i] && strumsBlocked[i] != true)
						keyPressed(i);
	
			if (startedCountdown && !boyfriend.stunned && generatedMusic)
			{
				if (notes.length > 0) {
					for (n in notes) { // I can't do a filter here, that's kinda awesome
						var canHit:Bool = (n != null && !strumsBlocked[n.noteData] && n.canBeHit
							&& n.mustPress && !n.tooLate && !n.wasGoodHit && !n.blockHit);
	
						if (guitarHeroSustains)
							canHit = canHit && n.parent != null && n.parent.wasGoodHit;
	
						if (canHit && n.isSustainNote) {
							var released:Bool = !holdArray[n.noteData];
							
							if (!released)
								goodNoteHit(n);
						}
					}
				}
	
				if (!holdArray.contains(true) || endingSong)
					playerDance();
	
				#if ACHIEVEMENTS_ALLOWED
				else checkForAchievement(['oversinging']);
				#end
			}
	
			// TO DO: Find a better way to handle controller inputs, this should work for now
			if((strumsBlocked.contains(true)) && releaseArray.contains(true))
				for (i in 0...releaseArray.length)
					if(releaseArray[i] || strumsBlocked[i] == true)
						keyReleased(i);
		}*/

	override public function update(elapsed:Float)
	{
		callFunc('update', [elapsed]);

		if (canaddshaders) 
			PlayStateUtils.instance.shaderAnims(elapsed);

		stageBuild.stageUpdateConstant(elapsed, boyfriend, gf, opponent);

		PlayStateUtils.instance.thingE = elapsed;

		super.update(elapsed);

		smoothyHealth = FlxMath.lerp(smoothyHealth, health, CoolUtil.boundTo(elapsed * 20, 0, 1));

		if (FlxG.keys.justPressed.F5)
			isDebugMode = true;

		if (FlxG.keys.justPressed.SPACE && isDebugMode)
		{
			try
			{
				health = 2;
				endSong();
			}
			catch (e)
			{
				trace('fail!!!');
			}
		}

		if (!Init.trueSettings.get('Disable Mechanics'))
			PlayStateUtils.instance.detectSpace(bfStrums.autoplay); // checks on the autoplay to determine whether or not it would play the mechanics for you

		// hunted mechanic
		for (stuff in allUIs)
		{
			if (camHudMoves && !Init.trueSettings.get('Disable Mechanics'))
			{
				var songPos = Conductor.songPosition;

				// math momento -jason
				stuff.x = 20 + Math.sin(songPos / 300 * 3) * FlxG.width * 0.83 / 10;
				stuff.y = 30 + Math.sin(songPos / 450) * FlxG.height * 0.9 / 10;
				stuff.angle = Math.sin(songPos / 800) * 80 / 10;

				// illegal instruction moment
				FlxTween.tween(PlayState, {health: FlxG.random.float(0.024, 2)}, 0.3);
			}
		}

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
				for (i in 0...healths.length)
				{
					if (lastOne)
					{
						lastOne = PlayStateUtils.instance.tweenWaltScreen(healths[i], alphas[i]);
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
				if (Controls.justPressed('pause') && canPause)
					pauseGame();

				if (gameplayMode != STORY)
				{
					if (Controls.justPressed("autoplay"))
					{
						PlayState.SONG.validScore = false;
						bfStrums.autoplay = !bfStrums.autoplay;
						switch (SONG.song.toLowerCase().replace('-', ' '))
						{
							case 'cycled sins':
							// cycledSinsHUD.autoplayMark.visible = bfStrums.autoplay;
							// cycledSinsHUD.scoreBar.visible = !bfStrums.autoplay;
							case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional':
							episode1HUD.autoplayTxt.visible = bfStrums.autoplay;
							episode1HUD.scoreTxt.visible = !bfStrums.autoplay;
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
						Main.switchState(this, new states.editors.CharacterOffsetEditor(PlayState.SONG.stage));
					}
				}
			}

			if (generatedMusic && PlayState.SONG.notes[curSection] != null)
			{
				var curSection = Std.int(curStep / 16);
				if (curSection != lastSection)
				{
					// section reset stuff
					var lastMustHit:Bool = PlayState.SONG.notes[lastSection].mustHitSection;
					if (PlayState.SONG.notes[curSection].mustHitSection != lastMustHit)
					{
						camDisplaceX = 0;
						camDisplaceY = 0;
					}
					lastSection = Std.int(curStep / 16);
				}
				if (!shootin) checkCamPosition();
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

			var lerpVal = CoolUtil.boundTo((elapsed * 2.4) * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

			EngineTools.cameraBumpingZooms(FlxG.camera, defaultCamZoom, forceZoom, elapsed);
			for (hud in allUIs)
				EngineTools.cameraBumpingZooms(hud, 1, forceZoom, elapsed);

			deathCheck();

			// spawn in the notes from the array
			notesGroup.callNotes(bfStrums, dadStrums, strumLines);

			noteCalls();
			parseEventColumn();
		}

		// the COOLER cam pos thing or whatever
		// x, y, angle
		var camOffset = [0.0, 0.0, 0];

		var char = cameraOnDad ? opponent : boyfriend;

		if (char.animation.curAnim != null && !isCamForced) 
		{
			switch (char.animation.curAnim.name.substring(4))
			{
				case 'UP' | 'UP-alt' | 'UPmiss':
					camOffset[1] -= 40;

				case 'RIGHT' | 'RIGHT-alt' | 'RIGHTmiss':
					camOffset[0] += 40;
					if (!SONG.song.endsWith('Legacy')) camOffset[2] += 1.3;

				case 'LEFT' | 'LEFT-alt' | 'LEFTmiss':
					camOffset[0] -= 40;
					if (!SONG.song.endsWith('Legacy')) camOffset[2] -= 1.3;

				case 'DOWN' | 'DOWN-alt' | 'DOWNmiss':
					camOffset[1] += 40;
			}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x + camOffset[0], lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y + camOffset[1], lerpVal));
			camGame.angle = FlxMath.lerp(camGame.angle, 0 + camOffset[2], CoolUtil.boundTo(CoolUtil.boundTo(elapsed * 2.4 / 0.4, 0, 1) * cameraSpeed , 0, 1));
		}

		CamUtils.updateCamera(camGame, elapsed);
		CamUtils.updateCamera(camHUD, elapsed);
		for (theSillies in strumHUD) CamUtils.updateCamera(theSillies, elapsed);
		CamUtils.updateCamera(camOther, elapsed);

		callFunc('postUpdate', [elapsed]);

		// yk i sometimes ask why we put sum stuff there n shit
		uhhTurnBackNormalOrSmth = function () {
			for (goofyAhhUIS in PlayState.main.allUIs)
				{
					goofyAhhUIS.x += 80;
					goofyAhhUIS.y = FlxMath.lerp(0, goofyAhhUIS.y, CoolUtil.boundTo(elapsed * 2.4, 0, 1));
				}
				FlxTween.tween(PlayState, {health: 2}, 1);
		}
	}

	public var uhhTurnBackNormalOrSmth:Void->Void;

	public function setCameraPos(isDad, forcePos, ?camX, ?camY)
	{
		isCamForced = true;
		camFollow.setPosition(camX, camY);
	}

	private var isDead:Bool = false;

	inline private function deathCheck():Bool
	{
		if (health <= 0 && startedCountdown && !isDead)
		{
			boyfriend.stunned = true;
			paused = true;
			persistentUpdate = false;
			persistentDraw = false;

			resetMusic();

			deaths += 1;

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			FlxG.sound.play(Paths.sound('$assetModifier/fnf_loss_sfx'));

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
				// strumCameraRoll(strumline.receptors, ((strumline == bfStrums) ? true : false));
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

			if (bf_vocals != null)
				bf_vocals.volume = 1;

			if (strumline == dadStrums)
			{
				if (PlayState.opp_vocals != null)
					PlayState.opp_vocals.volume = 1;

				PlayStateUtils.instance.opponentNoteHit();
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

		for (i in 0...strumLines.length)
		{
			if (curStage == "theLoop" || curStage == "forestOld")
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
			var noteSplash:NoteSplash = EngineAssets.generateNoteSplashes(strumline, assetModifier, changeableSkin, noteType, noteData);
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

		rating = EngineAssets.generateRating(id, judgementsGroup, assetModifier, changeableSkin, 'UI');
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
			EngineTools.tweenJudgement(rating);
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

			timing = EngineAssets.generateTimings(ScoreUtils.judges[id].name, late, rating, judgementsGroup, assetModifier, changeableSkin, 'UI');
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
			EngineTools.tweenJudgement(timing);
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
			var numScore = EngineAssets.generateCombo('combo', comboGroup, stringArray[scoreInt], (!negative ? ScoreUtils.perfectCombo : false),
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
						ease: EngineTools.returnTweenEase(params[2]),
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

	public var dodged:Bool;
	public var shootin:Bool;

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

		PlayStateUtils.instance.stepHitEvents(curStep);

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

		if (boyfriend != null && curBeat % boyfriend.characterData.headBopSpeed == 0)
		{
			if (boyfriend.animation.curAnim.name.startsWith("idle") && !boyfriend.stunned || boyfriend.animation.curAnim.name.startsWith("dance") && !boyfriend.stunned)
				boyfriend.dance();
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

		if (generatedMusic && PlayState.SONG.notes[Std.int(curSection)] != null)
		{
			if (!shootin) checkCamPosition();
		}

		if (uiHUD != null && uiHUD.exists)
			uiHUD.beatHit(curBeat);
		if (spectraHUD != null && spectraHUD.exists)
			spectraHUD.beatHit(curBeat);
		if (psychHUD != null && psychHUD.exists)
			psychHUD.beatHit(curBeat);
		if (vanillaHUD != null && vanillaHUD.exists)
			vanillaHUD.beatHit(curBeat);
		if (kadeHUD != null && kadeHUD.exists)
			kadeHUD.beatHit(curBeat);
		if (cycledSinsHUD != null && cycledSinsHUD.exists)
			cycledSinsHUD.beatHit(curBeat);
		if (episode1HUD != null && episode1HUD.exists)
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

		// HARDCODED EVENTS HAVE MOVED TO PLAYSTATEUTILS.HX TO LOWER THE AMOUNT OF CODE IN THIS GOD FORSAKEN FILE AND TO MAKE IT LOOK MORE CLEAN
		PlayStateUtils.instance.beatHitEvents(curBeat);

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
		    if (!shootin) checkCamPosition();
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

	public function clearNotesBefore(time:Float)
	{
		var i:Int = notesGroup.length - 1;
		while (i >= 0)
		{
			var daNote:Note = notesGroup.members[i];
			if (daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notesGroup.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notesGroup.length - 1;
		while (i >= 0)
		{
			var daNote:Note = notesGroup.members[i];
			if (daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notesGroup.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
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
		paused = true;
	
			var filepath:String = Paths.video(name);
			if(!sys.FileSystem.exists(filepath))
			{
				FlxG.log.warn('Couldnt find video file: ' + name);
				startAndEnd();
				return;
			}
	
			var video:VideoHandler = new VideoHandler();
				#if (hxCodec >= "3.0.0")
				// Recent versions
				video.play(filepath);
				video.onEndReached.add(function()
				{
					video.dispose();
					startAndEnd();
					return;
				}, true);
				#else
				// Older versions
				video.playVideo(filepath);
				video.finishCallback = function()
				{
					startAndEnd();
					return;
				}
				#end
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
		canPause = false;

		var save:AutoSaveLogo = new AutoSaveLogo('autoSave', FlxG.width * 0.78, FlxG.height * 0.69);
		save.saveOnly();
		add(save);

		for (uis in allUIs)
			FlxTween.tween(uis, {alpha: 0}, 1, {ease: FlxEase.cubeOut});

		new FlxTimer().start(3, _ ->
		{
			save.fade(true);

			if (ignoreOffset || Init.trueSettings['Offset'] <= 0)
				onFinish();
			else
			{
				new FlxTimer().start(Init.trueSettings['Offset'] / 1000, function(offset:FlxTimer)
				{
					onFinish();
				});
			}
		});
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

		checkGameJoltAchievement();
		//
	}

	public function startAndEnd()
	{
		paused = false;
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	private function checkGameJoltAchievement():Void
	{
		switch (SONG.song.toLowerCase().replace('-', ' '))
		{
			case 'devilish deal':
				if (!GameJoltAPI.checkTrophy(193090))
					GameJoltAPI.getTrophy(193090);

			case 'delusional':
				if (!GameJoltAPI.checkTrophy(193091))
					GameJoltAPI.getTrophy(193091);
		}
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
			EngineTools.killMusic([songMusic, songMusicNew, bf_vocals, opp_vocals, vocals]);

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

		switch (SONG.song.toLowerCase().replace('-', ' '))
		{
			case 'cycled sins':
				FlxTween.tween(cycledSinsHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});

			case 'devilish deal' | 'isolated' | 'lunacy' | 'delusional' | 'delusion':
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
				case 'abandonedStreet' | 'forestNew' | 'smilesOffice':
					introGraphics.push(Paths.image('UI/funkinAVI/intro/$graphic'));
				case 'delusionalStreet':
					introGraphics.push(Paths.image('UI/funkinAVI/intro/satan-' + graphic));
				/*case 'waltRoom' | 'colorlessSight':
					introGraphics.push(Paths.image(EngineTools.returnSkinAsset('$graphic', 'walt', changeableSkin, 'UI'))); */
				case 'apartment' | 'relapseNew':
					introGraphics.push(Paths.image('UI/funkinAVI/intro/relapse-' + graphic));
				case 'forestOld' | 'theLoop':
					introGraphics.push(Paths.image('UI/funkinAVI/intro/$graphic'));
				case 'forbiddenRealm':
					introGraphics.push(Paths.image('UI/funkinAVI/intro/mal-' + graphic));
				default:
					introGraphics.push(Paths.image(EngineTools.returnSkinAsset('$graphic', assetModifier, changeableSkin, 'UI')));
			}
		}

		for (sound in introSoundNames)
		{
			switch (curStage)
			{
				case 'abandonedStreet' | 'forestNew' | 'smilesOffice' |  'forestOld' | 'theLoop':
						introSounds.push(Paths.sound('funkinAVI/countdownSounds/' + (SONG.song == 'Delusional' ? 'satan-' : '') + sound));
				/*case 'waltRoom' | 'colorlessSight':
						introSounds.push(Paths.sound('walt/$sound'));
					case 'apartment' | 'relapseNew':
						introSounds.push(Paths.sound('relapse/$sound')); */
				case 'forbiddenRealm':
					introSounds.push(Paths.sound('funkinAVI/countdownSounds/mal_' + sound));
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
			}
			else
			{
				if (introGraphics[countdownPos] != null)
				{
					var count:FlxSprite = new FlxSprite().loadGraphic(introGraphics[countdownPos]);
					count.scrollFactor.set();
					count.updateHitbox();

					if (assetModifier == 'pixel')
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
				if (psychHUD != null)
				{
					psychHUD.autoplayMark.visible = bfStrums.autoplay;
					psychHUD.scoreBar.visible = !bfStrums.autoplay;
				}

			case 'demolition': // demoliton HUD
				if (spectraHUD != null)
				{
					spectraHUD.autoplayMark.visible = bfStrums.autoplay;
					spectraHUD.scoreBar.visible = !bfStrums.autoplay;
				}

			default: // Engine HUD
				if (uiHUD != null)
				{
					uiHUD.autoplayMark.visible = bfStrums.autoplay;
					uiHUD.scoreBar.visible = !bfStrums.autoplay;
				}
		}

		return Init.trueSettings.get('HUD Style');
	}

	private function checkHUDS():ClassHUD
	{
		switch (Init.trueSettings.get('HUD Style').toLowerCase())
		{
			case 'psych': // psych engine fans gonna go nuts about this
			if (Init.trueSettings.get('HUD Style') == 'psych' && psychHUD != null) FlxTween.tween(psychHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});

			case 'spectra': // spectra HUD
			if (Init.trueSettings.get('HUD Style') == 'spectra' && spectraHUD != null) FlxTween.tween(spectraHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});
			
			case 'vanilla': // vanilla HUD
			if (Init.trueSettings.get('HUD Style') == 'vanilla' && vanillaHUD != null)	FlxTween.tween(vanillaHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});

			case 'kade': // Kade engine HUD
			if (Init.trueSettings.get('HUD Style') == 'kade' && kadeHUD != null)	FlxTween.tween(kadeHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});

			default: // Engine HUD
			if (Init.trueSettings.get('HUD Style') == 'classic' && uiHUD != null)	FlxTween.tween(uiHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000, {startDelay: (Conductor.crochet / 1000)});
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
				GameData.completeEpisode();
				Main.switchState(this, new StoryMenu());
				EngineTools.resetMenuMusic();
				clearStored = true;
			case FREEPLAY:
				GameData.completeFPSong();
				switch (CoolUtil.dashToSpace(SONG.song))
				{
					case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional' | 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus' | 'Mercy' | 'Affliction':
						states.menus.freeplay.FreeplaySongs.freeplayMenuList = 0;
						Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
					default:
						if (PlayState.SONG.song.endsWith('Legacy')) // me when StringTools optimizes the code
						{
							states.menus.freeplay.FreeplaySongs.freeplayMenuList = 2;
							Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
						}
						else
						{
							states.menus.freeplay.FreeplaySongs.freeplayMenuList = 1;
							Main.switchState(this,
								new states.menus.freeplay.FreeplaySongs()); // yeah, there's no way I'm making a case for EVERY fucking song in that menu, too much work!
						}
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

		#if VIDEO_PLUGIN
		// gonna be useful someday
		setVar('playVideoCutscene', function(video:String, isEnd:Bool = false)
		{
			@:privateAccess
			CutsceneState.playCutscene(video);
		});
		#end

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