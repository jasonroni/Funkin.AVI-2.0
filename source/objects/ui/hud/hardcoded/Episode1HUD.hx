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
  public var isolatedHappy:HealthIcon;
  public var fakeBFLosingFrame:HealthIcon;
  public var demonBFScary:HealthIcon;
  
  // Lunacy Mechanic?????
  public var disguiseFailCheck:Bool = false;
  public var disguisePercent:Float = 5; // 5 = 100% for the math later
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
  public var engineDisplay:String = '~ Episode 1 ~';
  
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

	fancyBarOverlay = new FlxSprite(healthBarBG.x, healthBarBG.y).loadGraphic(Paths.image('UI/default/base/episode1Overlay'));
	fancyBarOverlay.scale.set(1.01, 1);
	fancyBarOverlay.screenCenter(X);
	fancyBarOverlay.scrollFactor.set();
	if (Init.trueSettings.get('Downscroll'))
	{
		fancyBarOverlay.y -= 10;
	}
	else
	{
		fancyBarOverlay.y -= 117;
		fancyBarOverlay.flipY = true;
	}
	add(fancyBarOverlay);

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
	demonBFIcon.y = healthBar.y - (demonBFIcon.height / 2);
	demonBFIcon.canBounce = true;
	demonBFIcon.x = FlxG.width * 0.87;
	demonBFIcon.visible = false;
	add(demonBFIcon);

	demonBFScary = new HealthIcon('bf-demon', true);
	demonBFScary.animation.curAnim.curFrame = 1;
	demonBFScary.y = healthBar.y - (demonBFScary.height / 2);
	demonBFScary.canBounce = false;
	demonBFScary.x = FlxG.width * 0.87;
	demonBFScary.visible = false;
	add(demonBFScary);

	fakeBFLosingFrame = new HealthIcon('bf-fake-new', true);
	fakeBFLosingFrame.animation.curAnim.curFrame = 1;
	fakeBFLosingFrame.y = healthBar.y - (fakeBFLosingFrame.height / 2);
	fakeBFLosingFrame.canBounce = true;
	fakeBFLosingFrame.x = FlxG.width * 0.87;
	fakeBFLosingFrame.visible = false;
	add(fakeBFLosingFrame);

	isolatedHappy = new HealthIcon('lunamick-new', false);
	isolatedHappy.animation.curAnim.curFrame = 2;
	isolatedHappy.y = healthBar.y - (isolatedHappy.height / 2);
	isolatedHappy.canBounce = true;
	isolatedHappy.visible = false;
	add(isolatedHappy);
	
	lunacyIcon = new HealthIcon('lunamick-new', false);
	lunacyIcon.y = healthBar.y - (lunacyIcon.height / 2);
	lunacyIcon.canBounce = true;
	lunacyIcon.visible = false;
	add(lunacyIcon);
	
	delusionalIcon = new HealthIcon('insanemick', false);
	delusionalIcon.y = healthBar.y - (delusionalIcon.height / 2);
	delusionalIcon.canBounce = false;
	delusionalIcon.visible = false;
	add(delusionalIcon);

	scoreTxt = new FlxText(FlxG.width / 2, Math.floor(healthBarBG.y + 40), 0, scoreDisplay);
	scoreTxt.setFormat(Paths.font('DisneyFont'), 26, FlxColor.WHITE);
	scoreTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
	scoreTxt.visible = !PlayState.bfStrums.autoplay;
	updateScoreText();
	add(scoreTxt);

	watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
	watermarkTxt.setFormat(Paths.font('DisneyFont'), 32, FlxColor.WHITE);
	watermarkTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
	if (Init.trueSettings.get('Downscroll')) watermarkTxt.setPosition(0, 655); else watermarkTxt.setPosition(0, 8);
	watermarkTxt.screenCenter(X);
	add(watermarkTxt);

	songTxt = new FlxText(watermarkTxt.x, watermarkTxt.y + 30, 0, '$infoDisplay');
	songTxt.setFormat(Paths.font('DisneyFont'), 22, FlxColor.WHITE);
	songTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
	songTxt.alpha = 0.4;
	songTxt.screenCenter(X);
	add(songTxt);

	if(autoplayTxt != null) {
		autoplayTxt = new FlxText(-5, scoreTxt.y, FlxG.width - 800, '[Autoplay]\n', 32);
		autoplayTxt.setFormat(Paths.font("DisneyFont"), 32, FlxColor.WHITE, CENTER);
		autoplayTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2.3);
		autoplayTxt.screenCenter(X);
		autoplayTxt.visible = PlayState.bfStrums.autoplay;

		// repositioning for it to not be covered by the receptors
		if (Init.trueSettings.get('Centered Notefield'))
		{
			if (Init.trueSettings.get('Downscroll'))
				autoplayTxt.y = autoplayTxt.y - 125;
			else
				autoplayTxt.y = autoplayTxt.y + 125;
		}
		add(autoplayTxt);

		// counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			var judgementNameArray:Array<String> = [];
			for (i in 0...ScoreUtils.judges.length)
				judgementNameArray.insert(i, ScoreUtils.judges[i].name);
			judgementNameArray.sort(sortJudgements);
			for (i in 0...judgementNameArray.length)
			{
				var textAsset:FlxText = new FlxText(5
					+ (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0, '', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font("vcr"), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
    }
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
		healthBar.percent = (PlayState.health * 50);
		
		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		
		fakeBFLosingFrame.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		demonBFIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		demonBFScary.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		isolatedHappy.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (isolatedHappy.width - iconOffset);
		lunacyIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (lunacyIcon.width - iconOffset);
		delusionalIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (delusionalIcon.width - iconOffset);

		iconP1.updateAnim(healthBar.percent);
		iconP2.updateAnim(100 - healthBar.percent);
		
		demonBFIcon.updateAnim(healthBar.percent);
		lunacyIcon.updateAnim(100 - healthBar.percent);
		delusionalIcon.updateAnim(100 - healthBar.percent);

		iconP1.bop(0.15);
		iconP2.bop(0.15);

		isolatedHappy.bop(0.25);
		fakeBFLosingFrame.bop(0.25);
		
		demonBFIcon.bop(0.1);
		lunacyIcon.bop(0.1);

		/*if (autoplayTxt.visible)
		{
			autoplaySine += 180 * (elapsed / 4);
			autoplayTxt.alpha = 1 - Math.sin((Math.PI * autoplaySine) / 80);
		}*/
	}

	public static var divider:String = " - ";

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

		scoreTxt.text = scoreDisplay;

		if (Init.trueSettings.get('Accuracy Hightlight'))
			if (ScoreUtils.notesHit > 0)
				scoreTxt.applyMarkup(scoreTxt.text, [new FlxTextFormatMarkerPair(scoreFlashFormat, markupDivider)]);

		scoreTxt.screenCenter(X);

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys())
			{
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${ScoreUtils.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}
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
				lunacyIcon.setGraphicSize(Std.int(lunacyIcon.width + 30));
				lunacyIcon.updateHitbox();
			}

			if (isolatedHappy.canBounce)
			{
				isolatedHappy.setGraphicSize(Std.int(isolatedHappy.width + 30));
				isolatedHappy.updateHitbox();
			}

			if (demonBFIcon.canBounce)
			{
				demonBFIcon.setGraphicSize(Std.int(demonBFIcon.width + 30));
				demonBFIcon.updateHitbox();
			}

			if (fakeBFLosingFrame.canBounce)
			{
				fakeBFLosingFrame.setGraphicSize(Std.int(fakeBFLosingFrame.width + 30));
				fakeBFLosingFrame.updateHitbox();
			}
		}

		// Cool Mid-Song Icon Changes
		switch (PlayState.SONG.song)
		{
			case 'Isolated':
				switch (curBeat)
				{
					case 160:
						iconP2.alpha = 0;
						isolatedHappy.visible = true;
						FlxTween.tween(isolatedHappy, {alpha: 0}, 1);
						FlxTween.tween(iconP2, {alpha: 1}, 0.6);

					case 168:
						lunacyIcon.visible = true;
						iconP2.alpha = 0;
						FlxTween.tween(lunacyIcon, {alpha: 0}, 1);
						FlxTween.tween(iconP2, {alpha: 1}, 0.6);

					case 172:
						delusionalIcon.visible = true;
						iconP2.alpha = 0;
						FlxTween.tween(delusionalIcon, {alpha: 0}, 1);
						FlxTween.tween(iconP2, {alpha: 1}, 0.6);

					case 176:
						fakeBFLosingFrame.visible = true;
						iconP1.alpha = 0;
						FlxTween.tween(fakeBFLosingFrame, {alpha: 0}, 1);
						FlxTween.tween(iconP1, {alpha: 1}, 0.6);

					case 184:
						demonBFIcon.visible = true;
						iconP1.alpha = 0;
						FlxTween.tween(demonBFIcon, {alpha: 0}, 1);
						FlxTween.tween(iconP1, {alpha: 1}, 0.6);

					case 188:
						demonBFScary.visible = true;
						iconP1.alpha = 0;
						FlxTween.tween(demonBFScary, {alpha: 0}, 1);
						FlxTween.tween(iconP1, {alpha: 1}, 0.6);	
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