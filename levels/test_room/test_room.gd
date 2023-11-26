extends Node3D

var resource = load("res://levels/test_room/test_convo.dialogue")

func _ready() -> void:
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource)
	print(dialogue_line)

func _process(_delta: float) -> void:
	DebugDraw.set_text("Day", World.instance.day)
	DebugDraw.set_text("Time", World.instance.get_display_time())
	pass
