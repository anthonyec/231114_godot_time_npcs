extends Node

@onready var character: Character = get_parent()

func _physics_process(delta: float) -> void:
	var player = World.instance.get_player()
	
	character.face_towards(player.global_position, 10, delta)
	
	if player.global_position.distance_to(character.global_position) < 2:
		pass
	pass
