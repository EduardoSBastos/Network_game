
# Documentation

In this document, I log accomplished developments, and future plans for this project.

## Next Steps

- Comming to terms with how a score variable can be replicated across players.
  - Make a simple variable that changes with a game event, pick-up

The key idea in Fusion is:
Everything that affects the predicted game state should happen during the simulation step (process_input).
If I execute it in anoter function, the state is changed OUTSIDE of the simultaion. Prediction and Rollback cannot occur.
Everything that affects the simmulation, as game state variables, should happen inside "process_input()". 
Outside, thinkgs that are only local can happen, like UI updates, souds, particle effects.

- I will check if a pickup was collected within the photon simmulation.
	- Used a colision sphere from the player
	- Check if interacted object is pickup
	> Add score to the player.
		- View score on top of head.
		> Transform pickup call into RPC:
		Client detects overlap
			↓
		Request server to collect pickup
			↓
		Server verifies overlap
			↓
		Server awards score
			↓
		Server despawns pickup
			↓
		Fusion replicates the changes
		
		!!! Set_input_authority might execute after _ready!!!
		
		
> Organize scripts





- Move camera to player, FPS




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
NAT Punchthrough|	No|	Yes (rendezvous)|	Good (depends on NAT type)
Relay server|	No|	Yes|	Excellent|
Steam Networking|	No|	Steam handles it|	Excellent|
VPN (Tailscale, ZeroTier)|	No|	VPN service|	Excellent|

### 01/08/2023: Discover Photon

It handles all networking, has godot integration, and is free for prototyping, up to 100 CCU!!
Starting implementation of Photon Godot Fusion.

 - Restarted entire project to follow photon fusion tutorial
 
### 02/08/2023: Photon tutorial

- Followed this [tutorial](https://doc.photonengine.com/fusion-godot/v3-client-server/getting-started/quick-start-guide) up to step 8.

- To players can join the same room, and see each other mooving.

### 02/08/2023: Replicating Score

- Comming to terms with how a score variable can be replicated across players.
	
### 06/08/2023: Replicating Pickups

- Replicated Score as Photon replicated variable. Transformed into property so that UI is automatically changed when score is updated.

- Pickup is currently not a Fusion replicated object, so RPCs cannot be sent to clients. To solve this cleanly, pickup must be spawned with Fusion Spawner.

> The pickup.gd script should be on pickup root
	
