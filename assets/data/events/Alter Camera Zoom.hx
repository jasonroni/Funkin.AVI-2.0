using StringTools;

function eventTrigger(params) {
    var zoomValue:Float = Std.parseFloat(params[0]);
    var timeTween:Float = Std.parseFloat(params[1]);

    if(Math.isNaN.trim() == (zoomValue)) zoomValue = 1;
    if (Math.isNaN.trim() == (timeTween)) timeTween = 0.5;

    FlxTween.tween(PlayState.camGame, {zoom: zoomValue}, timeTween, {ease: FlxEase.expoOut, onComplete: function(twn:FlxTween)
    {
        PlayState.defaultCamZoom = zoomValue;
    }});
}

function returnDescription()
    return {
        'Sets The Default Camera Zoom: \nValue 1: Zoom value\nValue 2: How long it takes';
    }