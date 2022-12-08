function loadedEventAction(params)
{
    var screenFadeHelper:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
    screenFadeHelper.alpha = 0;
    screenFadeHelper.cameras = [PlayState.camAlt];
    add(screenFadeHelper);
}

function eventTrigger(params)
    {
        switch(params[2].toLowerCase().trim()) {

            case 'old' | 'classic' | 'v1':
                var charType:Int = Std.parseInt(params[0]);
                if(Math.isNaN(charType)) charType = 0;
        
                    switch(charType) {
                        case 0:
                            screenFadeHelper.alpha = 0;
                        case 1:
                            screenFadeHelper.alpha += 0.05;
                        case 2:
                            screenFadeHelper.alpha -= 0.05;
                        case 3:
                            screenFadeHelper.alpha += 1;
                        //Sorry that you have to fucking spam these events to do the thing
                    }
            
            case 'new' | 'v2' | 'tween':
                var fadeAlpha:Float = Std.parseFloat(params[0]);
                var timer:Float = Std.parseFloat(params[1]);

                if (fadeAlpha > 1) fadeAlpha = 0.3; //The old version of this event still exists in the charts and I had to fucking put this in in hopes of fixing it until I actually update them
                if (params[1].trim()=='') timer = 1; //Fix for old version of this event aaaaaaa

                FlxTween.tween(screenFadeHelper, {alpha: fadeAlpha}, timer, {ease: FlxEase.sineInOut}); //sine it out supermarcy*/
                
            default:
                var charType:Int = Std.parseInt(params[0]);
                if(Math.isNaN(charType)) charType = 0;
        
                    switch(charType) {
                        case 0:
                            screenFadeHelper.alpha = 0;
                        case 1:
                            screenFadeHelper.alpha += 0.05;
                        case 2:
                            screenFadeHelper.alpha -= 0.05;
                        case 3:
                            screenFadeHelper.alpha += 1;
                        //Sorry that you have to fucking spam these events to do the thing
                    }
        }//I had to fucking do this just so it fixes my fucking problem I'm having with this single event crashing the game cause of it using the old version
    }
    
    function returnDescription()
        return
            "Affects visibility of the entire game's screen.\nValue 1: Alpha Value\nValue 2: Time it takes to fade (only works in new version)\nValue 3: Version you wish to use";
    
    function returnValue3()
        return true;
    
