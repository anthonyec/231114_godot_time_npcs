class_name NPCSchedule
extends Node

static var instance: NPCSchedule = null

var schedule: Array[Dictionary] = [
	{
		"npc": "mark",
		"start_time": [8, 0],
		"end_time": [10, 0],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "mark",
		"start_time": [10, 0],
		"end_time": [10, 30],
		"level": "test_room",
		"location": "TopOfStairs"
	}, 
	{
		"npc": "mark",
		"start_time": [11, 0],
		"end_time": [13, 0],
		"level": "test_room_2",
		"location": "unknown"
	}
]

func _ready() -> void:
	if instance != null:
		push_error("NPCSchedule instance already exists in this scene, overriding previous")
		
	instance = self
	
	var world = World.instance
	world.minute_tick.connect(_on_world_minute_tick)
	
func _on_world_minute_tick() -> void:
	var world = World.instance
	var events = get_events_for_time(world.hour, world.minute)
	
	for event in events:
		var npc_name = event.get("npc")
		assert(npc_name, "Expected event to have npc")
		
		var existing_npc = world.find_npc_or_null(npc_name)
		
		if existing_npc:
			existing_npc.set_schedule_event(event)
			continue

# TODO: Maybe this shouldn't be an event.
func _on_game_level_loaded(level_name: String) -> void:
	spawn_npcs_if_needed()
	
func spawn_npcs_if_needed() -> void:
	var game = Game.instance
	var world = World.instance
	var events = get_events_for_time(world.hour, world.minute)
	
	var events_by_npc: Dictionary = {}
	
	for event in events:
		var npc_name = event.get("npc")
		assert(npc_name, "Expected event to have npc")
		
		var level = event.get("level")
		assert(npc_name, "Expected level to have npc")
		
		# TODO: Nicer way?
		if level != game.current_level_name:
			continue
		
		if not events_by_npc.has(npc_name):
			events_by_npc[npc_name] = []
			
		var npc_events = events_by_npc.get(npc_name, []) as Array[Dictionary]
		npc_events.append(event)
	
	for npc_name in events_by_npc:
		var npc_events = events_by_npc.get(npc_name) as Array[Dictionary]
		var first_event = npc_events[0] # TODO: Sort events by piority one day.
		assert(first_event, "Expected to be at least one event in array")
		
		var location = first_event.get("location")
		assert(location, "Expected event to have location")
		
		var existing_npc = world.find_npc_or_null(npc_name)
		if existing_npc: continue
		
		var npc = world.spawn_npc_or_null(npc_name)
		assert(npc, "Expected to spanw NPC but could not")
	
		npc.set_schedule_event(first_event)
		
		var location_node = world.find_node_or_null(location)
		if not location_node: continue
		
		npc.global_position = location_node.global_position

func get_timestamp(hour: int, minute: int) -> int:
	# https://stackoverflow.com/a/51011191
	return minute * 60 + hour * 3600

func get_events_for_time(hour: int, minute: int) -> Array[Dictionary]:
	var current_timestamp = get_timestamp(hour, minute)
	var events: Array[Dictionary] = []
	
	for event in schedule:
		var start_time = event.get("start_time")
		var end_time = event.get("end_time")
		assert(start_time != null and end_time != null, "Expected event to have start and end time")
		
		var start_timestamp = get_timestamp(start_time[0], start_time[1])
		var end_timestamp = get_timestamp(end_time[0], end_time[1])
		
		if current_timestamp >= start_timestamp and current_timestamp <= end_timestamp:
			events.append(event)
		
	return events
	
func should_npc_be_in_level(npc_name: String, level_name: String) -> bool:
	var world = World.instance
	var events = get_events_for_time(world.hour, world.minute)
	
	for event in events:
		var event_npc_name = event.get("npc")
		assert(event_npc_name, "Expected event to have npc")
		
		var event_level = event.get("level")
		assert(event_level, "Expected event to have level")
		
		if npc_name.to_lower() == event_npc_name.to_lower() and level_name.to_lower() == event_level.to_lower():
			return true
	
	return false
