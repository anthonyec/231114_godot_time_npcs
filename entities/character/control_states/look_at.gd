extends CharacterState

var target_node: Node3D

func enter(params: Dictionary) -> void:
	target_node = params.get("node")
	assert(target_node)
	
func update(delta: float) -> void:
	character.face_towards(target_node.global_position, 5, delta)
