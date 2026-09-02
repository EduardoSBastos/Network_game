
# Documentation

In this document, I log accomplished developments, and future plans for this project.

## Next Steps

 - Player Movement:
 
 Implement player movement code for 2D characters.
 

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

- To players can join the same room, and see each other moving.

### 02/08/2023: Replicating Score

- Coming to terms with how a score variable can be replicated across players.

### 06/08/2023: Replicating Score Property

- Replicated Score as Photon replicated variable. Transformed into property so that UI is automatically changed when score is updated.

### 07/08/2023:

- Pickup is now a Fusion replicated object, so RPCs can be sent to clients. Pickup was spawned with Fusion Spawner.

### 16/08/2023:

Itch.io lobby connection successful!!

Created a lobby that allows for players to create rooms, see created rooms, and join them.
Structure of this lobby was based on the client-server example from the Photon Fusion Godot documentation.

Now onto creating an actual game that run online.


### 23/08/2023:

Continuing the development of the Lobby. Players can connect to the same setion, but cannot see each other. Implementing a list of players in the room.

### 24/08/2023:

Finished a functional lobby! Players can now see each other in the room. Only ther ID is known. They cannot share a name yet.

Now onto designing the game itself, finally!!

I have opted to design a simple 2D game, with an arena and one character for reach player. The characters can shoot, and die in one shot, then revive. The player with most kills at the end of the game, win.

### 25/08/2023:

Booted both players into the same gameplay room, and spawned characters for each player. 

The trick to avoid errors was to wait untill all players had loaded the game scene before spawning.

### 01/09/2023:

Fixed authority distribution by setting the root node on the FusionServerReplicator of the Player scene.

 Define each Player spawn positions.