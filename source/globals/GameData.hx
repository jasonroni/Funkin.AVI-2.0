package globals;

import flixel.FlxG;
import flixel.util.FlxSave;
import states.PlayState;

private enum DATA_CHECK_TYPE
{
	NO_MALFUNCTION;
	ALL;
}

/**
 * **lmao you ain't gonna play malfunction so easly**.
 * 
 *  Anyways the data thing which is useful for stuff such like:
 * - the birthday song been in the extras section after beating it
 * - progression for cool ass stuff
 * - etc
 * 
 * Also this is like the [**Psych Engine ClientPrefs file**](https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/ClientPrefs.hx),
 * 
 * but with game data instead of option data (that one is on **Init** file and some others)
 */
class GameData
{
	// Progression Shit
	public static var episode1FPLock:String = 'locked';

	public static var episodeSFPLock:String = 'locked';
	public static var episodeWFPLock:String = 'locked';

	// Alters the icons in freeplay
	public static var huntedLock:String = 'locked';
	public static var oldisolateLock:String = 'locked';
	public static var betaisolateLock:String = 'locked';
	public static var malfunctionLock:String = 'locked';
	public static var blessLock:String = 'locked';
	public static var scrappedLock:String = 'locked';
	public static var sinsLock:String = 'locked';
	public static var warLock:String = 'locked';
	public static var crossinLock:String = 'locked';
	public static var mercyLock:String = 'locked';
	public static var pnmLock:String = 'locked';
	public static var rickyLock:String = 'locked';

	public static var legacyILock:String = 'locked'; // Isolated
	public static var legacyLLock:String = 'locked'; // Lunacy
	public static var legacyDLock:String = 'locked'; // Delusional
	public static var legacyHLock:String = 'locked'; // Hunted
	public static var legacyMLock:String = 'locked'; // Malfunction
	public static var legacyWLock:String = 'locked'; // Mercy
	public static var legacyBLock:String = 'locked'; // Bless
	public static var legacyNLock:String = 'locked'; // Neglection
	public static var legacySLock:String = 'locked'; // Cycled Sins
	public static var legacyTLock:String = 'locked'; // Twisted Grins
	public static var legacyRLock:String = 'locked'; // Resentment

	// Gamejolt Stuff
	public static var GJ_username:String = "";
	public static var GJ_token:String = "";

	// Warning Screen
	public static var hasSeenWarning:Bool = false;

	// Hidden Songs
	public static var canAddMalfunction:Bool = false;
	public static var muckneyLock:String = "uncompleted";
	public static var highOnCrackLock:String = "undiscovered";

	public static function lockinIt():Void
	{
		FlxG.save.bind("gameProgression", CoolUtil.getSavePath());

		if (FlxG.save.data.episode1FPLock == null)
			FlxG.save.data.episode1FPLock = 'locked';

		if (FlxG.save.data.episodeSFPLock == null)
			FlxG.save.data.episodeSFPLock = 'locked';
		if (FlxG.save.data.episodeWFPLock == null)
			FlxG.save.data.episodeWFPLock = 'locked';

		if (FlxG.save.data.huntedLock == null)
			FlxG.save.data.huntedLock = 'locked';
		if (FlxG.save.data.oldisolateLock == null)
			FlxG.save.data.oldisolateLock = 'locked';
		if (FlxG.save.data.betaisolateLock == null)
			FlxG.save.data.betaisolateLock = 'locked';
		if (FlxG.save.data.malfunctionLock == null)
			FlxG.save.data.malfunctionLock = 'locked';
		if (FlxG.save.data.blessLock == null)
			FlxG.save.data.blessLock = 'locked';
		if (FlxG.save.data.scrappedLock == null)
			FlxG.save.data.scrappedLock = 'locked';
		if (FlxG.save.data.sinsLock == null)
			FlxG.save.data.sinsLock = 'locked';
		if (FlxG.save.data.warLock == null)
			FlxG.save.data.warLock = 'locked';
		if (FlxG.save.data.crossinLock == null)
			FlxG.save.data.crossinLock = 'locked';
		if (FlxG.save.data.mercyLock == null)
			FlxG.save.data.mercyLock = 'locked';
		if (FlxG.save.data.pnmLock == null)
			FlxG.save.data.pnmLock = 'locked';
		if (FlxG.save.data.rickyLock == null)
			FlxG.save.data.rickyLock = 'locked';

		if (FlxG.save.data.gjUser == null)
			FlxG.save.data.gjUser = "";
		if (FlxG.save.data.gjToken == null)
			FlxG.save.data.gjToken = "";

		if (FlxG.save.data.hasSeenWarning == null)
			FlxG.save.data.hasSeenWarning = false;

		if (FlxG.save.data.legacyILock == null)
			FlxG.save.data.legacyILock = 'locked';
		if (FlxG.save.data.legacyLLock == null)
			FlxG.save.data.legacyLLock = 'locked';
		if (FlxG.save.data.legacyDLock == null)
			FlxG.save.data.legacyDLock = 'locked';
		if (FlxG.save.data.legacyHLock == null)
			FlxG.save.data.legacyHLock = 'locked';
		if (FlxG.save.data.legacyMLock == null)
			FlxG.save.data.legacyMLock = 'locked';
		if (FlxG.save.data.legacyWLock == null)
			FlxG.save.data.legacyWLock = 'locked';
		if (FlxG.save.data.legacyBLock == null)
			FlxG.save.data.legacyBLock = 'locked';
		if (FlxG.save.data.legacySLock == null)
			FlxG.save.data.legacySLock = 'locked';
		if (FlxG.save.data.legacyNLock == null)
			FlxG.save.data.legacyNLock = 'locked';
		if (FlxG.save.data.legacyTLock == null)
			FlxG.save.data.legacyYLock = 'locked';
		if (FlxG.save.data.legacyRLock == null)
			FlxG.save.data.legacyRLock = 'locked';

		if (FlxG.save.data.canAddMalfunction == null)
			FlxG.save.data.canAddMalfunction = false;
		if (FlxG.save.data.muckneyLock == null)
			FlxG.save.data.muckneyLock = "uncompleted";
		if (FlxG.save.data.highOnCrackLock == null)
			FlxG.save.data.highOnCrackLock = "undiscovered";

		FlxG.save.flush();
	}

	public static function saveShit():Void
	{
		FlxG.save.bind("gameProgression", CoolUtil.getSavePath());
		trace('saving data');

		FlxG.save.data.episode1FPLock = episode1FPLock;

		FlxG.save.data.episodeSFPLock = episodeSFPLock;
		FlxG.save.data.episodeWFPLock = episodeWFPLock;

		FlxG.save.data.huntedLock = huntedLock;
		FlxG.save.data.oldisolateLock = oldisolateLock;
		FlxG.save.data.betaisolateLock = betaisolateLock;
		FlxG.save.data.malfunctionLock = malfunctionLock;
		FlxG.save.data.blessLock = blessLock;
		FlxG.save.data.scrappedLock = scrappedLock;
		FlxG.save.data.sinsLock = sinsLock;
		FlxG.save.data.warLock = warLock;
		FlxG.save.data.crossinLock = crossinLock;
		FlxG.save.data.mercyLock = mercyLock;
		FlxG.save.data.pnmLock = pnmLock;
		FlxG.save.data.rickyLock = rickyLock;

		FlxG.save.data.legacyILock = legacyILock;
		FlxG.save.data.legacyLLock = legacyLLock;
		FlxG.save.data.legacyDLock = legacyDLock;
		FlxG.save.data.legacyHLock = legacyHLock;
		FlxG.save.data.legacyMLock = legacyMLock;
		FlxG.save.data.legacyWLock = legacyWLock;
		FlxG.save.data.legacyBLock = legacyBLock;
		FlxG.save.data.legacySLock = legacySLock;
		FlxG.save.data.legacyNLock = legacyNLock;
		FlxG.save.data.legacyTLock = legacyTLock;
		FlxG.save.data.legacyRLock = legacyRLock;

		FlxG.save.data.gjUser = GJ_username;
		FlxG.save.data.gjToken = GJ_token;

		FlxG.save.data.hasSeenWarning = hasSeenWarning;

		FlxG.save.data.canAddMalfunction = canAddMalfunction;
		FlxG.save.data.muckneyLock = muckneyLock;
		FlxG.save.data.highOnCrackLock = highOnCrackLock;

		FlxG.save.flush();
	}

	public static function loadShit():Void
	{
		FlxG.save.bind("gameProgression", CoolUtil.getSavePath());

		trace('loading data');

		episode1FPLock = FlxG.save.data.episode1FPLock;

		episodeSFPLock = FlxG.save.data.episodeSFPLock;
		episodeWFPLock = FlxG.save.data.episodeWFPLock;

		huntedLock = FlxG.save.data.huntedLock;
		oldisolateLock = FlxG.save.data.oldisolateLock;
		betaisolateLock = FlxG.save.data.betaisolateLock;
		malfunctionLock = FlxG.save.data.malfunctionLock;
		blessLock = FlxG.save.data.blessLock;
		scrappedLock = FlxG.save.data.scrappedLock;
		sinsLock = FlxG.save.data.sinsLock;
		warLock = FlxG.save.data.warLock;
		crossinLock = FlxG.save.data.crossinLock;
		mercyLock = FlxG.save.data.mercyLock;
		pnmLock = FlxG.save.data.pnmLock;
		rickyLock = FlxG.save.data.rickyLock;

		legacyILock = FlxG.save.data.legacyILock;
		legacyLLock = FlxG.save.data.legacyLLock;
		legacyDLock = FlxG.save.data.legacyDLock;
		legacyHLock = FlxG.save.data.legacyHLock;
		legacyMLock = FlxG.save.data.legacyMLock;
		legacyWLock = FlxG.save.data.legacyWLock;
		legacyBLock = FlxG.save.data.legacyBLock;
		legacySLock = FlxG.save.data.legacySLock;
		legacyNLock = FlxG.save.data.legacyNLock;
		legacyTLock = FlxG.save.data.legacyTLock;
		legacyRLock = FlxG.save.data.legacyRLock;

		GJ_username = FlxG.save.data.gjUser;
		GJ_token = FlxG.save.data.gjToken;

		hasSeenWarning = FlxG.save.data.hasSeenWarning;

		canAddMalfunction = FlxG.save.data.canAddMalfunction;
		muckneyLock = FlxG.save.data.muckneyLock;
		highOnCrackLock = FlxG.save.data.highOnCrackLock;

		saveShit();
	}

	public static function unlockEverything():Void
	{
		FlxG.save.bind("gameProgression", CoolUtil.getSavePath());

		episode1FPLock = 'unlocked';

		episodeSFPLock = 'unlocked';
		episodeWFPLock = 'unlocked';

		huntedLock = 'beaten';
		oldisolateLock = 'beaten';
		betaisolateLock = 'beaten';
		malfunctionLock = 'beaten';
		blessLock = 'beaten';
		scrappedLock = 'beaten';
		sinsLock = 'beaten';
		warLock = 'beaten';
		crossinLock = 'beaten';
		mercyLock = 'beaten';
		pnmLock = 'beaten';
		rickyLock = 'beaten';

		legacyILock = 'beaten';
		legacyLLock = 'beaten';
		legacyDLock = 'beaten';
		legacyHLock = 'beaten';
		legacyMLock = 'beaten';
		legacyWLock = 'beaten';
		legacyBLock = 'beaten';
		legacySLock = 'beaten';
		legacyNLock = 'beaten';
		legacyTLock = 'beaten';
		legacyRLock = 'beaten';

		canAddMalfunction = true;
		muckneyLock = 'beaten';
		highOnCrackLock = 'completed';

		saveShit();
	}

	public static function setFreeplayData()
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'hunted':
				if (FlxG.save.data.huntedLock != 'beaten')
					huntedLock = 'unlocked';
			case 'isolated old':
				if (FlxG.save.data.oldisolateLock != 'beaten')
					oldisolateLock = 'unlocked';
			case 'isolated beta':
				if (FlxG.save.data.betaisolateLock != 'beaten')
					betaisolateLock = 'unlocked';
			case 'neglection':
				if (FlxG.save.data.pnmLock != 'beaten')
					pnmLock = 'unlocked';
			case "don't cross!":
				if (FlxG.save.data.crossinLock != 'beaten')
					crossinLock = 'unlocked';
			case 'war dilemma':
				if (FlxG.save.data.warLock != 'beaten')
					warLock = 'unlocked';
			case 'cycled sins':
				if (FlxG.save.data.sinsLock != 'beaten')
					sinsLock = 'unlocked';
			case 'malfunction':
				if (FlxG.save.data.malfunctionLock != 'beaten')
					malfunctionLock = 'unlocked';
			case 'scrapped':
				if (FlxG.save.data.scrappedLock != 'beaten')
					scrappedLock = 'unlocked';
			case 'bless':
				if (FlxG.save.data.blessLock != 'beaten')
					blessLock = 'unlocked';
			case 'laugh track':
				if (FlxG.save.data.rickyLock != 'beaten')
					rickyLock = 'unlocked';
			case 'birthday':
				if (FlxG.save.data.muckneyLock != 'beaten')
					muckneyLock = "voidIsOpen";
			case 'mercy legacy':
				if (FlxG.save.data.legacyWLock != 'beaten')
					legacyWLock = 'unlocked';
			case 'isolated legacy':
				if (FlxG.save.data.legacyILock != 'beaten')
					legacyILock = 'unlocked';
			case 'lunacy legacy':
				if (FlxG.save.data.legacyLLock != 'beaten')
					legacyLLock = 'unlocked';
			case 'delusional legacy':
				if (FlxG.save.data.legacyDLock != 'beaten')
					legacyDLock = 'unlocked';
			case 'hunted legacy':
				if (FlxG.save.data.legacyHLock != 'beaten')
					legacyHLock = 'unlocked';
			case 'malfunction legacy':
				if (FlxG.save.data.legacyMLock != 'beaten')
					legacyMLock = 'unlocked';
			case 'cycled sins legacy':
				if (FlxG.save.data.legacySLock != 'beaten')
					legacySLock = 'unlocked';
			case 'bless legacy':
				if (FlxG.save.data.legacyBLock != 'beaten')
					legacyBLock = 'unlocked';
			case 'twisted grins legacy':
				if (FlxG.save.data.legacyTLock != 'beaten')
					legacyTLock = 'unlocked';
			case 'neglection legacy':
				if (FlxG.save.data.legacyNLock != 'beaten')
					legacyNLock = 'unlocked';
			case 'resentment legacy':
				if (FlxG.save.data.legacyRLock != 'beaten')
					legacyRLock = 'unlocked';
			case 'delutrance':
				if (FlxG.save.data.highOnCrackLock != 'completed')
					highOnCrackLock = 'forceBackToSong';
		}
		saveShit();
	}

	public static function completeFPSong()
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'hunted':
				if (!Init.trueSettings.get("Disable Mechanics"))
					huntedLock = 'beaten';
			case 'isolated old':
				oldisolateLock = 'beaten';
			case 'isolated beta':
				betaisolateLock = 'beaten';
			case 'neglection':
				pnmLock = 'beaten';
			case "don't cross!":
				if (!Init.trueSettings.get("Disable Mechanics"))
					crossinLock = 'beaten';
			case 'war dilemma':
				warLock = 'beaten';
			case 'cycled sins':
				if (!Init.trueSettings.get("Disable Mechanics"))
					sinsLock = 'beaten';
			case 'malfunction':
				malfunctionLock = 'beaten';
			case 'scrapped':
				scrappedLock = 'beaten';
			case 'bless':
				blessLock = 'beaten';
			case 'laugh track':
				rickyLock = 'beaten';
			case 'birthday':
				muckneyLock = 'beaten';
			case 'mercy legacy':
				if (!Init.trueSettings.get("Disable Mechanics"))
					legacyWLock = 'beaten';
			case 'isolated legacy':
				legacyILock = 'beaten';
			case 'lunacy legacy':
				legacyLLock = 'beaten';
			case 'delusional legacy':
				legacyDLock = 'beaten';
			case 'hunted legacy':
				legacyHLock = 'beaten';
			case 'malfunction legacy':
				legacyMLock = 'beaten';
			case 'cycled sins legacy':
				if (!Init.trueSettings.get("Disable Mechanics"))
					legacySLock = 'beaten';
			case 'bless legacy':
				legacyBLock = 'beaten';
			case 'neglection legacy':
				if (!Init.trueSettings.get("Disable Mechanics"))
					legacyNLock = 'beaten';
			case 'twisted grins legacy':
				legacyTLock = 'beaten';
			case 'resentment legacy':
				legacyRLock = 'beaten';
			case 'delutrance':
				highOnCrackLock = 'completed';
		}
		saveShit();
	}

	public static function check(type:DATA_CHECK_TYPE):Dynamic
	{
		switch (type)
		{
			case NO_MALFUNCTION:
				return (GameData.huntedLock == 'beaten'
					&& GameData.oldisolateLock == 'beaten'
					&& GameData.betaisolateLock == 'beaten'
					&& GameData.rickyLock == 'beaten'
					&& GameData.blessLock == 'beaten'
					&& GameData.scrappedLock == 'beaten'
					&& GameData.crossinLock == 'beaten'
					&& GameData.warLock == 'beaten'
					&& GameData.pnmLock == 'beaten'
					&& GameData.sinsLock == 'beaten'
					&& GameData.legacyILock == 'beaten'
					&& GameData.legacyLLock == 'beaten'
					&& GameData.legacyDLock == 'beaten'
					&& GameData.legacyHLock == 'beaten'
					&& GameData.legacyWLock == 'beaten'
					&& GameData.legacySLock == 'beaten'
					&& !GameData.canAddMalfunction);

			case ALL:
				return (GameData.huntedLock == 'beaten'
					&& GameData.oldisolateLock == 'beaten'
					&& GameData.betaisolateLock == 'beaten'
					&& GameData.rickyLock == 'beaten'
					&& GameData.blessLock == 'beaten'
					&& GameData.scrappedLock == 'beaten'
					&& GameData.crossinLock == 'beaten'
					&& GameData.warLock == 'beaten'
					&& GameData.pnmLock == 'beaten'
					&& GameData.sinsLock == 'beaten'
					&& GameData.legacyILock == 'beaten'
					&& GameData.legacyLLock == 'beaten'
					&& GameData.legacyDLock == 'beaten'
					&& GameData.legacyHLock == 'beaten'
					&& GameData.legacyWLock == 'beaten'
					&& GameData.legacySLock == 'beaten'
					&& GameData.canAddMalfunction);
		}

		// tragic
		return false;
	}

	public static function completeEpisode()
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'delusional':
				episode1FPLock = 'unlocked';
			case 'mortiferum risus':
				episodeSFPLock = 'unlocked';
			case 'affliction':
				if (!Init.trueSettings.get("Disable Mechanics"))
					episodeWFPLock = 'unlocked';
		}
		saveShit();
	}
}
