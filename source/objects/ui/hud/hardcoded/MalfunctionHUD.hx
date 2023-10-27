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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import states.PlayState;

class MalfunctionHUD extends FlxSpriteGroup
{
  // Health Bar
  public var healthBarBG:FlxSprite;
  public var healthBar:FlxBar;
  
  // NEW Life System Bar
  public var lifeCounterBar:FlxBar;
  public var lifeCunderBarBG:FlxSprite;

  // Text Setup
  public var scoreTxt:FlxText;
  public var watermarkTxt:FlxText;
  public var autoplayTxt:FlxText;
  public var songTxt:FlxText;
  
  // Icons
  public var iconP1:HealthIcon;
  public var iconP2:HealthIcon;
  
  // Other
  public var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop'; // fnf mods
  public var autoplaySine:Float = 0;
  public var timingsMap:Map<String, FlxText> = [];

  // Display Texts
  public var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song);
  public var diffDisplay:String = '[-MISSING_ASSETS_OR_COULD_NOT_LOAD_PROPERLY-]';
  public var engineDisplay:String = '<ERROR_110>';

  override function create()
  {
      
  }
}
