class_name Game
extends Node3D

signal level_loaded(level_name: String)

static var instance: Game = null

var current_level: Node3D = null
var current_level_name: String
var temp_balloon

func _ready() -> void:
	if instance != null: push_error("Game instance already exists in this scene, overriding previous")
	instance = self
	
	load_level("pier")
	temp_balloon = get_node("ExampleBalloon")

func load_level(level_name: String, ignore_level_portal: bool = false) -> void:
	if current_level != null:
		current_level.queue_free()
	
	var scene = load("res://levels/" + level_name + "/" + level_name + ".tscn") as PackedScene
	if not scene: return
	
	var level = scene.instantiate() as Node3D
	add_child(level)
	World.instance.root = level # TODO: Kinda ugly.
	
	var world = World.instance
	var player = world.spawn_player_or_null()
	
	var safe_spawn = world.find_node_or_null("SafeSpawn")
	
	if safe_spawn:
		player.global_position = safe_spawn.global_position
		player.global_rotation.y = safe_spawn.global_rotation.y
	
	if not ignore_level_portal:
		# Move player to level portal that corosponds to previous level name.
		# This makes it seem the player has just from that portal.
		for child in level.get_children():
			if child is LevelPortal:
				var level_portal = child as LevelPortal
				
				if level_portal.level_name == current_level_name:
					# TODO: Fix flip flopping when teleporting. Moving the player 
					# forward is just a hack to fix that.
					var forward = -level_portal.global_transform.basis.z
					player.global_position = level_portal.global_position + forward * 2
					player.global_rotation.y = level_portal.global_rotation.y
	
	current_level = level
	current_level_name = level_name
	level_loaded.emit(level_name)
