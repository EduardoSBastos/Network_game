
# Documentation

In this document, I log accomplished developments, and future plans for this project.

## Next Steps




- Respawn Players
  - After a certain time
 
- Rework movement code
  - Something more stable.
  - Add gravity.
  - Add floor.
  - Add jumping.
  - Shoot left and right.


## Change log

### 22/07/2026: Created the project and added basic Lobby funcionality.

### 22/07/2026: Created the repository

### 23/07/2023: Added independent score variable to each player!

I used server authoritative RPC calls: Better design for games, server controls the truth, avoids hacks. The player calls an RPC on the server to request an increase on the score. The server validates the request, increases the score of the player locally, and sends an RPC to all peer players to increase their score accordingly.

Players initialized to their correct positions.

Players were not spawning in the correct positions because of the SpawnPath property of the MultiplayerSpawner Node. Moving it to position x=0 y=0 solved the issue.


### 24/07/2023: Players spawn bullets trough RPC

Using the same method of adding a score to each player, with server authoritative RPC calls, the players can now shoot a bullet.

### 27/07/2023: Player Health and Death

I have made players loose HP when getting hit by a bullet.
- Spawned a bullet, when it enters an Area2D, check if it iis not the owner, if it is a player, and get the Health Node.
- When the hit is confirmed, the Server executes an RPC on the hit player's Health, reducing their health.
- Upon death, stop player processes and hide visuals.


### 27/07/2023: Added Health Bar

Health is handled server authoritative variable, meaning only the server updates health values, which get RPC brodcasted to the client UI, this is good practice.

### 30/07/2023: Exploring internet connection options

Method| Port Forwarding|	Extra Server|	Reliability|
|----|----|----|----|
Manual port forwarding|	Yes|	No|	Excellent|
UPnP|	Automatic|	No|	Good (depends on router)|
NAT Punchthrough|	No|	Yes (rendezvous)|	Good (depends on NAT type)\
Relay server|	No|	Yes|	Excellent|
Steam Networking|	No|	Steam handles it|	Excellent|
VPN (Tailscale, ZeroTier)|	No|	VPN service|	Excellent|