import states.PlayState;
import flixel.util.FlxColor;

function eventTrigger(params)
{
    var flashing = !Init.trueSettings.get('Disable Flashing Lights');

    if (flashing)
        { // This Demolition, is how to make flashing lights disabled
            if (Math.isNaN(params[0]))
                params[0] = 'white';

            var Game = PlayState;

            switch (params[0])
            {
                case 'white' | 'White' | '0':
                    PlayState.canGame.flash(FlxColor.WHITE, 3);
                case 'red' | 'Red' | '1':
                    PlayState.canGame.flash(FlxColor.RED, 3);
                case 'blue' | 'Blue' | '2':
                    PlayState.canGame.flash(FlxColor.BLUE, 3);
                case 'black' | 'Black' | '3':
                    PlayState.canGame.flash(FlxColor.BLACK, 3);
                case 'cyan' | 'Cyan' | '4':
                    PlayState.canGame.flash(FlxColor.CYAN, 3);
                case 'Magenta' | 'magenta' | '5':
                    PlayState.canGame.flash(FlxColor.MAGENTA, 3);
                case 'pink' | 'Pink' | '6':
                    PlayState.canGame.flash(FlxColor.PINK, 3);
                case 'orange' | 'Orange' | '7':
                    PlayState.canGame.flash(FlxColor.ORANGE, 3);
                case 'purple' | 'Purple' | '8':
                    PlayState.canGame.flash(FlxColor.PURPLE, 3);
                case 'lime' | 'Lime' | '9': //lime test windows
                    PlayState.canGame.flash(FlxColor.LIME, 3);
            }
        }

        if (flashing)
        {
            switch (params[1])
            {
                case 'false' | 'False':
                    PlayState.camHUD.visible = true;
                case 'true' | 'True':
                    PlayState.camHUD.visible = false;
                default: 
                    PlayState.camHUD.visible = true;
            }
        }
        else
        {
            switch (params[1])
            {
                case 'false' | 'False':
                    FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1);
                case 'true' | 'True':
                    FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1);
                default: 
                    FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1);
            }
        }
}

function returnDescription()
	return
	"The feather one sucks lol
    \n
    Value 1: The color\n
    Value 2: Decide if hide the HUD or not (default is false)";