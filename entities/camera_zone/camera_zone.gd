@tool
class_name CameraZone
extends Area3D

@export var switch_to_camera: Camera3D
@export var bounds: Vector3 = Vector3(5, 5, 5)

@onready var collision = $CollisionShape3D as CollisionShape3D
@onready var mesh = $MeshInstance3D as MeshInstance3D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	(collision.shape as BoxShape3D).size = bounds
	(mesh.mesh as BoxMesh).size = bounds
	mesh.visible = false
		
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	
	(collision.shape as BoxShape3D).size = bounds
	(mesh.mesh as BoxMesh).size = bounds
	
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
