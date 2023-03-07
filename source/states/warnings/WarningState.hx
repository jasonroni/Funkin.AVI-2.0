package states.warnings;

import base.dependency.HardcodedShaders;
import flash.system.System;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.media.Sound;
import states.MusicBeatState;
import lime.app.Application;
import flash.system.System;

class WarningState extends MusicBeatState
{
        public static var hasSeenWarning:Bool = false;

        var warnText:FlxText;

        var redTextMarker = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, true), '^');

        var vignette:FlxSprite;
        var clouds:FlxSprite;
        var bloodyHand:FlxSprite;
        var groundBG:FlxSprite;
        var syringe:FlxSprite;

        var blackFade:FlxSprite;

        override function create()
        {
                Application.current.window.title = 'Funkin.avi - WARNING';

                var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

                warnText = new FlxText(0, 0, FlxG.width,
			"WARNING:\n
                        \n
			This Mod contains disturbing imagery,\n
                        slight gore and a lot of flashing lights.\n
                        \n
                        If you are sensitive to any of the following,\n
                        we highly suggest you close the game now or check\n
                        with any of the settings that'll be provided in the\n
                        next screen.\n
                        \n
			Press ENTER to proceed to the game.\n
			Press SHIFT to disable flashing lights & shaders.\n
			Press ESCAPE to close the game.\n
                        \n
			^You have been warned...^",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
                warnText.applyMarkup(warnText.text, [redTextMarker]);
		add(warnText);

                blackFade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
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
                                FlxG.save.data.hasSeenWarning = true;
                                FlxG.save.flush();
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
                                FlxG.save.data.hasSeenWarning = true;
                                FlxG.save.flush();
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
