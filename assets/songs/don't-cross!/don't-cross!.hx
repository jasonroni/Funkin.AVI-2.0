function goodNoteHit()
   {
      PlayState.boyfriend.x -= 1.2;
      PlayState.boyfriend.y += 1.2;
      PlayState.boyfriend.scale.x += 0.0012;
      PlayState.boyfriend.scale.y += 0.0012;
   }

function opponentNoteHit()
   {
      PlayState.boyfriend.x += 1.2;
      PlayState.boyfriend.y -= 1.2;
      PlayState.boyfriend.scale.x -= 0.0012;
      PlayState.boyfriend.scale.y -= 0.0012;

      if(PlayState.health > 0.05) // trol
      PlayState.health -= 0.035;
   }