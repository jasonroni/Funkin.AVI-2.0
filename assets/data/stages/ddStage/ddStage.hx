var gradient:FlxSprite;

function onCreate() 
{
    spawnGirlfriend(false);   

    gradient = new FlxSprite().loadGraphic(Paths.image('UI/gimmicks/gradient'));
    gradient.cameras = [PlayState.camAlt];
    gradient.screenCenter();
    gradient.scale.set(0.5, 0.5);
    gradient.alpha = 0;
    add(gradient);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
    {
        // me when zoom gets higher or whatever -jason
        if(curBeat >= 64 && curBeat < 95)
            {
                FlxG.camera.zoom += 0.025;
                PlayState.camHUD.zoom += 0.042;
                for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
                FlxTween.tween(gradient, {alpha: 0.3}, 2);
            }

        if(curBeat >= 96 && curBeat < 111)
            {
                FlxG.camera.zoom += 0.04;
                PlayState.camHUD.zoom += 0.053;
                for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
                FlxTween.tween(gradient, {alpha: 0.6}, 2);
            }

        if(curBeat == 112)
            {
                FlxTween.tween(FlxG.camera, {zoom: 2}, 14, {ease: FlxEase.sineInOut});
                FlxTween.tween(gradient, {alpha: 0.9}, 2);
            }

        if(curBeat >= 112) // doesn't make sense to but a "&& curBeat < idk"
            {
                // not including camGame cus it bugs out
                PlayState.camHUD.zoom += 0.053;
                for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
            }
    }