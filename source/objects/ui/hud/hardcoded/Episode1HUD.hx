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
  public var fancyBarOverlay:FlxSprite;
  public var healthBarBG:FlxSprite;
  public var healthBar:FlxBar;

  // Text Setup
  public var scoreTxt:FlxText;
  public var watermarkTxt:FlxText;
  public var autoplayTxt:FlxText;
  public var songTxt:FlxText;
  
  // Icons
  public var iconP1:HealthIcon;
  public var iconP2:HealthIcon;
  
  // Icons for Modchart Reasons
  public var demonBFIcon:HealthIcon;
  public var lunacyIcon:HealthIcon;
  public var delusionalIcon:HealthIcon;
  
  // Lunacy Mechanic?????
  public var disguiseFailCheck:Bool = false;
  public var disguiseBar:FlxBar;
  public var disguiseBarBG:FlxSprite;
  public var disguiseBarOverlay:FlxSprite;
  
  // Other
  public var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop'; // fnf mods
  public var autoplaySine:Float = 0;
  public var timingsMap:Map<String, FlxText> = [];

  // Display Texts
  public var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song);
  public var diffDisplay:String = '[${CoolUtil.difficultyString}]';
  public var engineDisplay:String = 'FOREVER ENGINE v0.3.1';
}
