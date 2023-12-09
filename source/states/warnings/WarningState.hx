package states.warnings;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
#if (flixel <= "5.2.2")
import flixel.system.FlxSound;
#else
import flixel.sound.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

class WarningState extends states.MusicBeatState
{
        var warnText:FlxText;

        var redTextMarker = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, true), '^');

        var vignette:FlxSprite;
        var clouds:FlxSprite;
        var bloodyHand:FlxSprite;
        var groundBG:FlxSprite;
        var syringe:FlxSprite;

        var blackFade:FlxSprite;

        var hasSeenWarning:Bool = false;

        public static var coolInstance:WarningState;

        override function create()
        {
                Application.current.window.title = 'Funkin.avi - WARNING';
                
                #if windows
                base.system.CppAPI.darkMode();
                #end
                        
                GameData.loadShit();
                
                if (GameData.hasSeenWarning)
                        Main.switchState(this, new states.TitleState());

                coolInstance = this;

                var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
                bg.scale.set(FlxG.width * 5, FlxG.height * 5);
                add(bg);

                warnText = new FlxText(0, 0, FlxG.width,
"WARNING:\n
This Mod contains disturbing imagery,\nslight gore and a lot of flashing lights.\n\nIf you are sensitive to any of the following,\n
we highly suggest you close the game now or check\nwith any of the settings that'll be provided in the\noptions menu\n

Press ENTER to proceed to the game.\n
Press SHIFT to disable flashing lights & shaders.\n
Press ESCAPE to close the game.\n
^You have been warned...^",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, EngineTools.setTextAlign("center"));
		warnText.screenCenter(Y);
                warnText.applyMarkup(warnText.text, [redTextMarker]);
		add(warnText);

                // todo later on: use FlxG.camera.fade
                blackFade = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
                blackFade.scale.set(FlxG.width * 5, FlxG.height * 5);
		add(blackFade);

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

                FlxTween.tween(blackFade, {alpha: 0}, 1);
        }

        override function update(elapsed:Float)
        {
                if (!hasSeenWarning) {
                        if (Controls.getPressEvent("accept"))
                        {
                                Application.current.window.title = 'Funkin.avi - Settings Updated...';
                                FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
                                FlxTween.tween(blackFade, {alpha: 1}, 1, {
                                        onComplete: function (twn:FlxTween) {
                                                Main.switchState(this, new states.warnings.DisclaimerState());
                                        }
                                });
                        }
			else if (FlxG.keys.justPressed.SHIFT)
			{
				Application.current.window.title = 'Funkin.avi - Settings Updated...';
				Init.trueSettings.set('Disable Flashing Lights', true);
				Init.trueSettings.set('Disable Screen Shaders', true);
				Init.trueSettings.set('Epilepsy Mode', false);
				FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
                                FlxTween.tween(blackFade, {alpha: 1}, 1, {
                                        onComplete: function (twn:FlxTween) {
                                                Main.switchState(this, new states.warnings.DisclaimerState()); // placeholder
                                        }
                                });
			}
                        else if (Controls.getPressEvent("back"))
                        {
                                Application.current.window.title = 'Funkin.avi - Closing Game...';
                                FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
                                FlxTween.tween(blackFade, {alpha: 1}, 1, {
                                        onComplete: function (twn:FlxTween) {
                                                System.exit(0);
                                        }
                                });
                        }
                }
        }
}
