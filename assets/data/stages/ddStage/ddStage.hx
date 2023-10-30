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

    PlayState.cameraBumpSpeed = 0;
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
    {

        if (curBeat >= 32 && curBeat < 64 && curBeat % 2 == 0)
        {
            FlxG.camera.zoom += .025;
            PlayState.camHUD.zoom += .03;
            for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
        }

        // me when zoom gets higher or whatever -jason
        if(curBeat >= 64 && curBeat < 80)
            {
                FlxG.camera.zoom += 0.035;
                PlayState.camHUD.zoom += 0.047;
                for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
                FlxTween.tween(gradient, {alpha: 0.3}, 2);
            }

        if(curBeat >= 80 && curBeat < 96)
            {
                FlxG.camera.zoom += 0.049;
                PlayState.camHUD.zoom += 0.055;
                for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
                FlxTween.tween(gradient, {alpha: 0.3}, 2);
            }

        if(curBeat >= 96 && curBeat < 112)
            {
                FlxG.camera.zoom += 0.055;
                PlayState.camHUD.zoom += 0.067;
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
                PlayState.camHUD.zoom += 0.073;
                for(whyIsItAnArray in PlayState.strumHUD) whyIsItAnArray.zoom = PlayState.camHUD.zoom;
            }
    }