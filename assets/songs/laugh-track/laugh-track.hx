//chart editor fucked up and is now black idfk why
function stepHit()
   {
      if(curStep == 5)
         {
            FlxTween.tween(PlayState.camHUD, {alpha: 0}, 4, {ease: FlxEase.expoInOut});
            for(hud in PlayState.strumHUD)
               FlxTween.tween(hud, {alpha: 0}, 4.3, {ease: FlxEase.expoInOut});
         }

      if(curStep == 240)
         {
            FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
            for(hud in PlayState.strumHUD)
               FlxTween.tween(hud, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
         }
   }