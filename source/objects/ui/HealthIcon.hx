package objects.ui;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import sys.FileSystem;

class HealthIcon extends FlxSprite
{
	// rewrite using da new icon system as ninjamuffin would say it
	public var sprTracker:FlxSprite;
	public var initialWidth:Float = 0;
	public var initialHeight:Float = 0;
	
	// Dynamic Icon support in my way cause this engine's original code didn't work anyways
	public var frames:Array<Int> = [0, 1, 2, 3, 4];
	public var finalWidth = 5;

	public var canBounce:Bool = true;
	public var suffix:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		updateIcon(char, isPlayer);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public dynamic function updateAnim(health:Float)
	{
		switch (finalWidth)
		{
			case 5:
				if (health > 90)
					animation.curAnim.curFrame = 4;
				else if (health > 80)
					animation.curAnim.curFrame = 2;
				if (health < 20)
					animation.curAnim.curFrame = 1;
				else if (health < 10)
					animation.curAnim.curFrame = 3;
				else
					animation.curAnim.curFrame = 0;
			case 3:
				if (health > 80)
					animation.curAnim.curFrame = 2;
				if (health < 20)
					animation.curAnim.curFrame = 1;
				else
					animation.curAnim.curFrame = 0;
			case 2:
				if (health < 20)
					animation.curAnim.curFrame = 1;
				else
					animation.curAnim.curFrame = 0;
			case 1:
				animation.curAnim.curFrame = 0;
		}
	}

	public function bop(framerate:Float)
	{
		if (!canBounce)
			return;

		var iconLerp = 1 - Main.framerateAdjust(framerate);
		scale.set(FlxMath.lerp(1, scale.x, iconLerp), FlxMath.lerp(1, scale.y, iconLerp));
		updateHitbox();
	}

	public function updateIcon(char:String = 'bf', isPlayer:Bool = false)
	{
		var trimmedChar:String = char;
		if (trimmedChar.contains('-'))
			trimmedChar = trimmedChar.substring(0, trimmedChar.indexOf('-'));

		var iconPath = char;
		if (!FileSystem.exists(Paths.getPath('data/characters/$iconPath/icon$suffix.png', IMAGE)))
		{
			if (iconPath != trimmedChar)
				iconPath = trimmedChar;
			else
				iconPath = 'placeholder';
		}

		if (suffix == '-pixel')
			antialiasing = false;
		else
			antialiasing = true;

		var iconGraphic:Dynamic = Paths.image('$iconPath/icon$suffix', 'data/characters');
		
		loadGraphic(iconGraphic);
		switch (iconGraphic.width)
		{
			case 750:
				finalWidth = 5;
				frames = [0, 1, 2, 3, 4];
			case 450:
				finalWidth = 3;
				frames = [0, 1, 2];
			case 300:
				finalWidth = 2;
				frames = [0, 1];
			case 150:
				finalWidth = 1;
				frames = [0];
		}
		loadGraphic(iconGraphic, true, Std.int(iconGraphic.width / finalWidth), iconGraphic.height);

		initialWidth = width;
		initialHeight = height;

		animation.add('icon', frames, 0, false, isPlayer);
		animation.play('icon');
		scrollFactor.set();
	}
}
