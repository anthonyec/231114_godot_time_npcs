extends NPCState

func physics_update(delta: float) -> void:
	var player = World.instance.get_player_or_null()
	if not player: return
	
	npc.face_towards(player.global_position, 5, delta)
	npc.snap_to_ground()
