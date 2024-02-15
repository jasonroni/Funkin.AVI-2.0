var defaultPath:String = 'data/stages/circus/e';

function onCreate()
{
    PlayState.defaultCamZoom = 2.1;

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
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
    dad.setPosition(-990, -100);
    boyfriend.setPosition(200, 100);
    gf.setPosition(-300, -200);
}