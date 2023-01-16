function eventTrigger(params)
    {
        var zoomValue:Float = Std.parseFloat(params[0]);
        var timeTween:Float = Std.parseFloat(params[1]);

        if (!Init.trueSettings.get('Reduced Movements'))
        {
            if (Math.isNaN(zoomValue))
                zoomValue = 1;
            if (Math.isNaN(timeTween))
                timeTween = 0.5;

            if (timeTween <= 0)
            {
                PlayState.camGame.zoom = zoomValue;
            }
            else
            {
                 FlxTween.tween(FlxG.camera, {zoom: zoomValue}, timeTween, {
                    ease: FlxEase.sineInOut,
                    onComplete: function(twn:FlxTween)
                    {
                        camZoomTween = null;
                    }
                });
            }
            PlayState.defaultCamZoom = zoomValue;
        }
    }
    
function returnDescription()
    return
	"Sets the game zoom\n\nValue 1: New Cam Zoom\nValue 2: How Long It Takes";
    