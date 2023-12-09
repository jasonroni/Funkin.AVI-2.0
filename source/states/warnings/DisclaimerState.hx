package states.warnings;

import flash.system.System;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
#if (flixel <= "5.2.2")
	import flixel.system.FlxSound;
#else
	import flixel.sound.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.media.Sound;
import states.MusicBeatState;

class DisclaimerState extends MusicBeatState
{
    var warnText:FlxText;
    
    var disclaimerBG:FlxSprite;

    var redTextMarker = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, true), '^');
    var grayTextMarker = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GRAY, true, true), '+');
    var cyanTextMarker = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.CYAN, true, true), '#');
    
     var blackFade:FlxSprite;

        override function create()
        {
                Application.current.window.title = 'Funkin.avi - DISCLAIMER';

                var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
                bg.scale.set(FlxG.width * 5, FlxG.height * 5);
                add(bg);

                warnText = new FlxText(0, 0, FlxG.width,
		"DISCLAIMER:\n\nThis version of Mickey & other characters used in this mod\nis in no way related to Disney's Mickey Mouse & Co.,\n
as this is simply a project based on the creepypasta:\n+\"SUICIDEMOUSE.avi\".+\nOnce again, there is ^gore^ to be presented within\n
certain songs in this modification of:\n#\"Friday Night Funkin'\".#\nIf you are squirmish about the sight or thought of ^blood^,\nthis mod isn't for you.\n\n
Press ENTER to continue.\nPress ESCAPE to close the game.\n\n^Last chance to turn back...^",
                    32);
		warnText.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, EngineTools.setTextAlign("center"));
                warnText.screenCenter(Y);
                warnText.applyMarkup(warnText.text, [redTextMarker, grayTextMarker, cyanTextMarker]);
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
                        if (Controls.getPressEvent("accept"))
                        {
                                Application.current.window.title = 'Funkin.avi - Proceeding to Game...';
                                FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
                                FlxTween.tween(blackFade, {alpha: 1}, 1, {
                                        onComplete: function (twn:FlxTween) {
                                                Main.switchState(this, new states.TitleState());
                                        }
                                });
                                GameData.hasSeenWarning = true;
                                GameData.saveShit();
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
