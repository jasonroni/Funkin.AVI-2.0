package objects.ui.hud.hardcoded;

import base.utils.ScoreUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import states.PlayState;

class Episode1HUD extends FlxSpriteGroup
{
  // Health Bar
  var fancyBarOverlay:FlxSprite;
  var healthBarBG:FlxSprite;
  var healthBar:FlxBar;

  // Text Setup
  var scoreTxt:FlxText;
  var watermarkTxt:FlxText;
  var autoplayTxt:FlxText;
  var songTxt:FlxText;
  
  // Icons
  var iconP1:HealthIcon;
  var iconP2:HealthIcon;
  
  // Icons for Modchart Reasons
  var demonBFIcon:HealthIcon;
  var lunacyIcon:HealthIcon;
  var delusionalIcon:HealthIcon;
  
  // Lunacy Mechanic?????
  var disguiseFailCheck:Bool = false;
  var disguiseBar:FlxBar;
  var disguiseBarBG:FlxSprite;
  var disguiseBarOverlay:FlxSprite;
  
  // Other
	public var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop'; // fnf mods
	public var autoplaySine:Float = 0;
	public var timingsMap:Map<String, FlxText> = [];

	// Display Texts
	public var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song);
	public var diffDisplay:String = '[${CoolUtil.difficultyString}]';
	public var engineDisplay:String = 'FOREVER ENGINE v0.3.1';
}
