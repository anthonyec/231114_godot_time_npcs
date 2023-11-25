class_name CameraZone
extends Area3D

@export var switch_to_camera: Camera3D

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
func _on_area_entered(area: Area3D) -> void:
	var groups = area.get_groups()
	
	if not groups.has("player"):
		return
		
	var current_camera = get_viewport().get_camera_3d()
	current_camera.current = false
	switch_to_camera.current = true
	
func _on_area_exited(area: Area3D) -> void:
	var groups = area.get_groups()
	
	if not groups.has("player"):
		return
