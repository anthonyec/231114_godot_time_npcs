class_name NPC
extends Character

@export var npc_name: String
@export var target_position: Vector3 = Vector3(7.4, 7.3, 7.9)

@onready var nav_agent = $NavigationAgent3D as NavigationAgent3D

func _ready() -> void:
	nav_agent.target_position = Vector3(7.4, 7.3, 7.9)

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_NAV_AGENT):
		DebugDraw.draw_cube(target_position, 0.3, Color.WHITE)
		DebugDraw.draw_ray_3d(target_position, Vector3.UP, 5, Color.WHITE)
		
		var points = nav_agent.get_current_navigation_path()
		
		for index in points.size() - 1:
			var point = points[index]
			var next_point = points[index + 1]
			DebugDraw.draw_line_3d(point, next_point, Color.WHITE)

