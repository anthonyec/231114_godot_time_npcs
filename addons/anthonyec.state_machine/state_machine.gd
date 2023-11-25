## Simple code only state machine that's is originally based off GDQuest's implementation:
## https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name StateMachine
extends Node

## Fired after a state change.
signal state_changed(previous_state: State, next_state: State, params: Dictionary)

# Additional signal "hooks" for debugging purposes.
signal state_transition_requested(state_name: String, params: Dictionary)
signal state_deferred_transition_requested(state_name: String, params_callback: Callable)
signal state_entered(state: State, params: Dictionary)
signal state_exited(state: State)
signal state_updated(state: State)
signal state_physics_updated(state: State)
signal state_inputed(state: State)

var previous_state: State
var current_state: State
var current_parent_state: State
var time_in_current_state: int
var _deferred_transitions: Array[Callable] = []

func _ready() -> void:
	await owner.ready

	assert(get_child_count(), "No states provided as children")

	# Recursively setup child and sub-child state.
	_setup_child_states(self)

	var initial_state: State = get_child(0)
	transition_to(initial_state.name)

func _input(event: InputEvent) -> void:
	if current_parent_state:
		state_inputed.emit(current_parent_state)
		current_parent_state.handle_input(event)

	state_inputed.emit(current_state)
	current_state.handle_input(event)

func _process(delta: float) -> void:
	if current_parent_state:
		state_updated.emit(current_parent_state)
		current_parent_state.update(delta)

	state_updated.emit(current_state)
	current_state.update(delta)

	# TODO: Is the correct way to time stuff or should there be another unit
	# based on frames? What happens if there's a low frame-rate?
	time_in_current_state += int(delta * 1000)

func _physics_process(delta: float) -> void:
	if current_parent_state:
		state_physics_updated.emit(current_parent_state)
		current_parent_state.physics_update(delta)

	# It's very important to emit the signal before invoking the method
	# because the `current_state` could change during the method invokation.
	# For example, if `transition_to("B")` is called during state A, emitting
	# the signal afterwards would result in reporting state B is active which is
	# incorrect. Note that this applies for all state methods and signals, not
	# just `physics_update`.
	state_physics_updated.emit(current_state)
	current_state.physics_update(delta)

	# Perform any transitions that have been deferred.
	if not _deferred_transitions.is_empty():
		_deferred_transitions[0].call()
		_deferred_transitions.clear()

func _setup_child_states(node: Node, has_parent_state: bool = false, depth: int = 0) -> void:
	assert(depth <= 2, "Only 1 level of nested states is supported. Move '" + str(node.name) + "' up a level")

	for child in node.get_children():
		if not (child is State):
			continue

		child.state_machine = self
		child.parent_state = node if has_parent_state else null
		child.awake()

		if child.has_method("_process"):
			push_warning(child.name + " state has implemented `_process` which will get invoked even if the state is not active. Did you mean to use `update` instead?")

		if child.has_method("_physics_update"):
			push_warning(child.name + " state has implemented `_physics_update` which will get invoked even if the state is not active. Did you mean to use `physics_update` instead?")

		if child.has_method("_input"):
			push_warning(child.name + " state has implemented `_input` which will get invoked even if the state is not active. Did you mean to use `handle_input` instead?")

		if child.has_method("_ready"):
			push_warning(child.name + " state has implemented `_ready` which will get invoked even if the state machine is disabled. Did you mean to use `awake` instead?")

		_setup_child_states(child, true, depth + 1)

## Transition to a state using the name of the node.
func transition_to(state_name: String, params: Dictionary = {}) -> void:
	state_transition_requested.emit(state_name, params)

	var next_state: State = get_node_or_null(state_name) as State
	assert(next_state, "No state found with the name '" + state_name + "'")

	# If the next state is a parent of many states, transition to the first sub-state.
	if next_state.get_child_count() > 0:
		next_state = next_state.get_child(0)

	var is_different_parent_state = current_parent_state != next_state.parent_state

	previous_state = current_state

	if current_state:
		state_exited.emit(current_state)

		# TODO: Not sure if always yielding for asynchronous logic is a good
		# idea. Is there performance implications? And the current state `update`
		# method will be called after `exit` if it's yielding, which seems unexpected.
		await current_state.exit()

	if is_different_parent_state and current_parent_state:
		state_exited.emit(current_parent_state)

		# TODO: Not sure if I'm keeping `await`. See comment above.
		await current_parent_state.exit()

	current_parent_state = next_state.parent_state
	current_state = next_state

	if is_different_parent_state and current_parent_state:
		state_entered.emit(current_parent_state, params)
		current_parent_state.enter(params)

	state_entered.emit(current_state, params)
	current_state.enter(params)

	# This signal is emitted after invoking the method because it provides
	# both previous and current state as arguments.
	state_changed.emit(previous_state, current_state, params)
	time_in_current_state = 0

## Transition to the previous state. Note that only one previous state is stored 
## at a time, thus calling multiple times could end alternating between states.
##
## Usage: A player either in the run or walk state can transition to a 
## "pick up object" state and then return back to running or walking.
func transition_to_previous_state() -> void:
	transition_to(previous_state.name)

## Wait until the current state's `physics_update` has been completed before
## transitioning to the new state. Params are returned from a callback to ensure
## any variables references are using the latest values.
##
## Usage: Transition params rely on calculations from `physics_update`, and you
## want to ensure atleast one calcuation has happened before transition.
func deferred_transition_to(state_name: String, params_callback: Callable) -> void:
	assert(_deferred_transitions.is_empty(), "Only one transition can be deferred at a time.")

	state_deferred_transition_requested.emit(state_name, params_callback)

	_deferred_transitions.append(func():
		var params = params_callback.call()
		transition_to(state_name, params)
	)

## Send a message to the current state to handle.
func send_message(title: String, params: Dictionary = {}) -> void:
	if current_parent_state:
		current_parent_state.handle_message(title, params)

	current_state.handle_message(title, params)

## Return the path of the current parent and substate. E.g "Grounded/Run"
func get_current_state_path() -> String:
	var path: String = ""

	if current_parent_state:
		path += current_parent_state.name + "/"

	path += current_state.name
	return path
