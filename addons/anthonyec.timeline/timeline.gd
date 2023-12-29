@tool
extends Control

const track_scene = preload("res://addons/anthonyec.timeline/track.tscn")

@onready var track_info: Tree = %TrackInfo
@onready var tracks: VBoxContainer = %Tracks

@onready var add_track_button: Button = %AddTrackButton
@onready var add_track_dialog: ConfirmationDialog = %AddTrackDialog
@onready var add_track_name_input: LineEdit = %AddTrackDialog/NameInput

var selected_track: TreeItem

func _ready() -> void:
	var root = track_info.create_item()

func _on_add_track_button_pressed() -> void:
	add_track_dialog.show()
	add_track_name_input.grab_focus()

func _on_add_track_dialog_confirmed() -> void:
	var track_name = add_track_name_input.text
	
	if track_name.is_empty():
		return
	
	var root = track_info.get_root()
	var track_item = track_info.create_item(root)
	track_item.set_text(0, track_name)
	
	var track = track_scene.instantiate()
	
	track.track_name = track_name
	track.clip_changed.connect(_on_track_clip_changed)
	
	tracks.add_child(track)
	
	var track_item_rect = track_info.get_item_area_rect(track_item)
	track.custom_minimum_size.y = track_item_rect.size.y
	
	add_track_name_input.text = ""
	add_track_dialog.hide()

func _on_add_track_name_input_submitted(new_text: String) -> void:
	_on_add_track_dialog_confirmed()

func _on_track_info_item_mouse_selected(click_position: Vector2, mouse_button_index: int) -> void:
	var track_item = track_info.get_item_at_position(click_position)
	selected_track = track_item
	
func _on_track_clip_selected(track_name: String, clip_position: Vector2) -> void:
	print("_on_track_clip_selected ", track_name, clip_position)
	
func _on_track_clip_changed(track_name, clip_name: String, clip_position: Vector2, clip_size: Vector2) -> void:
	print("_on_track_clip_changed ", track_name, clip_name, clip_position, clip_size)
