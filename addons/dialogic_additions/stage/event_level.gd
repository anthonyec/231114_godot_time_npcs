@tool
extends DialogicEvent
class_name DialogicLevelEvent

var level_name: String

func _execute() -> void:
	var game = Game.instance
	if not game: return finish()
	
	game.load_level(level_name)
	await game.level_loaded
	
	finish()

func _init() -> void:
	event_name = "Load Level"
	event_category = "Stage"

func get_shortcode() -> String:
	return "load_level"

func get_shortcode_parameters() -> Dictionary:
	return {
		"name": { "property": "level_name", "default": "" },
	}

func build_event_editor() -> void:
	var levels = Metadata.Levels.get_entries()
	
	var selector_options = levels.map(func(level_name: String):
		return {
			"label": level_name,
			"value": level_name
		}
	)
	
	add_header_edit("level_name", ValueType.FIXED_OPTION_SELECTOR, {
		"left_text": "Load level",
		'selector_options': selector_options
	})
