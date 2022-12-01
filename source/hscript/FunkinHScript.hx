package hscript;

import flixel.system.macros.FlxMacroUtil;
import flixel.math.FlxAngle;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxDestroyUtil;
import openfl.Lib;
import openfl.text.TextFormat;
import flixel.FlxBasic;
import flixel.effects.FlxFlicker;
import flixel.util.FlxGradient;
import flixel.system.FlxAssets.FlxShader;
import flixel.addons.text.FlxTypeText;
import openfl.media.Sound;
import openfl.text.TextField;
import haxe.io.Bytes;
import lime.media.AudioBuffer;
import flixel.addons.display.FlxGridOverlay;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import lime.system.Clipboard;
import haxe.io.Path;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUI;
import openfl.display.BitmapData;
import haxe.Json;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.FlxGraphic;
import lime.media.openal.AL;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets as LimeAssets;
import openfl.Assets as OpenFlAssets;
import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.util.FlxStringUtil;
import flixel.util.FlxSort;
import flixel.util.FlxSave;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.math.FlxRect;
#if DISCORD_ALLOWED
import meta.data.dependency.Discord;
#end
import flixel.math.FlxMath;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.effects.FlxTrail;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import hscript.InterpEx;
import meta.state.*;
import meta.*;
import meta.state.menus.*;
import meta.data.*;
import meta.data.dependency.*;
import meta.data.font.*;
import meta.subState.charting.PreferenceSubstate;
import meta.state.menus.*;
import meta.state.menus.freeplay.*;
import meta.state.charting.*;
import gameObjects.*;
import gameObjects.userInterface.*;
import gameObjects.userInterface.menu.*;
import gameObjects.userInterface.notes.*;
import gameObjects.system.*;
import gameObjects.background.*;

using StringTools;

/**
 * Sets Hscript variables
 */
class FunkinHScript extends InterpEx {
	var hscript:Interp;

    public function new() {
        super();
        //CLASSES
        //THIS IS PROBABLY MORE THAN ANYONE EVER NEEDS AND YOU CAN IMPORT CLASSES MANUALLY ANYWAYS BUT WHATEVER
        variables.set('AL', AL);
        variables.set('Application', Application);
        variables.set('AudioBuffer', AudioBuffer);
        variables.set('BitmapData', BitmapData);
        variables.set('Bytes', Bytes);
        variables.set('Clipboard', Clipboard);
        variables.set('Event', Event);
        variables.set('FlxAngle', FlxAngle);
        variables.set('FlxAtlasFrames', FlxAtlasFrames);
        variables.set('FlxBackdrop', FlxBackdrop);
        variables.set('FlxBar', FlxBar);
        variables.set('FlxBasic', FlxBasic);
        variables.set('FlxButton', FlxButton);
        variables.set('FlxCamera', FlxCamera);
        variables.set('FlxDestroyUtil', FlxDestroyUtil);
        variables.set('FlxEase', FlxEase);
        variables.set('FlxFlicker', FlxFlicker);
        variables.set('FlxFrame', FlxFrame);
        variables.set('FlxG', FlxG);
        variables.set('FlxGradient', FlxGradient);
        variables.set('FlxGraphic', FlxGraphic);
        variables.set('FlxGridOverlay', FlxGridOverlay);
        variables.set('FlxGroup', FlxGroup);
        variables.set('FlxMath', FlxMath);
        variables.set('FlxObject', FlxObject);
        variables.set('FlxRect', FlxRect);
        variables.set('FlxSave', FlxSave);
        variables.set('FlxShader', FlxShader);
        variables.set('FlxSort', FlxSort);
        variables.set('FlxSound', FlxSound);
        variables.set('FlxSprite', FlxSprite);
        variables.set('FlxSpriteGroup', FlxSpriteGroup);
        variables.set('FlxState', FlxState);
        variables.set('FlxStringUtil', FlxStringUtil);
        variables.set('FlxSubState', FlxSubState);
        variables.set('FlxText', FlxText);
        variables.set('FlxTimer', FlxTimer);
        variables.set('FlxTrail', FlxTrail);
        variables.set('FlxTransitionableState', FlxTransitionableState);
        variables.set('FlxTween', FlxTween);
        variables.set('FlxTypedGroup', FlxTypedGroup);
        variables.set('FlxTypedSpriteGroup', FlxTypedSpriteGroup);
        variables.set('FlxUI', FlxUI);
        variables.set('FlxUICheckBox', FlxUICheckBox);
        variables.set('FlxUIDropDownMenu', FlxUIDropDownMenu);
        variables.set('FlxUIInputText', FlxUIInputText);
        variables.set('FlxUINumericStepper', FlxUINumericStepper);
        variables.set('FlxUITabMenu', FlxUITabMenu);
        variables.set('FlxTypeText', FlxTypeText);
        variables.set('IOErrorEvent', IOErrorEvent);
        variables.set('Json', Json);
        variables.set('Lib', Lib);
        variables.set('LimeAssets', LimeAssets);
        variables.set('OpenFlAssets', OpenFlAssets);
        variables.set('Path', Path);
        variables.set('Reflect', Reflect);
        variables.set('Sound', Sound);
        variables.set('StringTools', StringTools);
        variables.set('TextField', TextField);
        variables.set('TextFormat', TextFormat);
        #if sys
        variables.set('File', File);
        variables.set('FileSystem', FileSystem);
        #end
        #if DISCORD_RPC
        variables.set('Discord', Discord);
        #end
	    variables.set('FreeplayState', FreeplayState);
        variables.set('HealthIcon', HealthIcon);
        variables.set('Highscore', Highscore);
        variables.set('MainMenuState', MainMenuState);
        variables.set('MusicBeatState', MusicBeat.MusicBeatState);
        variables.set('MusicBeatSubState', MusicBeat.MusicBeatSubState);
        variables.set('Note', Note);
        variables.set('NoteSplash', NoteSplash);
        variables.set('OptionsState', OptionsMenuState);
        variables.set('Paths', Paths);
        variables.set('PlayState', PlayState);
        variables.set('Song', Song);
        variables.set('StoryMenuState', StoryMenuState);
        variables.set('TitleState', TitleState);

		// Screen stuff
		variables.set('screenWidth', FlxG.width);
		variables.set('screenHeight', FlxG.height);

		// PlayState cringe ass nae nae bullcrap
		variables.set('curBeat', 0);
		variables.set('curStep', 0);

		variables.set('score', 0);
		variables.set('misses', 0);
		variables.set('hits', 0);

		// Character shit
		variables.set('player1', PlayState.SONG.player1);
		variables.set('player2', PlayState.SONG.player2);

		#if windows
		variables.set('buildTarget', 'windows');
		#elseif linux
		variables.set('buildTarget', 'linux');
		#elseif mac
		variables.set('buildTarget', 'mac');
		#elseif html5
		variables.set('buildTarget', 'browser');
		#elseif android
		variables.set('buildTarget', 'android');
		#else
		variables.set('buildTarget', 'unknown');
		#end
        variables.set('window', Application.current.window);

        //EVENTS
		var funcs = [
			'onCreate',
			'onCreatePost',
			'onDestroy'
		];
		for (i in funcs)
			variables.set(i, function() {});
		variables.set('onUpdate', function(elapsed) {});
		variables.set('onUpdatePost', function(elapsed) {});
    }

	public function runScript(script:String)
		{
			var parser = new hscript.Parser();
	
			try
			{
				var ast = parser.parseString(script);
	
				hscript.execute(ast);
			}
			catch (e)
			{
				openfl.Lib.application.window.alert(e.message, "HSCRIPT ERROR!1111");
			}
		}

	public function setVariable(name:String, value:Any) {
		return variables.set(name, value);
	}

	public function executeFunc(funcName:String, ?args:Array<Any>):Dynamic
		{
			if (hscript == null)
				return null;
	
			if (variables.exists(funcName))
			{
				var func = variables.get(funcName);
				if (args == null)
				{
					var result = null;
					try
					{
						result = func();
					}
					catch (e)
					{
						trace('$e');
					}
					return result;
				}
				else
				{
					var result = null;
					try
					{
						result = Reflect.callMethod(null, func, args);
					}
					catch (e)
					{
						trace('$e');
					}
					return result;
				}
			}
			return null;
		}
}
