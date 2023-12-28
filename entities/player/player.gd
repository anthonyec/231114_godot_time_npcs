class_name Player
extends Character

func _ready() -> void:
	assert(get_groups().has("player"), "Player node needs to be in the player group")
