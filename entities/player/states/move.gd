extends PlayerState

var move_direction: Vector3

func update(_delta: float) -> void:
	var world = World.instance
	if not world: return
	
	var npcs = world.get_npcs()
	var closest_npc = Utils.get_closest(npcs, player) as NPC
	if not closest_npc: return
	
	var is_within_distance = closest_npc.global_position.distance_to(player.global_position) < 3
	var is_facing = player.forward.dot(player.global_position.direction_to(closest_npc.global_position)) > 0.6
	
	if is_within_distance and is_facing and state_machine.time_in_current_state > 1000:
		if not closest_npc.can_have_conversation(): return
		
		var events = NPCSchedule.instance.get_current_events_for_npc(closest_npc.npc_name)
		if events.is_empty(): return
		
		var event = events[0]
		if not event.dialogue: return
		
		DebugDraw.set_text("Speak to", closest_npc.npc_name, closest_npc.global_position)
		
		if Input.is_action_just_pressed("interact"):
			state_machine.transition_to("Conversation", { "dialogue": event.dialogue })
			
			# TODO: Temporary. We don't want the NPC to always look at the player,
			# probably only initially. It should be able to be controlled with 
			# the dialogue system.
			closest_npc.state_machine.transition_to("Conversation", { "node": player })

func physics_update(delta: float) -> void:
	if player.global_position.distance_to(player.last_grounded_position) > 3:
		player.last_grounded_position = player.global_position
		
	if player.control_state_machine.current_state.name != "None":
		# Cancel follow path if any button is pressed.
		if Input.is_action_just_pressed("move_backward") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			player.control_state_machine.transition_to("None")
		
		return
		
	var move_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	player.move_input = move_input
	
	var turn_input = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	player.turn_input = turn_input
	
func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("select"):
		var hit = Raycast.cast_from_screen(event.position, 100, player.WORLD_COLLISION_MASK)
		if not hit: return
		
		player.control_state_machine.transition_to("FollowPath", { "target": hit.position })
		DebugDraw.draw_cube(hit.position, 0.2, Color.RED)
