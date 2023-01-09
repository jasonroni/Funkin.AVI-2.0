function eventTrigger(params)
    {
        var newZoom = Std.parseFloat(params[0]);
        var zoomTimer = Std.parseFloat(params[1]);

	FlxTween.tween(FlxG.camera, {zoom: newZoom}, zoomTimer, {ease: FlxEase.smootherStepInOut, onComplete: function(e)
        {
            PlayState.defaultCamZoom = newZoom;
        }
    });
    }
    
function returnDescription()
    return
	"Sets the game zoom\n\nValue 1: New Cam Zoom\nValue 2: How Long It Takes";
    