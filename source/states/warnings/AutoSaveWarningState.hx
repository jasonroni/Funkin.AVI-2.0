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

    var doofinschmirtzFactinator:Array<Any> = [
	    "This update took almost 2 years to develop!",
	    "I bet nobody's reading this...",
	    "This mod contains 40k+ lines of code.",
	    "The update wasn't suppose to be nearly 3 hours long at first.",
	    "This mod runs on Forever Engine now!",
	    "This mod was made by a group of 50 people!",
	    "Malfunction was originally NEVER suppose to be in the game.",
	    "Some characters showcased in the game are in fact original ideas!",
	    "You are delusional.",
	    "No facts for now :)"
    ];
	
    var saveDetectorImage:AutoSaveLogo;

    override function create() {
        super.create();

        #if windows
		base.system.CppAPI.darkMode();
        #end

	#if DISCORD_RPC
	Discord.changePresence("FUN FACT:", doofinschmirtzFactinator[FlxG.random.int(0, doofinschmirtzFactinator.length-1)], 'icon'); // dw, I'll make sure to update the RPC shit, if anything, I'm gonna end up making a seperate RPC for this version of the engine
	#end

	openfl.Lib.application.window.title = "Funkin.avi - The Show Will Begin Shortly...";

        GameData.loadShit(); // Collect Any Data
		GameData.lockinIt(); // Now add missing data for any new stuff

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
