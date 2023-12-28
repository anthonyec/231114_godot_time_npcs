class_name NPC
extends Character

@export var npc_name: String

@onready var state_machine = $StateMachine as StateMachine

func _ready() -> void:
	assert(get_groups().has("npc"), "NPC node needs to be in the npc group")
	id = npc_name

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_NPCS):
		DebugDraw.set_text("NPC " + npc_name, move_state_machine.get_current_state_path() + ", " + control_state_machine.get_current_state_path(), global_position)

func can_have_conversation() -> bool:
	return control_state_machine.current_state.name == "None"
	
func set_schedule_event(target_position: Vector3) -> void:
	# TODO: This is a hack. Find a way to find out if nav agent is ready.
	await get_tree().create_timer(0.5).timeout
	
	control_state_machine.transition_to("FollowPath", { "target": target_position })
