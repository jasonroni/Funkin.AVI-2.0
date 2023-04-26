package globals;

/*
	okay, I was getting tired of having to rename the fucking typedef stuff for every menu,
	so here's the more better, and more simpler approach to this, 
	basically, you don't need to worry about rewriting a new typedef
	not anymore, 
	this file has been made to be globally used on all over files, if it is needed, 
	you can thank me later.

	-don
*/

import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import flixel.util.FlxColor;

/**
 * Typedef used for Shaders
 */
typedef ShaderEffect = {
	var shader:Dynamic;
  }

/**
 * Typedef used for Freeplay categories
 */
typedef SongMetadata =
{
	var name:String;
	var week:Int;
	var character:String;
	var color:FlxColor;
	var composer:String;
	var difficultyRank:String;
	//var discArt:String;
}
	
typedef BitchDetector =
{
	var hasBitches:Bool;
	var bitchCounter:Int;
	var fakeBitchRemover:Int;
	var finalBitchCount:String;
}
