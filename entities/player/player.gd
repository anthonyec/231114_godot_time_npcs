class_name Player
extends Character

@onready var state_machine = $StateMachine as StateMachine

func _ready() -> void:
	assert(get_groups().has("player"), "Player node needs to be in the player group")

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_PLAYER):
		DebugDraw.set_text("Player state", "MoveFSM: %s, ControlFSM: %s, FSM: %s" % [move_state_machine.get_current_state_path(), control_state_machine.get_current_state_path(), state_machine.get_current_state_path()])
