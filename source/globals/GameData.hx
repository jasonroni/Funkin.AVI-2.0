package globals;

import flixel.FlxG;
import flixel.util.FlxSave;

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
	
    public static var legacyILock:String = 'locked'; //Isolated
    public static var legacyLLock:String = 'locked'; //Lunacy
    public static var legacyDLock:String = 'locked'; //Delusional
    public static var legacyHLock:String = 'locked'; //Hunted
    public static var legacyMLock:String = 'locked'; //Malfunction
    public static var legacyWLock:String = 'locked'; //Mercy
    public static var legacyBLock:String = 'locked'; //Bless
    public static var legacyNLock:String = 'locked'; //Neglection
    public static var legacySLock:String = 'locked'; //Cycled Sins
    public static var legacyTLock:String = 'locked'; //Twisted Grins
    public static var legacyRLock:String = 'locked'; //Resentment

    // Gamejolt Stuff
    public static var GJ_username:String = "";
    public static var GJ_token:String = "";
	
    // Warning Screen
    public static var hasSeenWarning:Bool = false;
	
    // Hidden Songs
    public static var canAddMalfunction:Bool = false;
    public static var muckneyLock:String = "uncompleted";
    public static var highOnCrackLock:String = "undiscovered";

    public static function lockinIt():Void {
        FlxG.save.bind("gameProgression", CoolUtil.getSavePath());

        if (FlxG.save.data.episode1FPLock == null) FlxG.save.data.episode1FPLock = 'locked';
	    
        if (FlxG.save.data.episodeSFPLock == null) FlxG.save.data.episodeSFPLock = 'locked';
	if (FlxG.save.data.episodeWFPLock == null) FlxG.save.data.episodeWFPLock = 'locked';

        if (FlxG.save.data.huntedLock == null) FlxG.save.data.huntedLock = 'locked';
        if (FlxG.save.data.oldisolateLock == null) FlxG.save.data.oldisolateLock = 'locked';
        if (FlxG.save.data.betaisolateLock == null) FlxG.save.data.betaisolateLock = 'locked';
        if (FlxG.save.data.malfunctionLock == null) FlxG.save.data.malfunctionLock = 'locked';
        if (FlxG.save.data.blessLock == null) FlxG.save.data.blessLock = 'locked';
        if (FlxG.save.data.scrappedLock == null) FlxG.save.data.scrappedLock = 'locked';
        if (FlxG.save.data.sinsLock == null) FlxG.save.data.sinsLock = 'locked';
        if (FlxG.save.data.warLock == null) FlxG.save.data.warLock = 'locked';
        if (FlxG.save.data.crossinLock == null) FlxG.save.data.crossinLock = 'locked';
        if (FlxG.save.data.mercyLock == null) FlxG.save.data.mercyLock = 'locked';
        if (FlxG.save.data.pnmLock == null) FlxG.save.data.pnmLock = 'locked';
        if (FlxG.save.data.rickyLock == null) FlxG.save.data.rickyLock = 'locked';

        if(FlxG.save.data.gjUser == null) FlxG.save.data.gjUser = "";
        if(FlxG.save.data.gjToken == null) FlxG.save.data.gjToken = "";
	    
	if (FlxG.save.data.hasSeenWarning == null) FlxG.save.data.hasSeenWarning = false;
	    
	if (FlxG.save.data.legacyILock == null) FlxG.save.data.legacyILock = 'locked';
	if (FlxG.save.data.legacyLLock == null) FlxG.save.data.legacyLLock = 'locked';
	if (FlxG.save.data.legacyDLock == null) FlxG.save.data.legacyDLock = 'locked';
	if (FlxG.save.data.legacyHLock == null) FlxG.save.data.legacyHLock = 'locked';
	if (FlxG.save.data.legacyMLock == null) FlxG.save.data.legacyMLock = 'locked';
	if (FlxG.save.data.legacyWLock == null) FlxG.save.data.legacyWLock = 'locked';
	if (FlxG.save.data.legacyBLock == null) FlxG.save.data.legacyBLock = 'locked';
	if (FlxG.save.data.legacySLock == null) FlxG.save.data.legacySLock = 'locked';
	if (FlxG.save.data.legacyNLock == null) FlxG.save.data.legacyNLock = 'locked';
	if (FlxG.save.data.legacyTLock == null) FlxG.save.data.legacyYLock = 'locked';
	if (FlxG.save.data.legacyRLock == null) FlxG.save.data.legacyRLock = 'locked';
	    
	if (FlxG.save.data.canAddMalfunction == null) FlxG.save.data.canAddMalfunction = false;
	if (FlxG.save.data.muckneyLock == null) FlxG.save.data.muckneyLock = "uncompleted";
	if (FlxG.save.data.highOnCrackLock == null) FlxG.save.data.highOnCrackLock = "undiscovered";   
        
        FlxG.save.flush();
    }

    public static function saveShit():Void {
        FlxG.save.bind("gameProgression", CoolUtil.getSavePath());
        
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

    public static function loadShit():Void {
        FlxG.save.bind("gameProgression", CoolUtil.getSavePath());

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
	    
	//GJ_username = FlxG.save.data.gjUser;
	//GJ_token = FlxG.save.data.gjToken;
	    
	hasSeenWarning = FlxG.save.data.hasSeenWarning;
	    
	canAddMalfunction = FlxG.save.data.canAddMalfunction;
        muckneyLock = FlxG.save.data.muckneyLock;
        highOnCrackLock = FlxG.save.data.highOnCrackLock;
	    
        saveShit();
    }
}
