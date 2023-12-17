extends PlayerState

func update(_delta: float) -> void:
	player.animation.play("Fall")

func physics_update(_delta: float) -> void:
	if player.is_on_ground():
		return state_machine.transition_to("Move")
		
	if player.global_position.y < -10 or state_machine.time_in_current_state > 2000:
		player.global_position = player.last_grounded_position
	
	player.velocity = Vector3.DOWN * 5
	player.move_and_slide()
