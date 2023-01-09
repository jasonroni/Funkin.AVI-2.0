function eventTrigger(params)
    {
        var camZoom:Float = Std.parseFloat(params[0]);
        var hudZoom:Float = Std.parseFloat(params[1]);
        if(Math.isNaN(camZoom)) camZoom = 0.015;
        if(Math.isNaN(hudZoom)) hudZoom = 0.03;

        FlxG.camera.zoom += camZoom;
        PlayState.camHUD.zoom += hudZoom;

        for(strums in PlayState.strumHUD)
            strums.zoom += hudZoom;
    }
    
function returnDescription()
    return
        "Zooms the game and HUD camera\n\nValue 1: Camera Zoom\nValue 2: HUD Zoom";
    