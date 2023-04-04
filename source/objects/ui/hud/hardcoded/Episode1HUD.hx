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
  
  public function new()
  {
    super();
    
    // le healthbar setup
	var barY = FlxG.height * 0.875;
	if (Init.trueSettings.get('Downscroll'))
		barY = 64;

	healthBarBG = new FlxSprite(0,
		barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
	healthBarBG.screenCenter(X);
	healthBarBG.scrollFactor.set();
	add(healthBarBG);

	healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
	healthBar.scrollFactor.set();
	reloadHealthBar();
	add(healthBar);

	iconP1 = new HealthIcon(PlayState.boyfriend.characterData.icon, true);
	iconP1.y = healthBar.y - (iconP1.height / 2);
        iconP1.canBounce = true;
        iconP1.x = FlxG.width * 0.87;
	add(iconP1);

	iconP2 = new HealthIcon(PlayState.opponent.characterData.icon, false);
	iconP2.y = healthBar.y - (iconP2.height / 2);
        iconP2.canBounce = true;
	add(iconP2);
	
	// Isolated & Lunacy stuff
	demonBFIcon = new HealthIcon('bf-demon', true);
	demonBFIcon = healthBar.y - (demonBFIcon.height / 2);
	demonBFIcon.canBounce = false;
	demonBFIcon.x = FlxG.width * 0.87;
	demonBFIcon.alpha = 0.0001;
	add(demonBFIcon);
	
	lunacyIcon = new HealthIcon('lunamick-new', false);
	lunacyIcon = healthBar.y - (lunacyIcon.height / 2);
	lunacyIcon.canBounce = true;
	lunacyIcon.alpha = 0.0001;
	add(lunacyIcon);
	
	delusionalIcon = new HealthIcon('insanemick', false);
	delusionalIcon = healthBar.y - (delusionalIcon.height / 2);
	delusionalIcon.canBounce = false;
	delusionalIcon.alpha = 0.0001;
	add(delusionalIcon);
  }
  
  var counterTextSize:Int = 18;

	function sortJudgements(Obj1:String, Obj2:String):Int
	{
		for (i in 0...ScoreUtils.judges.length)
			return FlxSort.byValues(FlxSort.ASCENDING, i, i);
		return 0;
	}

	var left = (Init.trueSettings.get('Counter') == 'Left');

	override public function update(elapsed:Float)
	{
        updateScoreText();

		// pain, this is like the 7th attempt
		healthBar.percent = (PlayState.health * 50); // so it doesn't make the mechanic worthless

		iconP1.updateAnim(healthBar.percent);
		iconP2.updateAnim(100 - healthBar.percent);
		
		demonBFIcon.updateAnim(healthBar.percent);
		lunacyIcon.updateAnim(100 - healthBar.percent);
		delusionalIcon.updateAnim(100 - healthBar.percent);

		iconP1.bop(0.15);
		iconP2.bop(0.15);
		
		lunacyIcon.bop(0.1);
	}

	public static var divider:String = " | ";

	private var markupDivider:String = '';

	public function updateScoreText()
	{
		if (ScoreUtils.notesHit > 0 && Init.trueSettings.get('Accuracy Hightlight'))
			markupDivider = '°';

		scoreDisplay = 'Score: ' + ScoreUtils.score;

		if (Init.trueSettings.get('Display Accuracy'))
		{
			scoreDisplay += divider + markupDivider + 'Accuracy: ${ScoreUtils.returnAccuracy()}' + markupDivider;
			scoreDisplay += markupDivider + ScoreUtils.returnRankingStatus() + markupDivider;
		}
		scoreDisplay += '\n';

		scoreBar.text = scoreDisplay;

		if (Init.trueSettings.get('Accuracy Hightlight'))
			if (ScoreUtils.notesHit > 0)
				scoreBar.applyMarkup(scoreBar.text, [new FlxTextFormatMarkerPair(scoreFlashFormat, markupDivider)]);

		scoreBar.screenCenter(X);

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys())
			{
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${ScoreUtils.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		if(Init.trueSettings.get('HUD Style') == "forever") //fix i think
			PlayState.detailsSub = scoreBar.text;

		PlayState.updateRPC(false);
	}

	public function reloadHealthBar()
	{
		var colorOpponent = PlayState.opponent.characterData.healthColor;
		var colorPlayer = PlayState.boyfriend.characterData.healthColor;

		if (!Init.trueSettings.get('Colored Health Bar'))
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33 - 0xFFFF0000);
		else
			healthBar.createFilledBar(FlxColor.fromRGB(Std.int(colorOpponent[0]), Std.int(colorOpponent[1]), Std.int(colorOpponent[2])),
				FlxColor.fromRGB(Std.int(colorPlayer[0]), Std.int(colorPlayer[1]), Std.int(colorPlayer[2])));
	}

	public function beatHit(curBeat:Int)
	{
		if (!Init.trueSettings.get('Reduced Movements'))
		{
			if (iconP1.canBounce)
			{
				iconP1.setGraphicSize(Std.int(iconP1.width + 30));
				iconP1.updateHitbox();
			}

			if (iconP2.canBounce)
			{
				iconP2.setGraphicSize(Std.int(iconP2.width + 30));
				iconP2.updateHitbox();
			}
			
			if (lunacyIcon.canBounce)
			{
				lunacyIcon.setGraphicSize(Std.int(iconP2.width + 30));
				lunacyIcon.updateHitbox();
			}
		}
	}

	var scoreFlashFormat:FlxTextFormat;

	override function add(Object:FlxSprite):FlxSprite
	{
		if (Std.isOfType(Object, FlxText))
			cast(Object, FlxText).antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		if (Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		return super.add(Object);
	}
}
