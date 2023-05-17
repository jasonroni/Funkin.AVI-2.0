package base.utils;

import haxe.io.Path;
import lime.utils.Assets;
import states.PlayState;
import lime.app.Application;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxSave;

using StringTools;
#if sys
import sys.FileSystem;
#end


class CoolUtil
{
	public static var difficulties:Array<String> = []; // Custom Difficulties;
	public static var difficultyArray:Array<String> = ["HARD"]; // Default Difficulties;
	public static var difficultyString:String = 'HARD'; // shows on HUD / Pause;

	public static var defaultDifficulty:String = 'HARD';

	inline public static function difficultyFromNumber(number:Int):String
		return difficulties[number];

	inline public static function boundTo(value:Float, minValue:Float, maxValue:Float):Float
		return Math.max(minValue, Math.min(maxValue, value));

	inline public static function dashToSpace(string:String):String
		return string.replace("-", " ");

	inline public static function spaceToDash(string:String):String
		return string.replace(" ", "-");

	inline public static function swapSpaceDash(string:String):String
		return StringTools.contains(string, '-') ? dashToSpace(string) : spaceToDash(string);

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
		return [for (i in 0...daList.length) daList[i].trim()];
	}

	public static function returnAssetsLibrary(library:String, ?subDir:String = 'assets/images'):Array<String>
	{
		var libraryArray:Array<String> = [];

		return try
		{
			for (folder in FileSystem.readDirectory('$subDir/$library'))
				if (!folder.contains('.'))
					libraryArray.push(folder);
			libraryArray;
		}
		catch (e)
		{
			trace('$subDir/$library is returning null');
			[];
		}
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
		return [for (i in min...max) i];

	/**
	 * Returns an array with the files of the specified directory.
	 * Example usage:
	 * var fileArray:Array<String> = CoolUtil.absoluteDirectory('scripts');
	 * trace(fileArray); -> ['mods/scripts/modchart.hx', 'assets/scripts/script.hx']
	**/
	inline public static function absoluteDirectory(file:String):Array<String>
	{
		if (!file.endsWith('/'))
			file = '$file/';

		var path:String = Paths.getPath(file);

		var absolutePath:String = FileSystem.absolutePath(path);
		var directory:Array<String> = FileSystem.readDirectory(absolutePath);

		if (directory != null)
		{
			var dirCopy:Array<String> = directory.copy();

			for (i in dirCopy)
			{
				var index:Int = dirCopy.indexOf(i);
				var file:String = '$path$i';
				dirCopy.remove(i);
				dirCopy.insert(index, file);
			}

			directory = dirCopy;
		}

		return if (directory != null) directory else [];
	}

	inline public static function normalizePath(path:String):String
	{
		path = Path.normalize(Sys.getCwd() + path);
		#if windows
		path = path.replace("/", "\\");
		#end
		return path;
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	public static function getSavePath(folder:String = 'Dunkin Funkin'):String
	{
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	public function loadWindowTitleData()
	{
		switch (PlayState.gameplayMode)
		{
			case STORY:
				switch (PlayState.SONG.song)
				{
					case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional':
						Application.current.window.title = 'Funkin.avi - Episode 1: ' + SONG.song + " - Composed by: " + SONG.composer + (PlayState.paused ? '{PAUSED}' : "");							
					case 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus':
						Application.current.window.title = 'Funkin.avi - Episode S: ' + SONG.song + " - Composed by: " + SONG.composer + (PlayState.paused ? '{PAUSED}' : "");					
					case 'Mercy' | 'Affliction':
						Application.current.window.title = 'Funkin.avi - Episode W: ' + SONG.song + " - Composed by: " + SONG.composer + (PlayState.paused ? '{PAUSED}' : "");			
					default:
						Application.current.window.title = 'Funkin.avi - Episode ???: ' + SONG.song + " - Composed by: " + SONG.composer + (PlayState.paused ? '{PAUSED}' : "");
				}						
			case FREEPLAY:
				Application.current.window.title = 'Funkin.avi - Freeplay: ' + SONG.song + " - Composed by: " + SONG.composer + (PlayState.paused ? '{PAUSED}' : "");					
			case CHARTING:
				if (SONG.song == 'Malfunction')
					Application.current.window.title = 'glitchedMickey.xml - CHEATER MODE ACTIVATED: ' + SONG.song + " - Composed by: I CAN SEE YOU CHEATING! - [!CHEATER DETECTED!]" + (PlayState.paused ? '{PAUSED}' : "");
				else
					Application.current.window.title = 'Funkin.avi - TESTING MODE: ' + SONG.song + " - Composed by: " + SONG.composer + (PlayState.paused ? '{PAUSED}' : "");
		}
	}

	public function initializeShaders()
	{
		switch (PlayState.SONG.song)
		{
			case 'Malfunction':
				if(!Init.trueSettings.get('Low Quality'))
				{
					PlayState.camGame.setFilters(
					[
						new ShaderFilter(chromZoomShader),
						new ShaderFilter(blurShader)
					]);
					PlayState.camHUD.setFilters(
					[
						new ShaderFilter(chromNormalShader),
						new ShaderFilter(blurShader)
					]);
					for (i in PlayState.strumHUD)
					{
						i.setFilters(
						[
							new ShaderFilter(chromNormalShader),
							new ShaderFilter(blurShader)
						]);
					}
	
					new FlxTimer().start(5, function(tmr:FlxTimer)
					{
						PlayState.camGame.setFilters([new ShaderFilter(chromZoomShader)]);
						PlayState.camHUD.setFilters([new ShaderFilter(chromNormalShader)]);
						for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(chromNormalShader)]);
					});
				}
			case 'Malfunction Legacy':
				if(!Init.trueSettings.get('Low Quality'))
				{
					PlayState.camGame.setFilters(
					[
						new ShaderFilter(chromNormalShader),
						new ShaderFilter(blurShader)
					]);
					PlayState.camHUD.setFilters(
					[
						new ShaderFilter(chromNormalShader),
						new ShaderFilter(blurShader)
					]);
					for (i in PlayState.strumHUD)
					{
						i.setFilters(
						[
							new ShaderFilter(chromNormalShader),
							new ShaderFilter(blurShader)
						]);
					}
				}
			case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional':
				if (!Init.trueSettings.get('Low Quality'))
				{
					PlayState.camGame.setFilters([
						new ShaderFilter(dramaticCamMovement),
						new ShaderFilter(bloomEffect),
						new ShaderFilter(monitorFilter),
						new ShaderFilter(chromZoomShader),
						new ShaderFilter(chromNormalShader)
					]);
					PlayState.camHUD.setFilters([new ShaderFilter(chromNormalShader)]);
					for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(grayScale), new ShaderFilter(chromNormalShader)]);
				}
				else
				{
					PlayState.camGame.setFilters([
						new ShaderFilter(monitorFilter),
						new ShaderFilter(chromNormalShader)
					]);
					PlayState.camHUD.setFilters([new ShaderFilter(chromNormalShader)]);
					for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(grayScale)]);
				}
			case 'Isolated Old' | 'Isolated Legacy' | 'Isolated Beta' | 'Lunacy Legacy' | 'Delusional Legacy':
				blurShader.setFloat('bluramount', 0.6);
				blurShaderHUD.setFloat('bluramount', 0.1);
				andromeda.setFloat('glitchModifier', 0.2);
				andromeda.setBool('perspectiveOn', true);
				andromeda.setBool('vignetteMoving', true);
				if (!Init.trueSettings.get('Low Quality'))
				{
					PlayState.camGame.setFilters([
						new ShaderFilter(grayScale),
						new ShaderFilter(blurShader),
						new ShaderFilter(andromeda)
					]);
					PlayState.camHUD.setFilters([
						new ShaderFilter(grayScale),
						new ShaderFilter(blurShaderHUD),
						new ShaderFilter(andromeda)
					]);
				}
				else
				{
					PlayState.camGame.setFilters([new ShaderFilter(grayScale)]);
					PlayState.camHUD.setFilters([new ShaderFilter(grayScale)]);
				}
			case 'Hunted Legacy':
				blurShader.setFloat('bluramount', 0.6);
				blurShaderHUD.setFloat('bluramount', 0.1);
				andromeda.setFloat('glitchModifier', 0.2);
				andromeda.setBool('perspectiveOn', true);
				andromeda.setBool('vignetteMoving', true);
				if (!Init.trueSettings.get('Low Quality'))
				{
					PlayState.camGame.setFilters([
						new ShaderFilter(grayScale),
						new ShaderFilter(blurShader),
					]);
					for(_camHUD in PlayState.allUIs) _camHUD.setFilters([
						new ShaderFilter(grayScale),
						new ShaderFilter(blurShaderHUD),
						new ShaderFilter(andromeda)
					]);
				}
				else
				{
					PlayState.camGame.setFilters([new ShaderFilter(grayScale)]);
					PlayState.camHUD.setFilters([new ShaderFilter(grayScale)]);
				}				
			case 'Scrapped':
				if (!Init.trueSettings.get('Low Quality'))
				{
					PlayState.camGame.setFilters([
						new ShaderFilter(staticEffect),
						new ShaderFilter(blurShader),
						new ShaderFilter(chromNormalShader),
						new ShaderFilter(chromZoomShader)
					]);
					PlayState.camHUD.setFilters([
						new ShaderFilter(blurShaderHUD),
						new ShaderFilter(chromNormalShader)
					]);
					for (i in PlayState.strumHUD)
					{
						i.setFilters([
							new ShaderFilter(blurShaderHUD),
							new ShaderFilter(chromNormalShader)
						]);
					}
				}
				else
				{
					PlayState.camGame.setFilters([new ShaderFilter(chromNormalShader)]);
					PlayState.camHUD.setFilters([new ShaderFilter(chromNormalShader)]);
					for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(chromNormalShader)]);
				}
		}
	}
}