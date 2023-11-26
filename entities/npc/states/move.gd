extends NPCState

func enter(params: Dictionary) -> void:
	var target_position = params.get("target_position", Vector3.ZERO)
	
func exit() -> void:
	npc.velocity = Vector3.ZERO

func physics_update(delta: float) -> void:
	if npc.global_position.distance_to(npc.target_position) < 1:
		return state_machine.transition_to("Stand")
		
	var next_position = npc.nav_agent.get_next_path_position()
	
	if Flags.is_enabled(Flags.DEBUG_NAV_AGENT):
		DebugDraw.draw_cube(next_position, 0.3, Color.WHITE)
		
	var movement = npc.global_position.direction_to(next_position)
	
	npc.velocity = movement * npc.walk_speed
	npc.face_towards(next_position, 10, delta)
	
	npc.move_and_slide()
	npc.snap_to_ground()
