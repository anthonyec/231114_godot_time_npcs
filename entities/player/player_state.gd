class_name PlayerState
extends State

var player: Character

func awake() -> void:
	player = owner as Character
	assert(player != null)
