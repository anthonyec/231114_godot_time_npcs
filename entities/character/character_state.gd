class_name CharacterState
extends State

var character: Character

func awake() -> void:
	character = owner as Character
	assert(character != null)
