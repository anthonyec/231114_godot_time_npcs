extends PlayerState

func enter(params: Dictionary) -> void:
	assert(params.has("position"))
	player.nav_agent.target_position = params.get("position")

func physics_update(delta: float) -> void:
	if not player.nav_agent.is_target_reachable():
		return state_machine.transition_to_previous_state()
		
	if player.global_position.distance_to(player.nav_agent.target_position) < 1.5:
		return state_machine.transition_to_previous_state()
		
	var next_position = player.nav_agent.get_next_path_position()
	
	if Flags.is_enabled(Flags.DEBUG_NAV_AGENT):
		DebugDraw.draw_cube(next_position, 0.3, Color.WHITE)
		
	var movement = player.global_position.direction_to(next_position)
	
	player.velocity = movement * player.walk_speed
	player.face_towards(next_position, 10, delta)
	
	player.move_and_slide()
	player.snap_to_ground()
