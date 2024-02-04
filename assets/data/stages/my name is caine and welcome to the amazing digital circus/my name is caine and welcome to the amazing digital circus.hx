var defaultPath:String = 'data/stages/my name is caine and welcome to the amazing digital circus/e';

function onCreate()
{
    PlayState.defaultCamZoom = .78;

    spawnSecondaryOpponent(false);

    var sky = new FlxSprite(-1280 * .25,  -720 * .2, Paths.image('sky', defaultPath));
    sky.scrollFactor.set(.05, .05);
    sky.scale.set(.75, .75);
    sky.updateHitbox();
    add(sky);

    var floor = new FlxSprite(-1280, -720, Paths.image('floor', defaultPath));
    floor.scale.set(1.1, 1.1);
    add(floor);

    var tent = new FlxSprite(-1280, -720, Paths.image('tent', defaultPath));
    add(tent);
    
    var tentsfront = new FlxSprite(-1280 * 1.2, -720, Paths.image('tentsfront', defaultPath));
    tentsfront.scrollFactor.set(1.25, 1.25);
    tentsfront.scale.set(1.15, 1.15);
    foreground.add(tentsfront);

    PlayState.camGame.fade(0x000000, 0.0001);
}

function onPostCreate(boyfriend:Character, gf:Character, dad:Character, player3:Character)
{
    for (hud in PlayState.strumHUD)
        hud.alpha = 0;

    PlayState.camHUD.alpha = 0;
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character, player3:Character)
{
    dad.setPosition(-990, -100);
    boyfriend.setPosition(200, 100);
    gf.setPosition(-300, -200);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character, mom:Character) {
    if (curBeat == 7)
    {
        PlayState.cameraSpeed = 50;
        PlayState.main.camDisplaceX += 100;
    }

    if (curBeat == 8)
    {
        PlayState.camGame.fade(0x000000, 5, true);
        FlxTween.tween(PlayState.main, {camDisplaceX: 0}, 3);
    }
}