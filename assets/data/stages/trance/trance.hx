function onCreate()
{
    spawnGirlfriend(false);
    PlayState.defaultCamZoom = 1;

    var bg:FlxSprite = new FlxSprite();
    bg.frames = Paths.getSparrowAtlas('background', "data/stages/trance");
    bg.animation.addByPrefix("lmao", "background lmao", 24, true);
    bg.scale.set(5, 5);
    add(bg);
    bg.animation.play("lmao");
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
    dad.setPosition(-861, -259);
    boyfriend.setPosition(260, 0);
}   