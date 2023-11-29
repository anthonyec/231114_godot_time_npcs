class_name NPC
extends Character

@export var npc_name: String

@onready var nav_agent = $NavigationAgent3D as NavigationAgent3D

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_NAV_AGENT):
		DebugDraw.draw_cube(nav_agent.target_position, 0.3, Color.WHITE)
		DebugDraw.draw_ray_3d(nav_agent.target_position, Vector3.UP, 5, Color.WHITE)
		
		var points = nav_agent.get_current_navigation_path()
		
		for index in points.size() - 1:
			var point = points[index]
			var next_point = points[index + 1]
			DebugDraw.draw_line_3d(point, next_point, Color.WHITE)
			
func set_schedule_event(event: Dictionary) -> void:
	var location = event.get("location")
	assert(location, "Expected event to have location")
	
	var world = World.instance
	var location_node = world.find_node_or_null(location)
	if not location_node: return
	
	# TODO: This is a hack. Find a way to find out if nav agent is ready.
	await get_tree().create_timer(0.5).timeout
	
	nav_agent.target_position = location_node.global_position

