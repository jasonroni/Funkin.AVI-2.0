function eventTrigger(params)
    {
        var playerLeft:Bool = false;
        var playerDown:Bool = false;
        var playerUp:Bool = false;
        var playerRight:Bool = false;
        var playerDefault:Bool = false;
        var playerFlip:Bool = false;
        var undyne:Bool = false;
        //var flipSides:Bool = false;
        //var mixNotes:Bool = false;

        switch(params[0]) {
            case 'left' | 'Left':
                undyne = false;
                playerDefault = false;
                playerLeft = true;
                playerDown = false;
                playerUp = false;
                playerRight = false;
                playerFlip = false;
            case 'down' | 'Down':
                undyne = false;
                playerDefault = false;
                playerLeft = false;
                playerDown = true;
                playerUp = false;
                playerRight = false;
                playerFlip = false;
            case 'up' | 'Up':
                undyne = false;
                playerDefault = false;
                playerLeft = false;
                playerDown = false;
                playerUp = true;
                playerRight = false;
                playerFlip = false;
            case 'right' | 'Right':
                undyne = false;
                playerDefault = false;
                playerLeft = false;
                playerDown = false;
                playerUp = false;
                playerRight = true;
                playerFlip = false;
            case 'default' | 'Default':
                undyne = false;
                playerDefault = true;
                playerLeft = false;
                playerDown = false;
                playerUp = false;
                playerRight = false;
                playerFlip = false;
            case 'flip' | 'Flip':
                undyne = false;
                playerDefault = false;
                playerLeft = false;
                playerDown = false;
                playerUp = false;
                playerRight = false;
                playerFlip = true;
            case 'undyne' | 'Undyne':
                undyne = true;
                playerDefault = false;
                playerLeft = false;
                playerDown = false;
                playerUp = false;
                playerRight = false;
                playerFlip = false;
        }

        for (i in 0...PlayState.bfStrums.receptors.length) {
            for(j in 0...PlayState.dadStrums.receptors.length) {
                if(playerLeft) {
                    FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 180, x: FlxG.width - 150, angle: 90}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {y: 144}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {y: 256}, 0.25, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {y: 368}, 0.3, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {y: 480}, 0.35, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[i].downScroll = false;

                    FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                } else if(playerDown) {
                    FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 90, y: FlxG.height - 150, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 732}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 844}, 0.3, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 956}, 0.35, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 1068}, 0.2, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[i].downScroll = true;

                    FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                } else if(playerUp) {
                    FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 90, y: 50, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 732}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 844}, 0.35, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 956}, 0.3, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 1068}, 0.2, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[i].downScroll = false;

                    FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                } else if(playerRight) {
                    FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 0, x: 50, angle: 270}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {y: 480}, 0.2, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {y: 368}, 0.25, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {y: 256}, 0.3, {ease: FlxEase.quartInOut});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {y: 144}, 0.35, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[i].downScroll = false;

                    FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                } else if(playerDefault) {
                    if(ClientPrefs.downScroll) {
                        FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 90, y: FlxG.height - 150, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 732}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 844}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 956}, 0.35, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 1068}, 0.2, {ease: FlxEase.quartInOut});
                        PlayState.bfStrums.receptors.members[i].downScroll = true;
                    } else {
                        FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 90, y: 50, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 732}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 844}, 0.35, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 956}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 1068}, 0.2, {ease: FlxEase.quartInOut});
                        PlayState.bfStrums.receptors.members[i].downScroll = false;
                        }

                    FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                    } else if(playerFlip) {
                        if(ClientPrefs.downScroll) {
                        FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 90, y: 50, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 732}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 844}, 0.35, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 956}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 1068}, 0.2, {ease: FlxEase.quartInOut});
                        PlayState.bfStrums.receptors.members[i].downScroll = false;
                    } else {
                        FlxTween.tween(PlayState.bfStrums.receptors.members[i], {direction: 90, y: FlxG.height - 150, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 732}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 844}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 956}, 0.35, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 1068}, 0.2, {ease: FlxEase.quartInOut});
                        PlayState.bfStrums.receptors.members[i].downScroll = true;
                        }

                        FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                    } else if(undyne) {
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {direction: 180, x: 585 - 75, y: 305, angle: 0}, 0.3, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[0].downScroll = false;
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {direction: 90, x: 586, y: 305 + 75, angle: 0}, 0.2, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[1].downScroll = false;
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {direction: 90, x: 586, y: 305 - 75, angle: 0}, 0.36, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[2].downScroll = true;
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {direction: 0, x: 585 + 75, y: 305, angle: 0}, 0.43, {ease: FlxEase.quartInOut});
                    PlayState.bfStrums.receptors.members[3].downScroll = false;

                    FlxTween.tween(PlayState.dadStrums.receptors.members[j], {alpha: 0}, 0.2, {ease: FlxEase.quartInOut});
                    }
                }
            }

        var opponentLeft:Bool = false;
        var opponentDown:Bool = false;
        var opponentUp:Bool = false;
        var opponentRight:Bool = false;
        var opponentDefault:Bool = false;
        var opponentFlip:Bool = false;

            switch(params[1]) {
                case 'left' | 'Left':
                    undyne = false;
                    opponentDefault = false;
                    opponentLeft = true;
                    opponentDown = false;
                    opponentUp = false;
                    opponentRight = false;
                    opponentFlip = false;
                case 'down' | 'Down':
                    undyne = false;
                    opponentDefault = false;
                    opponentLeft = false;
                    opponentDown = true;
                    opponentUp = false;
                    opponentRight = false;
                    opponentFlip = false;
                case 'up' | 'Up':
                    undyne = false;
                    opponentDefault = false;
                    opponentLeft = false;
                    opponentDown = false;
                    opponentUp = true;
                    opponentRight = false;
                    opponentFlip = false;
                case 'right' | 'Right':
                    undyne = false;
                    opponentDefault = false;
                    opponentLeft = false;
                    opponentDown = false;
                    opponentUp = false;
                    opponentRight = true;
                    opponentFlip = false;
                case 'default' | 'Default':
                    undyne = false;
                    opponentDefault = true;
                    opponentLeft = false;
                    opponentDown = false;
                    opponentUp = false;
                    opponentRight = false;
                    opponentFlip = false;
                case 'flip' | 'Flip':
                    undyne = false;
                    opponentDefault = false;
                    opponentLeft = false;
                    opponentDown = false;
                    opponentUp = false;
                    opponentRight = false;
                    opponentFlip = true;
                    }

                for (i in 0...PlayState.dadStrums.receptors.receptors.length) {
                    if(opponentLeft) {
                        FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 180, x: FlxG.width - 150, angle: 90, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[0], {y: 144}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[1], {y: 256}, 0.25, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[2], {y: 368}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[3], {y: 480}, 0.35, {ease: FlxEase.quartInOut});
                        PlayState.dadStrums.receptors.members[i].downScroll = false;
                        //allowOpponentNoteSplash = true;
                    } else if(opponentDown) {
                        FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 90, y: FlxG.height - 150, angle: 0, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 92}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 204}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 316}, 0.35, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 428}, 0.2, {ease: FlxEase.quartInOut});
                        PlayState.dadStrums.receptors.members[i].downScroll = true;
                        //allowOpponentNoteSplash = true;
                    } else if(opponentUp) {
                        FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 90, y: 50, angle: 0, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 92}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 204}, 0.35, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 316}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 428}, 0.2, {ease: FlxEase.quartInOut});
                        PlayState.dadStrums.receptors.members[i].downScroll = false;
                        //allowOpponentNoteSplash = true;
                    } else if(opponentRight) {
                        FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 0, x: 50, angle: 270, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[0], {y: 480}, 0.2, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[1], {y: 368}, 0.25, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[2], {y: 256}, 0.3, {ease: FlxEase.quartInOut});
                        FlxTween.tween(PlayState.dadStrums.receptors.members[3], {y: 144}, 0.35, {ease: FlxEase.quartInOut});
                        PlayState.dadStrums.receptors.members[i].downScroll = false;
                        //allowOpponentNoteSplash = true;
                    } else if(opponentDefault) {
                        if(ClientPrefs.downScroll) {
                            FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 90, y: FlxG.height - 150, angle: 0, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 92}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 204}, 0.3, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 316}, 0.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 428}, 0.2, {ease: FlxEase.quartInOut});
                            PlayState.dadStrums.receptors.members[i].downScroll = true;
                        } else {
                            FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 90, y: 50, angle: 0, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 92}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 204}, 0.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 316}, 0.3, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 428}, 0.2, {ease: FlxEase.quartInOut});
                            PlayState.dadStrums.receptors.members[i].downScroll = false;
                            }
                        //allowOpponentNoteSplash = true;
                    } else if(opponentFlip) {
                        if(ClientPrefs.downScroll) {
                            FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 90, y: 50, angle: 0, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 92}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 204}, 0.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 316}, 0.3, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 428}, 0.2, {ease: FlxEase.quartInOut});
                            PlayState.dadStrums.receptors.members[i].downScroll = false;
                        } else {
                            FlxTween.tween(PlayState.dadStrums.receptors.members[i], {direction: 90, y: FlxG.height - 150, angle: 0, alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 92}, 0.2, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 204}, 0.3, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 316}, 0.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 428}, 0.2, {ease: FlxEase.quartInOut});
                            PlayState.dadStrums.receptors.members[i].downScroll = true;
                            }
                    //allowOpponentNoteSplash = true;
                }
        } //T O O  M U C H  C O D E
    }
    
    function returnDescription()
        return
            "Changes scroll type mid-song\nValue 1: Scroll Type of the player\nValue 2: Scroll Type of the opponent\n \n\"Left\" = Leftscroll\n\"Right\" = Rightscroll\n\"Up\" = Upscroll\n\"Down\" = Downscroll\n\"Flip\" = Reverse current scrolltype settings\n\"Default\" = Return scrolltype to normal";
    