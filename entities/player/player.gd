class_name Player
extends Character

@onready var state_machine = $StateMachine as StateMachine
@onready var model = $Model as Node3D
@onready var animation = $Model/AnimationPlayer as AnimationPlayer

var last_grounded_position: Vector3

func _process(_delta: float) -> void:
	if Flags.is_enabled(Flags.DEBUG_PLAYER):
		DebugDraw.set_text("Player", state_machine.get_current_state_path(), global_position)

func request_conversation() -> void:
	state_machine.send_message("start_conversation")
