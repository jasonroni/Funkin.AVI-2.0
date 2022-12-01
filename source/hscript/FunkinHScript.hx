package hscript;

import flixel.FlxBasic;
import hscript.Interp;
import openfl.Lib;
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

class FunkinHScript extends FlxBasic
{
	public var hscript:Interp;

	public override function new()
	{
		super();
		hscript = new Interp();

		setGameVariables();
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
			Lib.application.window.alert(e.message, "Error on Hscript!");
		}
	}

	public function setVariable(name:String, val:Dynamic)
	{
		hscript.variables.set(name, val);
	}

	public function getVariable(name:String):Dynamic
	{
		return hscript.variables.get(name);
	}

	public function executeFunc(funcName:String, ?args:Array<Any>):Dynamic
	{
		if (hscript == null)
			return null;

		if (hscript.variables.exists(funcName))
		{
			var func = hscript.variables.get(funcName);
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

	public override function destroy()
	{
		super.destroy();
		hscript = null;
	}

	public function setGameVariables()
		{
			var game = hscript.variables;

			game.set('discord',Discord);
			game.set('gameHUD', ClassHUD);
			game.set('playState', PlayState);
			game.set('menuState', MainMenuState);
			game.set('musicState', MusicBeat.MusicBeatState);
			game.set('window', Application.current.window);
			game.set('gameTween', FlxTween);
			game.set('gameEase', FlxEase);
		}
}