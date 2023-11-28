@tool
extends EditorPlugin

const Timeline = preload("res://addons/anthonyec.npc_schedule/timeline.tscn")

var timeline: Control
var bottom_panel_button: Button

func _enter_tree() -> void:
	timeline = Timeline.instantiate()
	bottom_panel_button = add_control_to_bottom_panel(timeline, "NPC Schedule")

func _exit_tree() -> void:
	assert(timeline)
	timeline.queue_free()
	
	assert(bottom_panel_button)
	remove_control_from_bottom_panel(bottom_panel_button)
	
