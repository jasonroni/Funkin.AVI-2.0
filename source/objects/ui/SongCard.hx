package objects.ui;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import sys.FileSystem;
import sys.io.File;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import states.PlayState;

using flixel.util.FlxSpriteUtil;

typedef SongCardData =
{
	var font:String;
	var customArt:String;
	var iconSkin1:String;
	var iconSkin2:String;
}

class SongCard extends FlxSpriteGroup
{
	
	// Pre-made Text
	public var composer:String = PlayState.SONG.composer;
	public var songTitle:String = PlayState.SONG.song;

	// Files to look for
	public var fontStuff:String = "vcr";
	public var artFile:String = "test";
	public var fileName:String = CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase());
	public var pIconName:String = "bf";
	public var oIconName:String = "dad";
	
	// Card Data Stuff
	public var cardData:SongCardData;

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
  
  function setupCardData()
  {
    switch (PlayState.SONG.song)
    {
        case 'Isolated' | 'Lunacy' | 'Hunted' | 'Hunted Legacy' | "Isolated Legacy" | 'Lunacy Legacy' | 'Delusional Legacy':
          fontStuff = "DisneyFont";
        case 'Delusional':
          fontStuff = "satanFont";
        case 'Bless':
          fontStuff = "MagicOwlFont";
	      case 'Birthday':
	        isBirthday = true;
	        fontStuff = "DisneyFont";
        case "Don't Cross!":
	        isCross = true;
          fontStuff = "PhantomMuff Full Letters 1.1.5";
        case 'Cycled Sins' | 'Cycled Sins Legacy':
          fontStuff = "calibri-regular";
        case 'Mercy' | 'Mercy Legacy':
          fontStuff = "splatter";
        case 'Malfunction':
	  isMalfunction = true;
          fontStuff = "m40";
        default: 
          fontStuff = "vcr";
    }
  }
  
  public function new()
  {
    super();
    
    setupCardData();
    
    if (FileSystem.exists('./assets/data/cardData/${fileName}.json')) 
    {
    	var rawJson = File.getContent(Paths.getPath('data/cardData/${fileName}.json', TEXT));
	cardData = cast Json.parse(rawJson).customCardData;
	
	artFile = cardData.customArt;
    	pIconName = cardData.iconSkin1;
	oIconName = cardData.iconSkin2;
	fontStuff = cardData.font;
	
	if (!FileSystem.exists('./assets/images/menus/Funkin_avi/card/${artFile}.png'))
	  cardSprite = new FlxSprite().makeGraphic(600, 350, 0xFF000000);
	else
	  cardSprite = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/card/${artFile}'));
	
	opponentIcon = new HealthIcon(oIconName, false);

	playerIcon = new HealthIcon(pIconName, true);
	
	cardTxt = new FlxText(cardSprite.x, cardSprite.y, 0, '- ${songTitle} -\nBy: ${composer}');
	cardTxt.setFormat(Paths.font(fontStuff), 42, FlxColor.WHITE, CENTER);
    }
    else
    {
    	if (!FileSystem.exists('./assets/images/menus/Funkin_avi/card/${fileName}.png'))
	  cardSprite = new FlxSprite().makeGraphic(600, 350, 0xFF000000);
	else
	  cardSprite = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/card/${fileName}'));
	
    	opponentIcon = new HealthIcon(PlayState.opponent.characterData.icon, false);

	playerIcon = new HealthIcon(PlayState.boyfriend.characterData.icon, true);
	
	cardTxt = new FlxText(cardSprite.x, cardSprite.y, 0, '- ${songTitle} -\nBy: ${composer}');
	cardTxt.setFormat(Paths.font(fontStuff), 42, FlxColor.WHITE, CENTER);
    }
    
    cardSprite.alpha = 0.001;
    cardSprite.screenCenter();
    
    opponentIcon.animation.curAnim.curFrame = 2;
    opponentIcon.x = cardSprite.x - 90;
    opponentIcon.y = cardSprite.y - 50;
    opponentIcon.alpha = 0.001;
    
    playerIcon.animation.curAnim.curFrame = 2;
    playerIcon.x = cardSprite.x + 525;
    playerIcon.y = cardSprite.y + 280;
    playerIcon.alpha = 0.001;
    
    cardTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    cardTxt.screenCenter();
    cardTxt.alpha = 0.001;
    
    add(cardSprite);
    add(cardTxt);
    add(opponentIcon);
    add(playerIcon);
  }
  
  // This is a function in case you want the card to show up later in the song instead of instantly
  public function playCardAnim(delaySet:Float = 0)
  {	
  	// Fade Stuff
  	FlxTween.tween(cardSprite, {alpha: 1}, 1.5, {ease: FlxEase.sineInOut, startDelay: delaySet,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(cardSprite, {alpha: 0}, 1.5, {ease: FlxEase.sineInOut, startDelay: 3.5});
				}
		});
	FlxTween.tween(cardTxt, {alpha: 1}, 2, {ease: FlxEase.sineInOut, startDelay: delaySet,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(cardTxt, {alpha: 0}, 2, {ease: FlxEase.sineInOut, startDelay: 3.5});
				}
		});
	FlxTween.tween(opponentIcon, {alpha: 1}, 2.2, {ease: FlxEase.sineInOut, startDelay: delaySet,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(opponentIcon, {alpha: 0}, 2.2, {ease: FlxEase.sineInOut, startDelay: 3.5});
				}
		});
	FlxTween.tween(playerIcon, {alpha: 1}, 2.2, {ease: FlxEase.sineInOut, startDelay: delaySet,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(playerIcon, {alpha: 0}, 2.2, {ease: FlxEase.sineInOut, startDelay: 3.5});
				}
		});
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
