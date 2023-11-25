class_name World
extends Node

static var instance: World = null

func _ready() -> void:
	if instance != null:
		push_error("A World instance already exists in this scene, overriding previous")
		
	instance = self

func get_player() -> Character:
	return get_parent().get_node("./Player")
