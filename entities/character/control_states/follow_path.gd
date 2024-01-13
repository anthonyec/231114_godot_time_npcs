extends CharacterState

const next_distance_tolerance = Vector3(0.25, 2, 0.25)
const target_distance_tolerance = Vector3(0.5, 2, 0.5)

var align_to_target_position: bool
var navigation_index: int
var navigation_path: PackedVector3Array
var last_position: Vector3

func enter(params: Dictionary) -> void:
	var target_position = params.get("target")
	assert(target_position != null)
	
	align_to_target_position = params.get("align", false)
	
	character.nav_agent.debug_enabled = Flags.is_enabled(Flags.DEBUG_NAV_AGENT)
	
	character.reset_input()
	character.nav_agent.target_position = target_position
	
	await character.nav_agent.path_changed
	
	navigation_index = 0
	navigation_path = character.nav_agent.get_current_navigation_path()
	
func exit() -> void:
	character.reset_input()
	character.nav_agent.debug_enabled = false

func physics_update(_delta: float) -> void:
	if not character.nav_agent.is_target_reachable():
		return state_machine.transition_to("None")
	
	# TODO: Fix infinite spinning when not reaching destination completely sometimes.
	if Utils.is_near(character.global_position, character.nav_agent.target_position, target_distance_tolerance):
		if align_to_target_position:
			pass # TODO: Implement.
		
		state_machine.send_message(Metadata.StateMessages.FOLLOW_PATH_REACHED_TARGET)
		
		return state_machine.transition_to("None")
		
	var next_position = get_next_path_position()
	
	var next_direction = character.global_position.direction_to(next_position)
	next_direction.y = 0
	next_direction.normalized()
	
	if Flags.is_enabled(Flags.DEBUG_NAV_AGENT):
		DebugDraw.draw_cube(next_position, 0.15, Color.WHITE)
		DebugDraw.draw_ray_3d(next_position, Vector3.UP, 5, Color.WHITE)
		
		DebugDraw.draw_cube(character.nav_agent.get_final_position(), 0.2, Color.RED)
		DebugDraw.draw_ray_3d(character.nav_agent.get_final_position(), Vector3.UP, 5, Color.RED)
	
		DebugDraw.draw_ray_3d(character.global_position, next_direction, 1, Color.WHITE)
		DebugDraw.draw_ray_3d(character.global_position + Vector3.UP * 0.05, character.forward, 1, Color.CYAN)
	
	var dot = character.get_facing_dot_product(next_position)
	
	# This if statement fixes turn virbation.
	if not character.is_facing(next_position, 0.9):
		var turn_input = 1 if dot > 0 else -1
		character.turn_input = turn_input
	else:
		character.turn_input = dot
	
	# TODO: Fix start and stop vibration.
	if character.is_facing(next_position, 0.95):
		character.move_input = 1
	else:
		character.move_input = 0
	
# Using this instead of built-in get_next_path_position because I can't 
# get it to work. But also gives me more control over how it's decided the next
# position is reached, with a bigger Y axis tolerance.
func get_next_path_position() -> Vector3:
	if navigation_path.is_empty(): return Vector3.ZERO
	
	var index = clamp(navigation_index, 0, navigation_path.size() - 1)
	var next_position = navigation_path[index]
	
	if Utils.is_near(character.global_position, next_position, next_distance_tolerance):
		navigation_index += 1
	
	return next_position
