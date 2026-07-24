
# Documentation

In this document, I log accomplished developments, and future plans for this project.

## Next Steps



## Change log

22/07/2026: Created the project and added basic Lobby funcionality.

22/07/2026: Created the repository

23/07/2023: Players initialized to their correct positions.

Players were not spawning in the correct positions because of the SpawnPath property of the MultiplayerSpawner Node. Moving it to position x=0 y=0 solved the issue.

Added independant score variable to each player!

I used server authoritative RPC calls: Better design for games, server controls the truth, avoids hacks. The player calls an RPC on the server to request an increase on the score. The server validates the request, increases the score of the player locally, and sends an RPC to all peer players to increase their score accordingly.


