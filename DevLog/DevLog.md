
# Documentation

In this document, I log accomplished developments, and future plans for this project.

## Next Steps

- Give each player an arbitrary authoritative property that will be displayed on screen, changed, and updated across all clients.
		- The property is a number, that counts the amount of times mouse 1 was pressed.
		- The property will be updated with a low level method, so I can learn how it works.
			- Options:
				- RPC: Simple, player clicks, send value to everyone.
				- Server-Authoritative: Better design for games, server controls the truth, avoids hacks, slower.
				- Sent to singleton trough RPC, update visuals with signals: Simple, scalable, questionable desing?
				- Periodic synchronization: RPC every X ms.

	Going with Server-Authoritative approach.
	
	

## Change log

22/07/2026: Created the project and added basic Lobby funcionality.

22/07/2026: Created the repository

23/07/2023: Players initialized to their correct positions.

Players were not spawning in the correct positions because of the SpawnPath property of the MultiplayerSpawner Node. Moving it to position x=0 y=0 solved the issue.

