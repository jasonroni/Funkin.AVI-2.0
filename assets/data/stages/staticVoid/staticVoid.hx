function onCreate()
{
  spawnGirlfriend(false);
  
  var whoaBlackBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(2000, 2000, 0x000000);
  whoaBlackBG.screenCenter();
  add(whoaBlackBG);
}
    
