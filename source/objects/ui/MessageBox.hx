package objects.ui;

import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;

class MessageBox extends FlxTypedGroup<FlxBasic>
{
    public function new(x:Float, y:Float, utils:Utils) {
        super();

        // null checks
        if (utils.text == null) utils.text = "this is a message";
        if (utils.color == null) utils.color = FlxColor.WHITE;
        if (utils.boxWidth == null) utils.boxWidth = 360;
    }
}