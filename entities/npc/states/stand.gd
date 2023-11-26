extends NPCState

func physics_update(delta: float) -> void:
	var player = World.instance.get_player()
	
	npc.face_towards(player.global_position, 5, delta)
	
	npc.snap_to_ground()
