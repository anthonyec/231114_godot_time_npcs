extends CharacterState

func update(_delta: float) -> void:
	character.animation.play("Fall")

func physics_update(_delta: float) -> void:
	if character.is_on_ground():
		return state_machine.transition_to("Move")
		
	if character.global_position.y < -10 or state_machine.time_in_current_state > 2000:
		character.global_position = character.last_grounded_position
	
	character.velocity = Vector3.DOWN * 5
	character.move_and_slide()
