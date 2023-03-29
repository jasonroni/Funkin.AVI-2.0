package objects.ui.achievements;

import flixel.util.FlxColor;
import gamejolt.GameJolt.GameJoltAPI;
import flixel.FlxG;

using StringTools;

/**
 * @author BrightFyre
 * 
 * I'm sorry, I just couldn't afford to make a custom one when there's an already functional one from Indie Cross
 */

class Achieve
{
	public var name:String;
	public var desc:String;
	public var sec:Bool;
	public var id:Int;
	public var img:String;
	public var color:FlxColor;

	public function new(nm:String, dsc:String, sec:Bool, id:Int, img:String, ?color:FlxColor = 0xFFFF00)
	{
		name = nm;
		desc = dsc;
		this.sec = sec;
		this.id = id;
		this.img = img;
		this.color = color;
	}
}

class Achievements
{
	public static var achievements:Array<Achieve> =
		[
			//insert achievements here
		];

	public static function unlockAchievement(name:String = "", ?hasSound:Bool = true):Void
	{
		FlxG.save.bind('achievementStuff', CoolUtil.getSavePath());

		var ID:Int = 0;

		for (i in 0...achievements.length)
		{
			if (achievements[i].name == name)
			{
				ID = i;
			}
		}

		if (!FlxG.save.data.achievements[achievements[ID].id])
		{
			FlxG.save.data.achievements[achievements[ID].id] = true;

			GameJoltAPI.getTrophy(achievements[ID].id);
			Main.gjToastManager.createToast("assets/achievements/images/" + Achievements.achievements[ID].img + ".png", Achievements.achievements[ID].name, Achievements.achievements[ID].desc, hasSound, Achievements.achievements[ID].color);
	
			FlxG.save.flush();
		}
	}

	public static function gotAll():Bool
	{
		var unfinished:Int = 0;
		for (i in 0...achievements.length)
		{
			if (!FlxG.save.data.achievementsIndie[achievements[i].id])
			{
				trace('hasnt done ' + achievements[i].name);
				unfinished++;
			}
		}

		if (unfinished == 0)
		{
			trace('user has 100%d :D');
			return true;
		}
		else 
		{
			trace('user has not 100%d :(((');
			return false;
		}
	}

	public static function syncGJ():Void
	{
		for (i in 0...achievements.length)
		{
			if (FlxG.save.data.achievementsIndie[i])
			{
				GameJoltAPI.getTrophy(achievements[i].id);
			}
		}
	}

	public static function defaultAchievements()
	{
		FlxG.save.data.achievementsIndie = [];
		for (i in 0...achievements.length)
		{
			FlxG.save.data.achievementsIndie[achievements[i].id] = false;
		}
		FlxG.save.flush();
	}
}
