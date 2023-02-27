function songCutscene()
{
  if (!CutsceneState.completedCutscene)
    PlayState.playVideoCutscene('Episode1_Intro.avi', false);
  
  if (CutsceneState.completedCutscene)
    game.startCountdown();
}
