package base.events;

import states.PlayState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.tweens.FlxTween; 
import flixel.tweens.FlxEase;

class IsolatedEvents extends EventData
{
    override function create() {
        super.create();
    }

    override function beatHit(beat:Int)
    {
        super.beatHit(beat);
    }
}