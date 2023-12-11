extends PlayerState

var move_direction: Vector3

func update(_delta: float) -> void:
	if not World.instance: return
	var npcs = World.instance.get_npcs()
	var closest_npc = Utils.get_closest(npcs, player) as Character
	
	if not closest_npc:
		return
	
	if closest_npc.global_position.distance_to(player.global_position) < 3:
		pass

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
