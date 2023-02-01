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
    public static var episode1FPLock:String = 'locked';
    public static var episode2FPLock:String = 'locked';

    public static var huntedLock:String = 'locked';
    public static var oldisolateLock:String = 'locked';
    public static var betaisolateLock:String = 'locked';
    public static var malfunctionLock:String = 'locked';
    public static var revengeLock:String = 'locked';
    public static var blessLock:String = 'locked';
    public static var scrappedLock:String = 'locked';
    public static var sinsLock:String = 'locked';
    public static var warLock:String = 'locked';
    public static var crossinLock:String = 'locked';
    public static var mercyLock:String = 'locked';
    public static var pnmLock:String = 'locked';
    public static var rbLock:String = 'locked';
    public static var muckneyLock:String = "uncompleted";

    public static function lockinIt() {
   
        if (FlxG.save.data.episode1FPLock == null) FlxG.save.data.episode1FPLock = 'locked';
        if (FlxG.save.data.episode2FPLock == null) FlxG.save.data.episode2FPLock = 'locked';

        if (FlxG.save.data.huntedLock == null) FlxG.save.data.huntedLock = 'locked';
        if (FlxG.save.data.oldisolateLock == null) FlxG.save.data.oldisolateLock = 'locked';
        if (FlxG.save.data.betaisolateLock == null) FlxG.save.data.betaisolateLock = 'locked';
        if (FlxG.save.data.malfunctionLock == null) FlxG.save.data.malfunctionLock = 'locked';
        if (FlxG.save.data.revengeLock == null) FlxG.save.data.revengeLock = 'locked';
        if (FlxG.save.data.blessLock == null) FlxG.save.data.blessLock = 'locked';
        if (FlxG.save.data.scrappedLock == null) FlxG.save.data.scrappedLock = 'locked';
        if (FlxG.save.data.sinsLock == null) FlxG.save.data.sinsLock = 'locked';
        if (FlxG.save.data.warLock == null) FlxG.save.data.warLock = 'locked';
        if (FlxG.save.data.crossinLock == null) FlxG.save.data.crossinLock = 'locked';
        if (FlxG.save.data.mercyLock == null) FlxG.save.data.mercyLock = 'locked';
        if (FlxG.save.data.pnmLock == null) FlxG.save.data.pnmLock = 'locked';
        if (FlxG.save.data.rbLock == null) FlxG.save.data.rbLock = 'locked';
        if (FlxG.save.data.muckneyLock == null) FlxG.save.data.muckneyLock = "uncompleted";
        FlxG.save.flush();
    }

    public static function saveShit() {
        
        FlxG.save.data.episode1FPLock = episode1FPLock;
        FlxG.save.data.episode2FPLock = episode2FPLock;

        FlxG.save.data.huntedLock = huntedLock;
        FlxG.save.data.oldisolateLock = oldisolateLock;
        FlxG.save.data.betaisolateLock = betaisolateLock;
        FlxG.save.data.malfunctionLock = malfunctionLock;
        FlxG.save.data.revengeLock = revengeLock;
        FlxG.save.data.blessLock = blessLock;
        FlxG.save.data.scrappedLock = scrappedLock;
        FlxG.save.data.sinsLock = sinsLock;
        FlxG.save.data.warLock = warLock;
        FlxG.save.data.crossinLock = crossinLock;
        FlxG.save.data.mercyLock = mercyLock;
        FlxG.save.data.pnmLock = pnmLock;
        FlxG.save.data.rbLock = rbLock;
        FlxG.save.data.muckneyLock = muckneyLock;

        FlxG.save.flush();

		/*var save:FlxSave = new FlxSave();
		save.bind('Game_data', CoolUtil.getSavePath()); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.flush();
		FlxG.log.add("Settings saved!");
        trace('Setting saved!', {fileName: 'GameData', lineNumber: 102});*/
    }

    public static function loadShit() {

        episode1FPLock = FlxG.save.data.episode1FPLock;
        episode2FPLock = FlxG.save.data.episode2FPLock;

        huntedLock = FlxG.save.data.huntedLock;
        oldisolateLock = FlxG.save.data.oldisolateLock;
        betaisolateLock = FlxG.save.data.betaisolateLock;
        malfunctionLock = FlxG.save.data.malfunctionLock;
        revengeLock = FlxG.save.data.revengeLock;
        blessLock = FlxG.save.data.blessLock;
        scrappedLock = FlxG.save.data.scrappedLock;
        sinsLock = FlxG.save.data.sinsLock;
        warLock = FlxG.save.data.warLock;
        crossinLock = FlxG.save.data.crossinLock;
        mercyLock = FlxG.save.data.mercyLock;
        pnmLock = FlxG.save.data.pnmLock;
        rbLock = FlxG.save.data.rbLock;
        muckneyLock = FlxG.save.data.muckneyLock;
        FlxG.save.flush();
    }
}
