import flixel.FlxG;
import flixel.util.FlxColor; // Bearly told me that you can import files like a normal haxe file

function eventTrigger(params)
{
    var goofyAhhTimer = Std.parseFloat(params[1]);
    return FlxG.camera.flash(FlxColor.fromString('#${params[0]}'), goofyAhhTimer);
}

function returnDescription()
	return
	"The feather one sucks lol
    \n
    \n
    \n
    Value 1: Decide if use hex for legacy version\n
    Value 2: If use hex, put the color (without a #)\nAnd if legacy just type the color\n\nValue 3: How long it takes";