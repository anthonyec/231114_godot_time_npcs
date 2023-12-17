extends PlayerState

func enter(_params: Dictionary) -> void:
	# TODO: Dirty hack until I work out better collision so it doesn't get stuck.
	player.global_position += player.forward * 0.35
	
func update(_delta: float) -> void:
	player.animation.play("Fall")

func physics_update(_delta: float) -> void:
	if player.is_on_ground():
		return state_machine.transition_to("Move")
		
	if player.global_position.y < -10 or state_machine.time_in_current_state > 2000:
		player.global_position = player.last_grounded_position
	
	player.velocity = Vector3.DOWN * 5
	player.move_and_slide()
