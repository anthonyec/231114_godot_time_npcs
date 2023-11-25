extends PlayerState

func enter(_params: Dictionary) -> void:
	# TODO: Dirty hack until I work out better collision so it doesn't get stuck.
	player.global_position += player.forward * 0.5

func physics_update(_delta: float) -> void:
	if player.is_on_ground():
		return state_machine.transition_to("Move")
	
	player.velocity = Vector3.DOWN * 5
	player.move_and_slide()
