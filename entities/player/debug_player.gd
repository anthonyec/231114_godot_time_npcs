extends Node

@onready var state_machine = $"../PlayerStateMachine" as StateMachine

func _process(delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_PLAYER):
		DebugDraw.set_text("Player state", state_machine.get_current_state_path())
