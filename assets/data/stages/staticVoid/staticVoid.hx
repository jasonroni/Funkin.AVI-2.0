var datTV:FlxSprite;

function onCreate()
{
  spawnGirlfriend(false);
  
  var thePath:String = 'data/stages/staticVoid/images';
  
  var whoaBlackBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(2000, 2000, 0x000000);
  whoaBlackBG.screenCenter();
  add(whoaBlackBG);
  
  datTV = new FlxSprite().loadGraphic(Paths.getSparrowAtlas('white', thePath));
  datTV.animation.addByPrefix('idle', 'white idle');
  datTV.animation.play('idle');
  datTV.alpha = 0;
  add(datTV);
}
    
