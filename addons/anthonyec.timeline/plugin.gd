@tool
extends EditorPlugin

const timeline_scene = preload("res://addons/anthonyec.timeline/timeline.tscn") as PackedScene

var timeline: Control
var bottom_panel_button: Button

func _enter_tree() -> void:
	timeline = timeline_scene.instantiate()
	bottom_panel_button = add_control_to_bottom_panel(timeline, "Timeline")

func _exit_tree() -> void:
	timeline.queue_free()
	remove_control_from_bottom_panel(bottom_panel_button)
