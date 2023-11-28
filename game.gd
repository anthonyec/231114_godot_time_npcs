class_name Game
extends Node3D

static var instance: Game = null

var current_level: Node3D = null

func _ready() -> void:
	if instance != null:
		push_error("Game instance already exists in this scene, overriding previous")
		
	instance = self
	
	load_level("test_room")

func load_level(level_name: String) -> void:
	if current_level != null:
		remove_child(current_level)
		current_level.queue_free()
	
	var scene = load("res://levels/" + level_name + "/" + level_name + ".tscn") as PackedScene
	if not scene: return
	
	var level = scene.instantiate()
	
	add_child(level)
	World.instance.root = level
	current_level = level
