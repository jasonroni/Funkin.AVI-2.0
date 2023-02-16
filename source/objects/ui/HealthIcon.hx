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
		if (health > 80)
			animation.curAnim.curFrame = 2;
		if (health < 20)
			animation.curAnim.curFrame = 1;
		else
			animation.curAnim.curFrame = 0;
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

		antialiasing = true;

		var iconGraphic:FlxGraphic = Paths.image('$iconPath/icon$suffix', 'data/characters');
		loadGraphic(iconGraphic, true, Std.int(iconGraphic.width / 3), iconGraphic.height);

		initialWidth = width;
		initialHeight = height;

		animation.add('icon', [0, 1, 2], 0, false, isPlayer);
		animation.play('icon');
		scrollFactor.set();
	}
}
