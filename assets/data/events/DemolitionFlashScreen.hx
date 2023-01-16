function eventTrigger(params)
{
    var flashing = !Init.trueSettings.get('Disable Flashing Lights');

    if (flashing)
        { // This Demolition, is how to make flashing lights disabled
            if (Math.isNaN(params[1]))
                params[1] = 'white';

            var Game = PlayState;

            switch (params[1])
            {
                case 'white' | 'White' | '0':
                    FlxG.camera.flash(FlxColor.WHITE, 3);
                case 'red' | 'Red' | '1':
                    FlxG.camera.flash(FlxColor.RED, 3);
                case 'blue' | 'Blue' | '2':
                    FlxG.camera.flash(FlxColor.BLUE, 3);
                case 'black' | 'Black' | '3':
                    FlxG.camera.flash(FlxColor.BLACK, 3);
                case 'cyan' | 'Cyan' | '4':
                    FlxG.camera.flash(FlxColor.CYAN, 3);
                case 'Magenta' | 'magenta' | '5':
                    FlxG.camera.flash(FlxColor.MAGENTA, 3);
                case 'pink' | 'Pink' | '6':
                    FlxG.camera.flash(FlxColor.PINK, 3);
                case 'orange' | 'Orange' | '7':
                    FlxG.camera.flash(FlxColor.ORANGE, 3);
                case 'purple' | 'Purple' | '8':
                    FlxG.camera.flash(FlxColor.PURPLE, 3);
                case 'lime' | 'Lime' | '9': //lime test windows
                    FlxG.camera.flash(FlxColor.LIME, 3);
            }
        }

        if (flashing)
        {
            switch (params[1])
            {
                case 'false' | 'False':
                    Game.camHUD.visible = true;
                case 'true' | 'True':
                    Game.camHUD.visible = false;
                default: 
                    Game.camHUD.visible = true;
            }
        }
        else
        {
            switch (params[1])
            {
                case 'false' | 'False':
                    FlxTween.tween(Game.camHUD, {alpha: 1}, 1);
                case 'true' | 'True':
                    FlxTween.tween(Game.camHUD, {alpha: 0}, 1);
                default: 
                    FlxTween.tween(Game.camHUD, {alpha: 1}, 1);
            }
        }
}

function returnDescription()
	return
	"The feather one sucks lol
    \n
    Value 1: The color\n
    Value 2: Decide if hide the HUD or not (default is false)";