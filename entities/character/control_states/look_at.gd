extends CharacterState

var target_node: Node3D

func enter(params: Dictionary) -> void:
	target_node = params.get("node")
	assert(target_node)
	
func update(delta: float) -> void:
	character.face_towards(target_node.global_position, 5, delta)
	
	if character.is_facing(target_node.global_position):
		state_machine.send_message(Metadata.StateMessages.LOOK_AT_FACING_TARGET)
		state_machine.transition_to_previous_state()
