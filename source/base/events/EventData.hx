package base.events;

import objects.ui.notes.Strumline;
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

/**
 * gets event data
 */
class EventData extends FlxTypedGroup<Dynamic> 
{
    public function create() 
    {

    }

    public function beatHit(beat:Int)
    {

    }

    public function getPlayStateCamera(camera:String)
        {
            switch(camera)
                {
                    case 'hud' | 'camHUD':
                        return PlayState.camHUD;

                    case 'game' | 'camGame':
                        return PlayState.camAlt;

                    default:
                        return PlayState.camGame;
                }
        }

    override function add(Object:Dynamic):Dynamic 
    {
        if(Std.isOfType(Object, FlxSprite) || Std.isOfType(Object, FlxText))
            Object.antialiasing = !Init.trueSettings.get('Disable Antialiasing');

        return super.add(Object);
    }
}