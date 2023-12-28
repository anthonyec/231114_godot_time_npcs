extends CharacterState

func physics_update(delta: float) -> void:
	if not character.is_near_ground():
		return state_machine.transition_to("Fall")
	
	if character.move_input > 0:
		character.animation.play("Run")
	else:
		character.animation.play("Idle")
	
	character.rotate(Vector3.UP, character.turn_input * character.turn_speed * delta)
	character.velocity = character.forward * character.walk_speed * character.move_input
	
	character.move_and_slide()
	character.snap_to_ground()
	
