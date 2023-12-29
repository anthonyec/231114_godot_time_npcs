class_name World
extends Node

signal minute_tick
signal hour_tick
signal day_tick

@export_group("Time")
@export var time: int = 08_25
@export var day: int = 0
@export var ticking: bool = true
@export var tick_per_milliseconds: int = 1000

@onready var root: Node3D = get_parent()

static var instance: World = null

var last_time: int = 0

func _ready() -> void:
	if instance != null: push_error("World instance already exists in this scene, overriding previous")
	instance = self

func _process(_delta: float) -> void:
	update_time()
	
	if Flags.is_enabled(Flags.DEBUG_WORLD_TIME):
		DebugDraw.set_text("Time", get_display_time() + " Day: " + str(day))
	
func update_time() -> void:
	if not ticking: return
	
	var minute_ticked = false
	var hour_ticked = false
	var day_ticked = false
	
	var now = Time.get_ticks_msec()
	
	if now - last_time > tick_per_milliseconds:
		var new_time = time + 1
	
		var hours = floor(new_time / 100)
		var minutes = new_time % 100
		
		# Reset the minutes part of time, rolling over to the new hour.
		if minutes >= 60:
			new_time = (hours + 1) * 100
			hour_ticked = true
			
		new_time = wrapi(new_time, 0, 2359)
		
		time = new_time
		minute_ticked = true
		
		last_time = now
	
	# Perform tick events after modifying values to ensure they are up to date.
	if minute_ticked: minute_tick.emit()
	if hour_ticked: hour_tick.emit()
	if day_ticked: day_tick.emit()

func get_display_time() -> String:
	var hours = floor(time / 100)
	var minutes = time % 100
	
	return str(hours).lpad(2, "0") + ":" + str(minutes).lpad(2, "0")

func get_time_percent() -> float:
	return 0

func get_player_or_null() -> Player:
	return root.get_node_or_null("./Player") as Player
	
func get_level_or_null() -> Node3D:
	return root
	
func get_npcs() -> Array[NPC]:
	if not root: return []
		
	var nodes: Array[NPC] = []
	
	for child in root.get_children():
		var groups = child.get_groups()
		
		if child is NPC and groups.has("npc"):
			nodes.append(child)
	
	return nodes
	
func get_characters() -> Array[Character]:
	if not root: return []
		
	var nodes: Array[Character] = []
	
	for child in root.get_children():
		var groups = child.get_groups()
		
		if child is Character and not (child as Character).id.is_empty():
			nodes.append(child)
	
	return nodes
	
func get_level_portals() -> Array[LevelPortal]:
	if not root: return []
		
	var nodes: Array[LevelPortal] = []
	
	for child in root.get_children():
		if child is LevelPortal:
			nodes.append(child)
	
	return nodes
	
func get_place_markers() -> Array[PlaceMarker]:
	if not root: return []
		
	var nodes: Array[PlaceMarker] = []
	
	for child in root.get_children():
		if child is PlaceMarker:
			nodes.append(child)
	
	return nodes
	
func get_cameras() -> Array[Camera3D]:
	if not root: return []
		
	var nodes: Array[Camera3D] = []
	
	for child in root.get_children():
		if child is Camera3D:
			nodes.append(child)
	
	return nodes
	
func get_camera_zones() -> Array[CameraZone]:
	if not root: return []
		
	var nodes: Array[CameraZone] = []
	
	for child in root.get_children():
		if child is CameraZone:
			nodes.append(child)
	
	return nodes
	
func get_random_position_on_nav_mesh() -> Vector3:
	if not root: return Vector3.ZERO
	
	var nav_region: NavigationRegion3D
	
	for child in root.get_children():
		if child is NavigationRegion3D:
			nav_region = child
			break
	
	if not nav_region:
		return Vector3.ZERO
		
	# TODO: This favours the edges of the nav mesh. Do a better thing
	# where can get positions in the center?
	var random_index = randi_range(0, nav_region.navigation_mesh.vertices.size() - 1)
	var random_vertex_position = nav_region.navigation_mesh.vertices[random_index]
	return nav_region.global_position + random_vertex_position
	
func is_position_obstructed() -> bool:
	return false

func find_player_or_null() -> Player:
	if not root: return null
	
	for child in root.get_children():
		if child is Player:
			return child
	
	return null

func find_npc_or_null(npc_name: String) -> NPC:
	if not root: return null
	
	for npc in get_npcs():
		if npc.npc_name.to_lower() == npc_name.to_lower():
			return npc
	
	return null
	
## Finds an NPC or the Player. They are all characters and have IDs.
func find_character_or_null(character_id: String) -> Character:
	if not root: return null
	
	for character in get_characters():
		if character.id.to_lower() == character_id.to_lower():
			return character
	
	return null
	
func find_level_portal_or_null(level_name: String) -> LevelPortal:
	if not root: return null
		
	for level_portal in get_level_portals():
		if level_portal.level_name == level_name:
			return level_portal
		
	return null

func find_node_or_null(node_name: String) -> Node3D:
	if not root: return null
		
	for child in root.get_children():
		if not (child is Node3D):
			continue
			
		if child.name.to_lower() == node_name.to_lower():
			return child
			
	return null
	
func spawn_player_or_null() -> Player:
	if not root: return null
	
	var scene = preload("res://entities/player/player.tscn") as PackedScene
	var node = scene.instantiate() as Player
	
	root.add_child(node)
	
	return node
	
func teleport_player(position: Vector3) -> void:
	var player = get_player_or_null()
	if not player: return
	
	player.global_position = position
	
	var camera_zones = get_camera_zones()
	var closest_camera_zone := Utils.get_closest(camera_zones, player) as CameraZone
	if not closest_camera_zone: return
	
	closest_camera_zone.switch_to_camera.make_current()

# TODO: Add a way for world to spawn NPCs and Players with extra checks
# to make sure things don't spawn inside each other. And they always
# spawn on floor.
func spawn_npc_or_null(npc_name: String) -> NPC:
	if not root: return null
		
	var scene = preload("res://entities/npc/npc.tscn") as PackedScene
	var node = scene.instantiate() as NPC
	
	node.npc_name = npc_name
	root.add_child(node)
	
	return node
