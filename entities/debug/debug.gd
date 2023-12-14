class_name Debug
extends Node

var show_menu: bool = false
var menu: Array[Dictionary] = [
	{
		"label": "Levels",
		"items": get_levels_menu
	},
	{
		"label": "Places",
		"items": get_places_menu
	},
	{
		"label": "Cameras",
		"items": get_cameras_menu
	},
	{
		"label": "Schedule",
		"items": get_schedule_menu
	},
	{
		"label": "NPCs",
		"items": get_npcs_menu
	},
	{
		"label": "Flags",
		"items": get_flags_menu
	}
]

var current_menu: Array[Dictionary] = menu
var current_menu_getter: Callable
var current_index: Array[int] = [0]

func get_flags_menu() -> Array[Dictionary]:
	var items: Array[Dictionary]

	var flags = Flags.new()
	var script = flags.get_script() as Script
	var code = script.source_code
	
	var regex = RegEx.new()
	regex.compile("const (.+)")
	
	for result in regex.search_all(code):
		var flag_name = result.get_string().replace("const ", "").split(" = ")[0].strip_edges()
		
		items.append({
			"label": flag_name,
			"action": func(): Flags.toggle(flag_name),
			"is_active": Flags.is_enabled(flag_name)
		})

	return items

func get_schedule_menu() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for event in NPCSchedule.instance.schedule:
		var npc = event.get("npc", "")
		var start_time = event.get("start_time", [0, 0])
		var location = event.get("location", "")
		var level = event.get("level", "")
		
		items.append({
			"label": str(start_time[0]) + ":" + str(start_time[1]) + "  " + npc + " " + level + " " + location,
			"action": func(): World.instance.hour = start_time[0]; World.instance.minute = start_time[1]
		})
	
	return items

func get_levels_menu() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	var directory = DirAccess.open("res://levels")
	if not directory: return items
	
	directory.list_dir_begin()
	var filename = directory.get_next()
	
	while filename:
		items.append({
			"label": filename,
			"action": func(): Game.instance.load_level(filename)
		})
		
		filename = directory.get_next()	
	
	return items
	
func _on_highlight_place_menu_item(marker_name: String) -> void:
	var marker = World.instance.find_node_or_null(marker_name)
	if not marker: return
	
	DebugDraw.draw_cube(marker.global_position, 1, Color.BLACK)
	
func get_places_menu() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for marker in World.instance.get_place_markers():
		items.append({
			"label": marker.name,
			"highlight_action": _on_highlight_place_menu_item.bind(marker.name),
			"action": func():
				var player = World.instance.get_player_or_null()
				if not player: return
				
				World.instance.teleport_player(marker.global_position)
		})
		
	if items.is_empty():
		items.append({ "label": "No place markers found in level" })
	
	return items
	
func get_cameras_menu() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for camera in World.instance.get_cameras():
		items.append({
			"label": camera.name,
			"action": camera.make_current,
			"is_active": camera.current
		})

	return items
	
func get_npcs_menu() -> Array[Dictionary]:
	var items: Array[Dictionary]
	
	for npc in World.instance.get_npcs():
		items.append({
			"label": npc.npc_name,
			"action": func(): World.instance.teleport_player(npc.global_position),
		})

	return items
	
func goto_menu(items: Array[Dictionary], menu_getter = null, keep_index: bool = false) -> void:
	if menu_getter and typeof(menu_getter) == TYPE_CALLABLE:
		current_menu_getter = menu_getter
	
	if not keep_index:
		current_index.append(0)
		
	current_menu = items
	
func navigate_menu(direction: int) -> void:
	current_index[-1] = wrapi(current_index[-1] + direction, 0, current_menu.size())
	pass

func _process(_delta: float) -> void:
	var world = World.instance
	
	DebugDraw.set_text("Time", world.get_display_time() + " Day: " + str(world.day))
	
	if not show_menu:
		DebugDraw.set_text("Debug", "Press [ESC] to open menu")
	else:
		DebugDraw.set_text("Debug", "Press [ESC] to go back / close menu, [UP/DOWN] to navigate, [ENTER] to select")
	
	if not show_menu and Input.is_action_pressed("ui_up"):
		world.tick_per_milliseconds = 0
		
	if not show_menu and not Input.is_action_pressed("ui_up"):
		world.tick_per_milliseconds = 1000
		
	if not show_menu and Input.is_action_just_pressed("ui_cancel"):
		show_menu = true
	elif show_menu and Input.is_action_just_pressed("ui_cancel"):
		if current_menu == menu:
			show_menu = false
			
		if current_menu != menu:
			current_menu = menu
			current_index.pop_back()
		
	if show_menu:
		if Input.is_action_just_pressed("ui_down"):
			navigate_menu(1)
			
		if Input.is_action_just_pressed("ui_up"):
			navigate_menu(-1)
			
		if Input.is_action_just_pressed("ui_accept"):
			var current_menu_item = current_menu[current_index[-1]]
			var action = current_menu_item.get("action")
			
			if action and typeof(action) == TYPE_CALLABLE:
				(action as Callable).call()
				
				if current_menu_getter:
					goto_menu(current_menu_getter.call(), current_menu_getter, true)
				
				return
			
			var items = current_menu_item.get("items")
			if not items: return
			
			if typeof(items) == TYPE_CALLABLE:
				return goto_menu((items as Callable).call() as Array[Dictionary], (items as Callable))
				
			if typeof(items) == TYPE_ARRAY:
				return goto_menu((items as Array[Dictionary]))
				
		DebugDraw.set_text("DEBUG MENU")
		
		for index in current_menu.size():
			var item = current_menu[index]
			var selected = current_index[-1] == index
			var highlight = "<<" if selected else ""
			var active = "[X] " if item.get("is_active", false) else ""
			
			if selected:
				var highlight_action = item.get("highlight_action", func(): pass) as Callable
				highlight_action.call()
			
			DebugDraw.set_text(item.get("label", ""), active + highlight)
	
