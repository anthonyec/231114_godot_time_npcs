extends NPCState

func enter(_params: Dictionary) -> void:
	npc.animation.play("Idle")

func physics_update(delta: float) -> void:
	if npc.global_position.distance_to(npc.nav_agent.target_position) > 1:
		return state_machine.transition_to("Move")
	
	var player = World.instance.get_player_or_null()
	if not player: return
	
	npc.face_towards(player.global_position, 5, delta)
	npc.snap_to_ground()
