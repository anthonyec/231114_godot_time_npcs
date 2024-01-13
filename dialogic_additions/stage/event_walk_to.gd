@tool
extends DialogicEvent
class_name DialogicWalkToEvent

var character_name: String
var marker_name: String

func _execute() -> void:
	var world = World.instance
	if not world: return finish()
	
	var character = world.find_character_or_null(character_name)
	
	if not character:
		push_warning("Character not found: %s" % character_name)
		return finish()
	
	var marker = world.find_node_or_null(marker_name)
	
	if not marker:
		push_warning("Marker not found: %s" % character_name)
		return finish()
	
	var character_state_machine = (character.control_state_machine as StateMachine)
	
	character_state_machine.transition_to("FollowPath", {
		"target": marker.global_position,
		"align": true
	})
	
	# TODO: Maybe this should go before a transition incase it instanly sends 
	# a message?
	character_state_machine.state_messaged.connect(func(title: String, _params: Dictionary):
		# TODO: Tidy this up.
		if title == Metadata.StateMessages.FOLLOW_PATH_REACHED_TARGET:
			print("done")
			finish()
	)

func _init() -> void:
	event_name = "Walk to"
	event_category = "Stage"

func get_shortcode() -> String:
	return "walk_to"

func get_shortcode_parameters() -> Dictionary:
	return {
		"character": { "property": "character_name", "default": "" },
		"marker": { "property": "marker_name", "default": "" },
	}

func build_event_editor() -> void:
	var characters = Metadata.Characters.get_entries()
	var places = Metadata.Places.get_entries()
	
	var character_selector_options = characters.map(func(character_name: String):
		return {
			"label": character_name,
			"value": character_name
		}
	)
	
	var marker_selector_options = places.map(func(marker_name: String):
		return {
			"label": marker_name,
			"value": marker_name
		}
	)
	
	add_header_edit("character_name", ValueType.FIXED_OPTION_SELECTOR, {
		"placeholder": "Select character",
		"left_text": "Walk",
		'selector_options': character_selector_options
	})
	
	add_header_edit("marker_name", ValueType.FIXED_OPTION_SELECTOR, {
		"placeholder": "Select marker",
		"left_text": "to marker",
		'selector_options': marker_selector_options
	})
