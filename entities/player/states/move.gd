extends PlayerState

var move_direction: Vector3
	
func physics_update(delta: float) -> void:
	if not player.is_near_ground():
		return state_machine.transition_to("Fall")
	
	var rotation_input = Input.get_action_strength("move_left") - Input.get_action_strength("move_right") 
	player.rotate(Vector3.UP, rotation_input * 3 * delta)
	
	var forwards_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	player.velocity = player.forward * player.walk_speed * forwards_input
	
	player.move_and_slide()
	player.snap_to_ground()
