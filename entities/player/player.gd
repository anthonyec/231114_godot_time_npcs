class_name Player
extends Character

@onready var state_machine = $StateMachine as StateMachine

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_PLAYER):
		DebugDraw.set_text("Player state", state_machine.get_current_state_path())
