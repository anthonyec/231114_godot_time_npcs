class_name Character
extends CharacterBody3D

const WORLD_COLLISION_MASK: int = 1

@export var walk_speed: float = 3
@export var height: float = 2
@export var leg_height: float = 1

@onready var shape_cast = $ShapeCast3D as ShapeCast3D

var forward: Vector3: get = _get_forward

func _ready() -> void:
	up_direction = Vector3.UP
	floor_stop_on_slope = true
	
func _get_forward() -> Vector3:
	return -global_transform.basis.z

func transform_direction_to_camera_angle(direction: Vector3) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var camera_angle_y = camera.global_transform.basis.get_euler().y
	return direction.rotated(Vector3.UP, camera_angle_y)

func face_towards(target: Vector3, speed: float = 0.0, delta: float = 0.0) -> void:
	if global_transform.origin == target:
		return
		
	if is_zero_approx(speed):
		look_at(target, Vector3.UP)
		global_rotation.x = 0
		global_rotation.z = 0
	else:
		# From: https://github.com/JohnnyRouddro/3d_rotate_direct_constant_smooth/blob/master/rotate.gd
		var direction = global_transform.origin.direction_to(target)
		global_rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), speed * delta)

func is_on_ground() -> bool:
	if not shape_cast.is_colliding(): return false
	
	var fraction = shape_cast.get_closest_collision_safe_fraction()
	var floor_position = shape_cast.global_position.lerp(shape_cast.global_position + shape_cast.target_position, fraction)
	
	var shape = shape_cast.shape
	assert(shape is SphereShape3D)
	shape = shape as SphereShape3D
	
	var feet_position = global_transform.origin.y - (height / 2) # TODO: Add a foot height.
	
	return floor_position.y >= feet_position
	
func is_near_ground() -> bool:
	return shape_cast.is_colliding()
	
func snap_to_ground() -> void:
	if not shape_cast.is_colliding(): return
	
	var fraction = shape_cast.get_closest_collision_safe_fraction()
	var floor_position = shape_cast.global_position.lerp(shape_cast.global_position + shape_cast.target_position, fraction)
	
	var shape = shape_cast.shape
	assert(shape is SphereShape3D)
	shape = shape as SphereShape3D
	
	global_position.y = floor_position.y + (height / 2) - shape.radius
