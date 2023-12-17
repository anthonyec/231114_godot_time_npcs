extends PlayerState

var move_direction: Vector3

func update(_delta: float) -> void:
	var forwards_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	
	if forwards_input == 1:
		player.animation.play("Run")
	else:
		player.animation.play("Idle")
	
	var world = World.instance
	if not world: return
	
	var npcs = world.get_npcs()
	var closest_npc = Utils.get_closest(npcs, player) as NPC
	if not closest_npc: return
	
	var is_within_distance = closest_npc.global_position.distance_to(player.global_position) < 3
	var is_facing = player.forward.dot(player.global_position.direction_to(closest_npc.global_position)) > 0.6
	
	if is_within_distance and is_facing:
		DebugDraw.draw_cube(closest_npc.global_position, 1, Color.WHITE)
		
		if Input.is_action_just_pressed("interact"):
			closest_npc.request_conversation()

func physics_update(delta: float) -> void:
	if not player.is_near_ground():
		return state_machine.transition_to("Fall")
	
	if player.global_position.distance_to(player.last_grounded_position) > 3:
		player.last_grounded_position = player.global_position
	
	var rotation_input = Input.get_action_strength("move_left") - Input.get_action_strength("move_right") 
	player.rotate(Vector3.UP, rotation_input * 3 * delta)
	
	var forwards_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	player.velocity = player.forward * player.walk_speed * forwards_input
	
	player.move_and_slide()
	player.snap_to_ground()
	
func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("select"):
		var hit = Raycast.cast_from_screen(event.position, 100, player.WORLD_COLLISION_MASK)
		if not hit: return
		
		state_machine.transition_to("Goto", { "position": hit.position })
		DebugDraw.draw_cube(hit.position, 0.2, Color.RED)

func handle_message(title: String, _params: Dictionary) -> void:
	if title == "start_conversation":
		return state_machine.transition_to("Conversation")
