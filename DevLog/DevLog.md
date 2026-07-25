
# Documentation

In this document, I log accomplished developments, and future plans for this project.

## Next Steps

- Make other players loose HP when getting hit by a bullet.

## Change log

### 22/07/2026: Created the project and added basic Lobby funcionality.

### 22/07/2026: Created the repository

### 23/07/2023: Added independent score variable to each player!

I used server authoritative RPC calls: Better design for games, server controls the truth, avoids hacks. The player calls an RPC on the server to request an increase on the score. The server validates the request, increases the score of the player locally, and sends an RPC to all peer players to increase their score accordingly.

Players initialized to their correct positions.

Players were not spawning in the correct positions because of the SpawnPath property of the MultiplayerSpawner Node. Moving it to position x=0 y=0 solved the issue.


### 24/07/2023: Players spawn bullets trough RPC

Using the same method of adding a score to each player, with server authoritative RPC calls, the players can now shoot a bullet.