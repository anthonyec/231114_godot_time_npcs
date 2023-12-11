class_name NPCSchedule
extends Node

static var instance: NPCSchedule = null

var schedule: Array[Dictionary] = [
	{
		"npc": "john",
		"start_time": [8, 30],
		"end_time": [9, 0],
		"level": "pier",
		"location": "PierEndLower"
	},
		{
		"npc": "john",
		"start_time": [9, 0],
		"end_time": [10, 30],
		"level": "pier",
		"location": "PierEndMiddle"
	},
	{
		"npc": "john",
		"start_time": [10, 30],
		"end_time": [11, 00],
		"level": "pier",
		"location": "PierEndLower"
	},
	{
		"npc": "john",
		"start_time": [11, 30],
		"end_time": [12, 30],
		"level": "pier",
		"location": "PierWater"
	},
		{
		"npc": "john",
		"start_time": [12, 30],
		"end_time": [13, 0],
		"level": "pier",
		"location": "PierEndLower"
	},
	{
		"npc": "john",
		"start_time": [8, 30],
		"end_time": [8, 40],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "john",
		"start_time": [8, 40],
		"end_time": [8, 50],
		"level": "test_room_2",
		"location": "BottomOfStairs"
	},
	{
		"npc": "john",
		"start_time": [8, 50],
		"end_time": [9, 00],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "john",
		"start_time": [9, 00],
		"end_time": [9, 10],
		"level": "test_room_2",
		"location": "BottomOfStairs"
	},
	{
		"npc": "mark",
		"start_time": [8, 35],
		"end_time": [9, 00],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "mao",
		"start_time": [8, 36],
		"end_time": [9, 00],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
	{
		"npc": "anthony",
		"start_time": [8, 38],
		"end_time": [9, 00],
		"level": "test_room",
		"location": "BottomOfStairs"
	},
]

func _ready() -> void:
	if instance != null:
		push_error("NPCSchedule instance already exists in this scene, overriding previous")
		
	instance = self
	
	var world = World.instance
	world.minute_tick.connect(_on_world_minute_tick)
	
func _on_world_minute_tick() -> void:
	var game = Game.instance
	var world = World.instance
	var events = query_events(world.hour, world.minute)
	
	for event in events:
		var event_npc_name = event.get("npc")
		var event_level = event.get("level")
		assert_valid_event(event)
		
		var existing_npc = world.find_npc_or_null(event_npc_name)
		
		if existing_npc:
			var target_position = get_npc_target_position(event_npc_name)
			existing_npc.set_schedule_event(target_position)
		else:
			if event_level == game.current_level_name:
				var level_portals := world.get_level_portals()
				
				var npc = world.spawn_npc_or_null(event_npc_name)
				if not npc: return
				
				if not level_portals.is_empty():
					# TODO: Choose level portal based on previous event location.
					npc.global_position = level_portals[0].global_position

# TODO: Maybe this shouldn't be an event.
func _on_game_level_loaded(_level_name: String) -> void:
	spawn_npcs_if_needed()
	
func query_events(hour: int, minute: int, npc_name: String = "") -> Array[Dictionary]:
	var current_timestamp = get_timestamp(hour, minute)
	var events: Array[Dictionary] = []
	
	for event in schedule:
		assert_valid_event(event)
		
		var event_start_time = event.get("start_time") as Array[int]
		var event_end_time = event.get("end_time") as Array[int]
		
		var start_timestamp = get_timestamp(event_start_time[0], event_start_time[1])
		var end_timestamp = get_timestamp(event_end_time[0], event_end_time[1])
		
		var match_npc_name = true if npc_name.is_empty() else npc_name == event.get("npc")
		
		if match_npc_name and current_timestamp >= start_timestamp and current_timestamp < end_timestamp:
			events.append(event)
		
	return events
	
func get_current_events_for_npc(npc_name: String) -> Array[Dictionary]:
	var world = World.instance
	return query_events(world.hour, world.minute, npc_name)

func spawn_npcs_if_needed() -> void:
	var game = Game.instance
	var world = World.instance
	var events = query_events(world.hour, world.minute)
	
	var events_by_npc: Dictionary = {}
	
	for event in events:
		var npc_name = event.get("npc")
		assert(npc_name, "Expected event to have npc")
		
		var level = event.get("level")
		assert(level, "Expected event to have level")
		
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
		assert_valid_event(first_event)
		
		var existing_npc = world.find_npc_or_null(npc_name)
		if existing_npc: continue
		
		var npc = world.spawn_npc_or_null(npc_name)
		assert(npc, "Expected to spawn NPC but could not")
	
		var target_position = get_npc_target_position(npc_name)
		npc.set_schedule_event(target_position)
		npc.global_position = target_position

func get_timestamp(hour: int, minute: int) -> int:
	# https://stackoverflow.com/a/51011191
	return minute * 60 + hour * 3600
	
func should_npc_be_in_level(npc_name: String, level_name: String) -> bool:
	var world = World.instance
	var events = query_events(world.hour, world.minute)
	
	for event in events:
		var event_npc_name = event.get("npc")
		assert(event_npc_name, "Expected event to have npc")
		
		var event_level = event.get("level")
		assert(event_level, "Expected event to have level")
		
		if npc_name.to_lower() == event_npc_name.to_lower() and level_name.to_lower() == event_level.to_lower():
			return true
	
	return false

func get_npc_target_position(npc_name: String) -> Vector3:
	var world = World.instance
	var events = query_events(world.hour, world.minute, npc_name)
	
	if events.is_empty(): 
		push_warning("No events found for npc: " + npc_name)
		return Vector3.ZERO # TODO: Return null.
	
	var event = events[0] # TODO: Pioritise
	assert_valid_event(event) # TODO: Replace events with a class object so keys always there.
	
	var game = Game.instance
	
	# TODO: Add helper to get level name to world or game?
	if event.level != game.current_level_name:
		var level_portal_node = world.find_level_portal_or_null(event.level)
		
		if not level_portal_node:
			push_warning("No level_portal node found in level: ", event.level)
			return Vector3.ZERO
		
		return level_portal_node.global_position
	
	var location_node = world.find_node_or_null(event.location)
	
	if not location_node: 
		push_warning("No location node found in level: ", event.location)
		return Vector3.ZERO
	
	return location_node.global_position

func assert_valid_event(event: Dictionary) -> void:
	assert(event.get("npc"), "Expected event to have npc")
	assert(event.get("location"), "Expected event to have location")
	assert(event.get("start_time"), "Expected event to have start_time")
	assert(event.get("end_time"), "Expected event to have end_time")
