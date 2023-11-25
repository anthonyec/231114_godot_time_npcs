class_name Player
extends CharacterBody3D

@export var walk_speed: float = 3

var move_direction: Vector3

func _process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = Vector3(input_direction.x, 0, input_direction.y)
	
	move_direction = Utils.tansform_direction_to_camera_angle(
		get_viewport().get_camera_3d(),
		Vector3(input_direction.x, 0, input_direction.y)
	)
	
	DebugDraw.draw_ray_3d(global_position, direction, 1, Color.WHITE)

func _physics_process(delta: float) -> void:
	Utils.face_towards(self, global_position + move_direction, 10, delta)
	
	velocity = move_direction * walk_speed
	move_and_slide()
