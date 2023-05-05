package base.events;

import base.song.Conductor;
import flixel.FlxG;
import states.PlayState;

class SongLoop
{
    public function new() {}

    public function repeat():SongLoop
        {
            FlxG.sound.music.pause();
            PlayState.vocals.pause();
            PlayState.songMusic.pause();
            PlayState.bf_vocals.pause();
            PlayState.opp_vocals.pause();

            Conductor.songPosition = 10;
            FlxG.sound.music.time = 10;

            @:privateAccess PlayState.main.generateSong(PlayState.SONG.song);

            PlayState.vocals.play();
            PlayState.bf_vocals.play();
            PlayState.opp_vocals.play();
            PlayState.songMusic.play();

            return this;
        }

    /**
     * broken asf
     * @param time time to set in miliseconds
     */
    public function setTime(time:Float)
        {
                if(time < 0) time = 0;

                PlayState.health = 1000; // lazy

                var e:Array<Float>
                =
                [
                    PlayState.vocals.length,
                    PlayState.bf_vocals.length,
                    PlayState.opp_vocals.length
                ];

                FlxG.sound.music.pause();
                PlayState.vocals.pause();
                PlayState.songMusic.pause();
                PlayState.bf_vocals.pause();
                PlayState.opp_vocals.pause();
        
                FlxG.sound.music.time = time;
                FlxG.sound.music.play();
        
                for(a in e)
                if (Conductor.songPosition <= a)
                {
                    PlayState.vocals.time = time;
                    PlayState.bf_vocals.time = time;
                    PlayState.opp_vocals.time = time;
                    PlayState.songMusic.time = time;
                }

                Conductor.songPosition = time;

                PlayState.main.clearNotesBefore(Conductor.songPosition);

                PlayState.vocals.play();
                PlayState.bf_vocals.play();
                PlayState.opp_vocals.play();
                PlayState.songMusic.play();
            }
    }
