class_name NPCSchedule
extends Node

static var instance: NPCSchedule = null

class Event:
	var start_time: int
	var end_time: int
	var npc: String
	var level: String
	var location: String
	var dialogue: String
	
	func _init(start_time: int, end_time: int) -> void:
		self.start_time = start_time
		self.end_time = end_time
	
	func get_start_display_time() -> String:
		var hours = floor(float(start_time) / 100)
		var minutes = start_time % 100
		
		return str(hours).lpad(2, "0") + ":" + str(minutes).lpad(2, "0")
		
	func get_end_display_time() -> String:
		var hours = floor(float(end_time) / 100)
		var minutes = end_time % 100
		
		return str(hours).lpad(2, "0") + ":" + str(minutes).lpad(2, "0")
		
	func set_npc(npc_name: String) -> Event:
		self.npc = npc_name
		return self
		
	func set_level(level: String) -> Event:
		self.level = level
		return self
		
	func set_location(location: String) -> Event:
		self.location = location
		return self
		
	func set_dialogue(dialogue_name: String) -> Event:
		self.dialogue = dialogue_name
		return self
		
	func _to_string() -> String:
		return "<NPCSchedule.Event " + get_start_display_time() + ">"

var events: Array[Event] = [
	Event.new(08_30, 09_00).set_npc("john").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.PIER_END_LOWER),
	Event.new(09_00, 10_30).set_npc("john").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.PIER_END_MIDDLE),
	Event.new(10_30, 12_00).set_npc("john").set_level(Metadata.Levels.CAFE_WALK).set_location(Metadata.Places.CafeWalk.CAFE_SIDE_BIT),
	Event.new(12_30, 14_00).set_npc("john").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.PIER_END_LOWER),
	Event.new(13_30, 15_00).set_npc("john").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.BEACH),
	
	Event.new(8_00, 10_00).set_npc("steve").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.BEACH),
	Event.new(10_00, 12_00).set_npc("steve").set_level(Metadata.Levels.CAFE_WALK).set_location(Metadata.Places.CafeWalk.CAFE_SIDE_BIT),
	Event.new(12_00, 13_00).set_npc("steve").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.BEACH),
	
	Event.new(11_00, 13_00).set_npc("mary").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.END_PIER_LAMPOST),
	Event.new(13_00, 14_00).set_npc("mary").set_level(Metadata.Levels.PIER).set_location(Metadata.Places.Pier.PIER_END_UPPER),
]

func _ready() -> void:
	if instance != null: push_error("NPCSchedule instance already exists in this scene, overriding previous")
	instance = self
	
	var world = World.instance
	world.minute_tick.connect(_on_world_minute_tick)
	
	# Sort by start time. Not required to tell NPCs what to do since the whole
	# list is currently looped over every tick, but means less sorting elsewhere.
	events.sort_custom(func(a: Event, b: Event):
		return a.start_time < b.start_time
	)

func _on_world_minute_tick() -> void:
	var game = Game.instance
	var world = World.instance
	var events_at_time = query_events(world.time)
	
	for event in events_at_time:
		var existing_npc = world.find_npc_or_null(event.npc)
		
		if existing_npc:
			var target_position = get_npc_target_position(event.npc)
			existing_npc.set_schedule_event(target_position)
		else:
			if event.level == game.current_level_name:
				var level_portals := world.get_level_portals()
				
				var npc = world.spawn_npc_or_null(event.npc)
				if not npc: return
				
				if not level_portals.is_empty():
					# TODO: Choose level portal based on previous event location.
					npc.global_position = level_portals[0].global_position

# TODO: Maybe this shouldn't be an event.
func _on_game_level_loaded(_level_name: String) -> void:
	spawn_npcs_if_needed()
	
func query_events(start_time: int, npc_name: String = "") -> Array[Event]:
	var found_events: Array[Event] = []
	
	for event in events:
		var is_within_time_range = start_time >= event.start_time and start_time < event.end_time
		var is_match_npc_name = true if npc_name.is_empty() else npc_name == event.npc
		
		if is_match_npc_name and is_within_time_range:
			found_events.append(event)
		
	return found_events
	
func get_current_events_for_npc(npc_name: String) -> Array[Event]:
	var world = World.instance
	return query_events(world.time, npc_name)

func spawn_npcs_if_needed() -> void:
	var game = Game.instance
	var world = World.instance
	var events_at_time = query_events(world.time)
	
	var events_by_npc: Dictionary = {}
	
	for event in events_at_time:
		if event.level != game.current_level_name:
			continue
		
		if not events_by_npc.has(event.npc):
			events_by_npc[event.npc] = []
			
		var npc_events = events_by_npc.get(event.npc, []) as Array[Event]
		npc_events.append(event)
	
	for npc_name in events_by_npc:
		var npc_events = events_by_npc.get(npc_name) as Array[Event]
		var first_event = npc_events[0] # TODO: Sort events by piority one day.
		assert(first_event, "Expected to be at least one event in array")
		
		var existing_npc = world.find_npc_or_null(npc_name)
		if existing_npc: continue
		
		var npc = world.spawn_npc_or_null(npc_name)
		assert(npc, "Expected to spawn NPC but could not")
	
		var target_position = get_npc_target_position(npc_name)
		npc.set_schedule_event(target_position)
		npc.global_position = target_position

func should_npc_be_in_level(npc_name: String, level_name: String) -> bool:
	var world = World.instance
	var events_at_time = query_events(world.time)
	
	for event in events_at_time:
		if npc_name.to_lower() == event.npc.to_lower() and level_name.to_lower() == event.level.to_lower():
			return true
	
	return false

func get_npc_target_position(npc_name: String) -> Vector3:
	var world = World.instance
	var events_at_time = query_events(world.time, npc_name)
	
	if events_at_time.is_empty(): 
		push_error("No events found for npc: " + npc_name)
		return Vector3.ZERO # TODO: Return null.
	
	var game = Game.instance
	var event = events_at_time[0] # TODO: Pioritise
	
	# TODO: Add helper to get level name to world or game?
	if event.level != game.current_level_name:
		var level_portal_node = world.find_level_portal_or_null(event.level)
		
		# TODO: Find a better way to handle this? Fade out character? Assert?
		if not level_portal_node:
			push_error("No level_portal found for level: ", event.level)
			return Vector3.ZERO
		
		return level_portal_node.global_position
	
	var location_node = world.find_node_or_null(event.location)
	
	if not location_node: 
		push_error("No location node found in level: ", event.location)
		return Vector3.ZERO
	
	return location_node.global_position
