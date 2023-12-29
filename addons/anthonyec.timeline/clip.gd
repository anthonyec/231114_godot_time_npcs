@tool
extends Button

signal clip_changed(clip_name: String, clip_position: Vector2, clip_size: Vector2)

@export var clip_name: String
@export var is_selected: bool = false
@export var is_drag_proxy: bool = false
@export var snap_positions: Vector2 = Vector2(-1, -1)

var start_mouse_position: Vector2
var start_size: Vector2
var start_position: Vector2

var is_moving_clip: bool = false
var is_resizing_left: bool = false
var is_resizing_right: bool = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if is_drag_proxy:
		position.y = 10
		
	if is_moving_clip:
		var delta_mouse_position = get_global_mouse_position() - start_mouse_position
		var new_position = Vector2(start_position.x + delta_mouse_position.x, start_position.y)
		
		position = clamp_position(new_position)
		clip_changed.emit(clip_name, position, size)
		
	if is_resizing_left:
		var delta_mouse_position = get_global_mouse_position() - start_mouse_position
		var new_size = Vector2(start_size.x - delta_mouse_position.x, start_size.y)
		var new_position = Vector2(start_position.x + delta_mouse_position.x, start_position.y)
		
		position = clamp_position(new_position)
		size = new_size
		clip_changed.emit(clip_name, position, size)
		
	if is_resizing_right:
		var delta_mouse_position = get_global_mouse_position() - start_mouse_position
		var new_size = Vector2(start_size.x + delta_mouse_position.x, start_size.y)
		
		size = new_size
		clip_changed.emit(clip_name, position, size)

func clamp_position(new_position: Vector2) -> Vector2:
	return Vector2(clamp(new_position.x, 0, INF), new_position.y)

func _on_button_down() -> void:
	start_mouse_position = get_global_mouse_position()
	start_position = position
	
	is_moving_clip = true

func _on_button_up() -> void:
	is_moving_clip = false

func _on_left_handle_button_down() -> void:
	is_resizing_left = true
	
	start_mouse_position = get_global_mouse_position()
	start_size = size
	start_position = position
	
	grab_focus()

func _on_left_handle_button_up() -> void:
	is_resizing_left = false

func _on_right_handle_button_down() -> void:
	is_resizing_right = true
	
	start_mouse_position = get_global_mouse_position()
	start_size = size
	
	grab_focus()

func _on_right_handle_button_up() -> void:
	is_resizing_right = false
