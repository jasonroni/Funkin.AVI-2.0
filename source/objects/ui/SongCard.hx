package objects.ui;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import sys.FileSystem;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.group.FlxSpriteGroup;
import states.PlayState;

using flixel.util.FlxSpriteUtil;

class SongCard extends FlxSpriteGroup
{
  // Pre-made Text
  public var composer:String = PlayState.SONG.composer;
  public var songTitle:String = PlayState.SONG.song;
  
  // Files to look for
  public var directory = 'menus/Funkin_avi/card/${songTitle}';
  public var pathFinder = Paths.image(directory);
  public var fontStuff:String = "vcr";
    
  // Base Card Setup
  public var cardTxt:FlxText;
  public var cardSprite:FlxSprite;
  
  // A bit of Decoration
  public var musicNoteIcon:FlxSprite;
  
  // Health Icons
  public var opponentIcon:HealthIcon;
  public var playerIcon:HealthIcon;
  
  // For Special Anims or Effects
  public var isMalfunction:Bool = false;
  public var isBirthday:Bool = false;
  public var isCross:Bool = false;
  
  function setupFonts()
  {
    switch (PlayState.SONG.song)
    {
        case 'Isolated' | 'Lunacy' | 'Hunted' | 'Hunted Legacy' | "Isolated Legacy" | 'Lunacy Legacy' | 'Delusional Legacy':
          fontStuff = "DisneyFont";
        case 'Delusional':
          fontStuff = "satanFont";
        case 'Bless':
          fontStuff = "MagicOwlFont";
        case "Don't Cross!":
          fontStuff = "PhantomMuff Full Letters 1.1.5";
        case 'Cycled Sins' | 'Cycled Sins Legacy':
          fontStuff = "calibri-regular";
        case 'Mercy' | 'Mercy Legacy':
          fontStuff = "splatter";
        case 'Malfunction':
          fontStuff = "m40";
        default: 
          fontStuff = "vcr";
    }
  }
  
  public function new()
  {
    super();
    
    setupFonts();
    
    if (!FileSystem.exists(pathFinder))
      cardSprite = new FlxSprite().makeGraphic(450, 600, FlxColor.BLACK);
    else
      cardSprite = new FlxSprite().loadGraphic(Paths.image(directory));
    
    cardSprite.alpha = 0.001;
    cardSprite.screenCenter();
    cardSprite.cameras = [PlayState.camHUD];
    
    cardTxt = new FlxText(cardSprite.x, cardSprite.y, 0, '${songTitle}/n${composer}');
    cardTxt.setFormat(Paths.font(fontStuff), 30, FlxColor.WHITE);
    cardTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    cardTxt.alpha = 0.001;
    cardTxt.cameras = [PlayState.camHUD];
    
    opponentIcon = new HealthIcon(PlayState.opponent.characterData.icon, false);
    opponentIcon.animation.curAnim.curFrame = 2;
    opponentIcon.x = cardSprite.x - 150;
    opponentIcon.y = cardSprite.y - 200;
    opponentIcon.alpha = 0.001;
    
    playerIcon = new HealthIcon(PlayState.boyfriend.characterData.icon, true);
    playerIcon.animation.curAnim.curFrame = 2;
    playerIcon.x = cardSprite.x + 150;
    playerIcon.y = cardSprite.y + 200;
    playerIcon.alpha = 0.001;
    
    add(cardSprite);
    add(cardTxt);
    add(opponentIcon);
    add(playerIcon);
  }
  
  override function add(Object:FlxSprite):FlxSprite
	{
		if (Std.isOfType(Object, FlxText))
			cast(Object, FlxText).antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		if (Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		return super.add(Object);
	}
}
