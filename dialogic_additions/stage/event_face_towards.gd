@tool
extends DialogicEvent
class_name DialogicFaceTowardsEvent

var character_name: String
var target_name: String
var wait_to_complete: bool = true

func _execute() -> void:
	var world = World.instance
	if not world: return finish()
	
	var character = world.find_character_or_null(character_name)
	
	if not character:
		push_warning("Character not found: %s" % character_name)
		return finish()
	
	var target_character = world.find_character_or_null(target_name)
	
	if not target_character:
		push_warning("Target not found: %s" % target_name)
		return finish()
	
	var character_state_machine = (character.control_state_machine as StateMachine)
	
	character_state_machine.transition_to("LookAt", {
		"node": target_character
	})
	
	if not wait_to_complete:
		return finish()
	
	# TODO: Maybe this should go before a transition incase it instanly sends 
	# a message?
	character_state_machine.state_messaged.connect(func(title: String, _params: Dictionary):
		# TODO: Tidy this up.
		if title == Metadata.StateMessages.LOOK_AT_FACING_TARGET:
			finish()
	)

func _init() -> void:
	event_name = "Face towards"
	event_category = "Stage"

func get_shortcode() -> String:
	return "face_towards"

func get_shortcode_parameters() -> Dictionary:
	return {
		"character": { "property": "character_name", "default": "" },
		"target": { "property": "target_name", "default": "" },
		"wait": { "property": "wait_to_complete", "default": true }
	}

func build_event_editor() -> void:
	var characters = Metadata.Characters.get_entries()
	
	var character_selector_options = characters.map(func(character_name: String):
		return {
			"label": character_name,
			"value": character_name
		}
	)
	
	var target_selector_options = characters.map(func(target_name: String):
		return {
			"label": target_name,
			"value": target_name
		}
	)
	
	add_header_edit("character_name", ValueType.FIXED_OPTION_SELECTOR, {
		"placeholder": "Select character",
		"left_text": "Face towards",
		'selector_options': character_selector_options
	})
	
	add_header_edit("target_name", ValueType.FIXED_OPTION_SELECTOR, {
		"placeholder": "Select target",
		"left_text": "target",
		'selector_options': target_selector_options
	})
	
	add_header_edit("wait_to_complete", ValueType.BOOL, {
		"left_text": "wait"
	})
