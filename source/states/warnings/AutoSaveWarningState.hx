package states.warnings;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.ui.AutoSaveLogo;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class AutoSaveWarningState extends FlxState 
{
    var warningText:FlxText;

    var saveDetectorImage:AutoSaveLogo;

    override function create() {
        super.create();

        #if windows
		base.system.CppAPI.darkMode();
        #end

        GameData.loadShit(); // Collect Any Data
		GameData.lockinIt(); // Now add missing data for any new stuff
        Init.loadControls(); // Loads controls
        Init.loadSettings(); // Loads settings

        warningText = new FlxText(0, 0, FlxG.width, 'WARNING:\nThis game contains an auto save system.\nIf you see this logo right bellow\n^DON\'T TURN OFF THE DEVICE!^', 44);
        warningText.setFormat(Paths.font('vcr'), 37, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        warningText.screenCenter().y -= 40;
        warningText.alpha = 0;
        warningText.applyMarkup(warningText.text, [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, true), '^')]);
        add(warningText);

        FlxTween.tween(warningText, {alpha: 1, y: warningText.y + 40}, 2, {ease: FlxEase.quadInOut});
        
        if(!Init.trueSettings.get('Low Quality'))
            {
                var scratchStuff:FlxSprite = new FlxSprite();
                scratchStuff.frames = Paths.getSparrowAtlas('filters/scratchShit');
                scratchStuff.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
                scratchStuff.animation.play('idle');
                scratchStuff.screenCenter();
                scratchStuff.scale.x = 1.1;
                scratchStuff.scale.y = 1.1;
                add(scratchStuff);

                var grain:FlxSprite = new FlxSprite();
                grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
                grain.animation.addByPrefix('idle', 'grains 1', 24, true);
                grain.animation.play('idle');
                grain.screenCenter();
                grain.scale.x = 1.1;
                grain.scale.y = 1.1;
                add(grain);
            }

        saveDetectorImage = new AutoSaveLogo('autoSave', FlxG.width * 0.78, FlxG.height * 0.69); // funny number
        add(saveDetectorImage);

        new FlxTimer().start(10, _ -> {
            FlxTween.tween(saveDetectorImage, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
            FlxTween.tween(warningText, {alpha: 0, y: warningText.y + 100}, 2, {ease: FlxEase.quadInOut, onComplete: __ -> {
                if (GameData.hasSeenWarning)
                    Main.switchState(this, new states.TitleState());
                else
                    Main.switchState(this, new WarningState());
            }
        });
        });
    }
}