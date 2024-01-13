@tool
extends DialogicEvent
class_name DialogicSetupCharactersEvent

# TODO: Make a doc note that you need to put default here otherwise it 
# shows "Placeholder" in dropdown.
var method: String = "spawn_all_at_markers"

func _execute() -> void:
	var world = World.instance
	if not world: return finish()
	
	var character_names = Dialogic.character_directory.keys()
	
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
			character.reset_control()
			character.reset_input()
			
	finish()

func _init() -> void:
	event_name = "Setup Characters"
	event_category = "Stage"

func get_shortcode() -> String:
	return "setup_characters"

func get_shortcode_parameters() -> Dictionary:
	return {
		"method": { "property": "method", "default": "spawn_all_at_markers" },
	}

func build_event_editor() -> void:
	add_header_edit("method", ValueType.FIXED_OPTION_SELECTOR, {
		"left_text": "Setup characters",
		'selector_options': [
			{ "label": "Spawn all at markers", "value": "spawn_all_at_markers" },
		]
	})
