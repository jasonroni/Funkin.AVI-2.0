package gamejolt.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gamejolt.GJClient;
import gamejolt.extras.TrophieBox;

class TrophiesSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var title:Alphabet;
    var leftArrow:Alphabet;
	var rightArrow:Alphabet;
    var missInfo:FlxText;
    var camPos:FlxObject;
    var curScreen:Int;
    var screenPos:Int;
    var yPos:Int;
    var trophList:Null<Array<Trophy>>;
    var trophGroup:Array<TrophieBox>;

    public function new()
    {
        super();
        openCallback = createMenu;
    }

    function createMenu()
    {
        trophList = GJClient.getTrophiesList(null);

        bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
        bg.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
        bg.scrollFactor.set();
        bg.color = FlxColor.GRAY;
        bg.alpha = 0;
        add(bg);

        camPos = new FlxObject(0, 0, 1, 1);
		camPos.screenCenter();
		add(camPos);

        title = new Alphabet(0, 50, 'Trophies', true);
		title.screenCenter(X);
        title.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		title.scrollFactor.set();
        title.alpha = 0;
		add(title);

        leftArrow = new Alphabet(0, 25, '<', true);
		leftArrow.x = title.x - leftArrow.width - 20;
        leftArrow.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		leftArrow.scrollFactor.set();
        leftArrow.alpha = 0;
		add(leftArrow);

		rightArrow = new Alphabet(0, 25, '>', true);
		rightArrow.x = title.x + title.width + 20;
        rightArrow.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		rightArrow.scrollFactor.set();
        rightArrow.alpha = 0;
		add(rightArrow);

        curScreen = 0;
        screenPos = -1;
        yPos = -1;
        trophGroup = [];
        
        if (trophList != null)
        {
            for (i in 0...trophList.length)
            {
                var curTroph:Trophy = cast trophList[i];

                if (i % 6 == 0) screenPos++;
                
                // if (i % 2 == 0) {yPos++; yPos = yPos % 3;}
                yPos++;
                yPos = yPos % 3;

                var leDate:String = (curTroph.achieved != false ? 'Achieved ${Std.string(curTroph.achieved)}' : "Not achieved yet");

                var trophCard = new TrophieBox(curTroph.title, curTroph.description, leDate);
                trophCard.x = (FlxG.width / 2) - (trophCard.width / 2) + (FlxG.width * screenPos);
                trophCard.y = (FlxG.height * 0.2) + ((trophCard.height + 20) * yPos);
                trophCard.alpha = 0;
                trophGroup.push(trophCard);
                add(trophGroup[i]);
            }
        }
        else
        {
            missInfo = new FlxText(0, 0, 0, "Sorry, the game doesn't have\nany Trophy registered yet\n\nPlease go add some and retry later!");
            missInfo.setFormat(Paths.font('pixel.otf'), 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            missInfo.screenCenter();
            missInfo.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
            missInfo.scrollFactor.set();
            missInfo.visible = false;
            add(missInfo);

            FlxTween.tween(missInfo, {alpha: 0.25}, 0.5, {type: PINGPONG});
        }

        FlxTween.tween(bg, {alpha: 1}, 0.7, {onComplete: function (twn:FlxTween) {if (trophList == null) missInfo.visible = true;}});
        FlxTween.tween(title, {alpha: 1}, 0.7);
        FlxTween.tween(leftArrow, {alpha: 1}, 0.7);
        FlxTween.tween(rightArrow, {alpha: 1}, 0.7);
        for (j in trophGroup) FlxTween.tween(j, {alpha: 1}, 0.7);

        FlxG.camera.follow(camPos, null, 1);
        FlxTween.tween(camPos, {y: camPos.y + 7}, 0.5, {type: PINGPONG});
    }

    function camTween()
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        FlxTween.cancelTweensOf(camPos, ['x']);
        FlxTween.tween(camPos, {x: FlxG.width / 2 + FlxG.width * curScreen}, 0.6, {ease: FlxEase.smootherStepOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var isMinCount:Bool = curScreen <= 0;
		var isMaxCount:Bool = curScreen >= screenPos;

		leftArrow.visible = !isMinCount;
		rightArrow.visible = !isMaxCount;

        if (screenPos > 0)
        {
            if (Controls.getPressEvent('left', 'justPressed') && !isMinCount) {curScreen--; camTween();}
            if (Controls.getPressEvent('right', 'justPressed') && !isMaxCount) {curScreen++; camTween();}
        }

        if (Controls.getPressEvent('back'))
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));

            FlxTween.tween(bg, {alpha: 0}, 0.7, {onComplete: function (twn:FlxTween) {close();}});
            FlxTween.tween(title, {alpha: 0}, 0.7);
            FlxTween.tween(leftArrow, {alpha: 0}, 0.7);
            FlxTween.tween(rightArrow, {alpha: 0}, 0.7);
            if (trophList == null)
            {
                FlxTween.cancelTweensOf(missInfo);
                FlxTween.tween(missInfo, {alpha: 0}, 0.7);
            }
            for (j in trophGroup) FlxTween.tween(j, {alpha: 0}, 0.7);
        }
    }
}