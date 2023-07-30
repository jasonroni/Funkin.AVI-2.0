package states;

import states.warnings.VHSTapeIntro;
import flixel.FlxState;
import states.PlayState;
import flixel.FlxG;
 
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec == "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end

using StringTools;

/**
 * not stolen from WI i swear
 */
class CutsceneState extends FlxState
{
   public static var completedCutscene:Bool = false;
   public static var isOutro:Bool = false;
   public var cutscene:String;

   public function new(cutscene:String, isEnd:Bool = false) 
      {
         this.cutscene = cutscene;
         isOutro = isEnd;
         super();
      }

   override function create()
      {
         playCutscene(cutscene);
         super.create();
      }

   override function update(elapsed:Float) 
      {
         super.update(elapsed);
      }

   private static function playCutscene(name:String, isEnd:Bool = false)
      {
         FlxG.sound.music.stop();
   
         var video:VideoHandler = new VideoHandler();
         
         isOutro = isEnd;
   
         video.playVideo(Paths.video(name)); // supports all vlc formats such as .avi (totally not a funkin.avi reference)
   
         video.finishCallback = onFinishCallBack;
      }

   private static function onFinishCallBack():Void
      {
         completedCutscene = true;
         if(Type.getClass(FlxG.state) == PlayState) {
         if (isOutro)
         {
            switch (PlayState.SONG.song)
            {                  
                  case "Malfunction":
                     states.menus.freeplay.FreeplaySongs.freeplayMenuList = 1;
                     FlxG.switchState(new states.menus.freeplay.FreeplaySongs());
                  
                  default:
                     FlxG.switchState(new states.menus.MainMenu());
            }           
         }
         else
         {
            FlxG.switchState(new PlayState());
         }
      } else if(Type.getClass(FlxG.state) == VHSTapeIntro) {
         FlxG.switchState(new states.warnings.WarningState());
      }
   }
}
