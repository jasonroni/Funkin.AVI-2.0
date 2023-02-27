package states;

import flixel.FlxState;
import states.PlayState;
import flixel.FlxG;

#if (hxCodec >= "2.6.1") 
import hxcodec.VideoHandler;
#elseif (hxCodec == "2.6.0")
import VideoHandler;
#else
import vlc.MP4Handler;
#end

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

   private static function playCutscene(name:String)
      {
         FlxG.sound.music.stop();
   
         #if (hxCodec >= "2.6.0")
         var video:VideoHandler = new VideoHandler();
         #else
         var video:MP4Handler = new MP4Handler();
         #end
   
         video.playVideo(Paths.video(name)); // supports all vlc formats such as .avi (totally not a funkin.avi reference)
   
         video.finishCallback = onFinishCallBack;
      }

   private static function onFinishCallBack():Void
      {
         completedCutscene = true;
         if (isOutro)
         {
            switch PlayState.SONG.song)
            {
                  case "Delusional":
                     FlxG.switchState(new states.menus.story.MainStoryState());
                  
                  case "Affliction" | "Mortiferum Risus":
                     FlxG.switchState(new states.menus.story.SideStoryState());
                  
                  case "Malfunction":
                     FlxG.switchState(new states.menus.freeplay.ExtrasState());
                  
                  default:
                     FlxG.switchState(new states.menus.MainMenu());
            }           
         }
         else
         {
            FlxG.switchState(new PlayState());
         }
      }
}
