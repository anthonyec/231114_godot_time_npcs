extends Node3D

var resource = load("res://levels/test_room/test_convo.dialogue")

func _ready() -> void:
	var _dialogue_line = await DialogueManager.get_next_dialogue_line(resource)
