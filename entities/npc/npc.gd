class_name NPC
extends Character

@export var npc_name: String

@onready var nav_agent = $NavigationAgent3D as NavigationAgent3D
@onready var model = $Model as Node3D
@onready var animation = $Model/AnimationPlayer as AnimationPlayer
@onready var state_machine = $StateMachine as StateMachine

func _ready() -> void:
	assert(get_groups().has("npc"), "NPC node needs to be in the npc group")

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_NPCS):
		DebugDraw.set_text("NPC " + npc_name, state_machine.get_current_state_path(), global_position)
	
	if Flags.is_enabled(Flags.DEBUG_NAV_AGENT):
		DebugDraw.draw_cube(nav_agent.target_position, 0.3, Color.WHITE)
		DebugDraw.draw_ray_3d(nav_agent.target_position, Vector3.UP, 5, Color.WHITE)
		
		var points = nav_agent.get_current_navigation_path()
		
		for index in points.size() - 1:
			var point = points[index]
			var next_point = points[index + 1]
			DebugDraw.draw_line_3d(point, next_point, Color.WHITE)
			
func request_conversation() -> void:
	state_machine.send_message("start_conversation")
	
func set_schedule_event(target_position: Vector3) -> void:
	# TODO: This is a hack. Find a way to find out if nav agent is ready.
	await get_tree().create_timer(0.5).timeout
	nav_agent.target_position = target_position
