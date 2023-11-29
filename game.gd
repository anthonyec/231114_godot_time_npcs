class_name Game
extends Node3D

signal level_loaded(level_name: String)

static var instance: Game = null

var current_level: Node3D = null
var current_level_name: String

func _ready() -> void:
	if instance != null:
		push_error("Game instance already exists in this scene, overriding previous")
		
	instance = self
	
	load_level("test_room")

func load_level(level_name: String) -> void:
	if current_level != null:
		current_level.queue_free()
	
	var scene = load("res://levels/" + level_name + "/" + level_name + ".tscn") as PackedScene
	if not scene: return
	
	var level = scene.instantiate() as Node3D
	# TODO: In Godot 3.4 the level won't need to be added to the scene 
	# before the player. It's only like that because player position is set.
	add_child(level)
	
	var player_scene = load("res://entities/player/player.tscn") as PackedScene
	var player = player_scene.instantiate() as Player
	level.add_child(player)
	
	for child in level.get_children():
		if child is LevelPortal:
			var level_portal = child as LevelPortal
			
			if level_portal.level_name == current_level_name:
				# TODO: Fix flip flopping when teleporting. Moving the player 
				# forward is just a hack to fix that.
				var forward = -level_portal.global_transform.basis.z
				player.global_position = level_portal.global_position + forward * 2
	
	World.instance.root = level
	current_level = level
	current_level_name = level_name
	level_loaded.emit(level_name)
