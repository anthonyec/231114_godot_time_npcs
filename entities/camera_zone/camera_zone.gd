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
		
	connect("body_entered", _on_body_entered)
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		(collision.shape as BoxShape3D).size = bounds
		(mesh.mesh as BoxMesh).size = bounds

func activate() -> void:
	switch_to_camera.make_current()

func _on_body_entered(body: Node3D) -> void:
	var groups = body.get_groups()
	
	if groups.has("player"):
		activate()
