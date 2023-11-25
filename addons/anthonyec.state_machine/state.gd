class_name State
extends Node

var state_machine: StateMachine = null
var parent_state: State = null

## Invoked when transitioning to this state. Used for setup and
## handling any paramaters passed from the previous state.
func enter(params: Dictionary) -> void:
	pass

## Invoked when transitioning to another state. Generally used
## for cleanup, it also will yield if `await` is used inside of it.
func exit() -> void:
	pass

## Equivalent to `_ready`.
func awake() -> void:
	pass

## Equivalent to `_process`.
func update(delta: float) -> void:
	pass

## Equivalent to `_physics_process`.
func physics_update(delta: float) -> void:
	pass

## Equivalent to `_input`.
func handle_input(event: InputEvent) -> void:
	pass

## Handle messages that have been sent to the state machine.
##
## This is useful for when another script wants to change
## the state, but avoids forefully transitioning by using
## `transition_to` on directly state machine.
func handle_message(title: String, params: Dictionary) -> void:
	pass
