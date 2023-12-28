extends Node

func load_level(level_name: String) -> void:
	var game = Game.instance
	if not game: return print("Stage: load_level %s" % level_name)
	
	# TODO: Add check or method that won't load level if already loaded.
	game.load_level(level_name)
	
func switch_to_camera(camera_name: String) -> void:
	var world = World.instance
	if not world: return print("Stage: switch_to_camera %s" % camera_name)
	
	var cameras = world.get_cameras()
	var target_camera: Camera3D
	
	# TODO: Add world helper to switch to camera by name.
	for camera in cameras:
		if camera.name == camera_name:
			target_camera = camera
			break
	
	if not target_camera: return
	
	target_camera.make_current()
	
func spawn_characters(character_names: Array) -> void:
	var world = World.instance
	if not world: return print("Stage: spawn_or_teleport_characters %s" % character_names)
	
	for character_name in character_names:
		if typeof(character_name) != TYPE_STRING: continue
		character_name = character_name as String
			
		var character = world.find_character_or_null(character_name)
		var marker = world.find_node_or_null(character_name)
		
		if not character:
			if character_name.to_lower() == "player":
				character = world.spawn_player_or_null()
			else:
				character = world.spawn_npc_or_null(character_name)
		
		if character and marker:
			character.global_position = marker.global_position + Vector3.UP
			character.global_rotation = marker.global_rotation

func walk_to_and_align(character_name: String, marker_name: String) -> void:
	var world = World.instance
	if not world: return print("Stage: walk_to_and_align %s %s" % [character_name, marker_name])
	
	var character = world.find_character_or_null(character_name)
	if not character: return
	
	var marker = world.find_node_or_null(marker_name)
	if not marker: return
	
	character.control_state_machine.transition_to("FollowPath", { "target": marker.global_position, "align": true })
	
func look_at_character(character_name_a: String, character_name_b: String) -> void:
	var world = World.instance
	if not world: return print("Stage: look_at_character %s %s" % [character_name_a, character_name_b])
	
	var character_a = world.find_character_or_null(character_name_a)
	if not character_a: return
	
	var character_b = world.find_character_or_null(character_name_b)
	if not character_b: return
	
	character_a.control_state_machine.transition_to("LookAt", { "node": character_b })
	
