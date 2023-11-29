class_name World
extends Node

signal minute_tick
signal decasecond_tick
signal hour_tick
signal day_tick

@export_group("Time")
@export var ticking: bool = true
@export var tick_per_milliseconds: int = 1000
@export var day: int = 0
@export var hour: int = 8
@export var minute: int = 30

@onready var root: Node3D = get_parent()

static var instance: World = null

var last_time: int = 0

func _ready() -> void:
	if instance != null:
		push_error("A World instance already exists in this scene, overriding previous")
		
	instance = self

func _process(_delta: float) -> void:
	update_time()
	
func update_time() -> void:
	if not ticking:
		return
	
	var now = Time.get_ticks_msec()
	
	var minute_ticked = false
	var hour_ticked = false
	var day_ticked = false
	
	if now - last_time > tick_per_milliseconds:
		minute += 1
		last_time = now
		minute_ticked = true
	
	if minute > 59:
		minute = 0
		hour += 1
		hour_ticked = true
		
	if hour > 23:
		minute = 0
		hour = 0
		day += 1
		day_ticked = true
	
	# Perform tick events after modifying values to ensure they are up to date.
	if minute_ticked: minute_tick.emit()
	if minute_ticked and minute % 10 == 0: decasecond_tick.emit()
	if hour_ticked: hour_tick.emit()
	if day_ticked: day_tick.emit()

func get_display_time() -> String:
	return str(hour).lpad(2, "0") + ":" + str(minute).lpad(2, "0")

func get_time_percent() -> float:
	return 0

func get_player_or_null() -> Player:
	return root.get_node_or_null("./Player")
	
func get_level_or_null() -> Node3D:
	return root
	
func get_npcs() -> Array[NPC]:
	if not root:
		return []
		
	var npcs: Array[NPC] = []
	
	for child in root.get_children():
		var groups = child.get_groups()
		
		if child is NPC and groups.has("npc"):
			npcs.append(child)
	
	return npcs

func find_npc_or_null(npc_name: String) -> NPC:
	if not root:
		return null
	
	var found_npc: NPC
	var npcs = get_npcs()
	
	for npc in npcs:
		if npc.npc_name.to_lower() == npc_name.to_lower():
			return npc
	
	return found_npc

func find_node_or_null(node_name: String) -> Node3D:
	if not root:
		return null
		
	var found_node: Node3D
	
	for child in root.get_children():
		if not (child is Node3D):
			continue
			
		if child.name.to_lower() == node_name.to_lower():
			found_node = child
			break
			
	return found_node

# TODO: Add a way for world to spawn NPCs and Players with extra checks
# to make sure things don't spawn inside each other. And they always
# spawn on floor.
func spawn_npc_or_null(npc_name: String) -> NPC:
	if not root:
		return null
		
	var npc_scene = preload("res://entities/npc/npc.tscn") as PackedScene
	var npc = npc_scene.instantiate() as NPC
	
	root.add_child(npc)
	
	return npc
