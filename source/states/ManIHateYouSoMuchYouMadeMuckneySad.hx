package states;

import gamejolt.GameJolt.GameJoltAPI;
import flixel.FlxSprite;
import lime.app.Application;
import lime.ui.Window;
import flixel.FlxG;

/**
 * why did you left his birthday
 */
class ManIHateYouSoMuchYouMadeMuckneySad extends MusicBeatState
{
   var leMuckney:FlxSprite;
   
   override function create() {
      super.create();

      Application.current.window.borderless = true;

      if(!GameJoltAPI.checkTrophy(184288))
         GameJoltAPI.getTrophy(184288);
   }

   override function update(e)
      {
         super.update(e);
      }
}