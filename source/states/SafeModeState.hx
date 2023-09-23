package states;

import base.Overlay;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import states.MusicBeatState;

class SafeModeState extends MusicBeatState
{
	override function create()
	{
		Overlay.updateDisplayInfo(false, false);

		super.create();
	}

	override function update(elapsed:Float)
	{
		var key:FlxKey = FlxG.keys.firstJustPressed();
		trace(key.toString());
	}
}
