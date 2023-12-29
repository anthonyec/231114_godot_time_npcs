@tool
extends Panel

signal clip_added(track_name: String, clip_position: Vector2)
signal clip_changed(track_name: String, clip_name: String, clip_position: Vector2, clip_size: Vector2)

const clip_scene = preload("res://addons/anthonyec.timeline/clip.tscn")

@export var track_name: String

@onready var context_menu: PopupMenu = $ContextMenu

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		event = (event as InputEventMouseButton)
		
		grab_focus()
		
		if event.double_click:
			add_clip(get_local_mouse_position())
		
		if event.button_index == 2:
			context_menu.show()

func _on_context_menu_index_pressed(index: int) -> void:
	pass
	#match index:
		#0: add_clip

func _on_clip_changed(clip_name: String, clip_position: Vector2, clip_size: Vector2) -> void:
	clip_changed.emit(track_name, clip_name, clip_position, clip_size)

func add_clip(clip_position: Vector2) -> void:
	var clip = clip_scene.instantiate()
	
	clip.clip_name = "TEST"
	clip.clip_changed.connect(_on_clip_changed)
	
	add_child(clip)
	
	clip.position.x = clip_position.x
	clip.position.y = 0
	clip.size.x = 100
	clip.custom_minimum_size.y = custom_minimum_size.y
	
	clip_added.emit(track_name, clip_position)
