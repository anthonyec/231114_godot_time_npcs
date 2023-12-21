class_name DebugMenu
extends Control

const menu_item_font = preload("res://addons/zylann.debug_draw/Hack-Regular.ttf")
const menu_item_gutter: float = 1
const menu_item_padding: float = 2

var navigation_stack: Array[NavigationStackEntry] = []

class NavigationStackEntry:
	var index: int
	var entry: String
	var menu: Array[Dictionary]
	var reload: Callable
	var draw: Callable
	
	func _init(entry: String, menu: Array[Dictionary], reload: Callable = func(): pass, draw: Callable = func(_control: Control): pass) -> void:
		self.entry = entry
		self.menu = menu
		self.reload = reload
		self.draw = draw

func _ready() -> void:
	load_menu("root")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		back()
		
	if not visible: return
		
	if event.is_action_pressed("ui_down"):
		navigate(1)
		
	if event.is_action_pressed("ui_up"):
		navigate(-1)
		
	if event.is_action_pressed("ui_accept"):
		select()
		
	get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	var current = get_current()
	
	if not current.menu.is_empty():
		var item = current.menu[current.index]
		
		var highlight_action = item.get("highlight_action")
		
		if highlight_action and typeof(highlight_action) == TYPE_CALLABLE:
			(highlight_action as Callable).call()
		
	#DebugDraw.visible = !visible # TODO: Find a way to layer menu ontop.
	queue_redraw()
	
func _draw() -> void:
	var current = get_current()
	
	var title_params = TextInBoxParams.new()
	
	title_params.box_color = Color.DARK_BLUE
	
	var title_rect = draw_text_in_box(Vector2(8, 0), "Debug Menu", title_params)
	
	var items_origin = Vector2(8, title_rect.position.y + title_rect.size.y)
	var total_items_height: float = 0
	
	for index in get_current().menu.size():
		var item = current.menu[index]
		var label = item.get("label", "<untitled>")
		var is_active = item.get("is_active")
		
		var has_checkbox = is_active != null
		var text_size = menu_item_font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
		
		var width = text_size.x + (menu_item_padding * 2)
		var height = text_size.y + (menu_item_padding * 2)
		
		var menu_item_origin = Vector2(items_origin.x + 0, items_origin.y + total_items_height + menu_item_gutter)
		var checkbox_rect = Rect2(Vector2(menu_item_origin.x + menu_item_padding, menu_item_origin.y + (height / 2) - 5), Vector2(10, 10))
		var rect = Rect2(menu_item_origin, Vector2(width, height))
		var color = Color.DARK_VIOLET if get_current().index == index else Color.BLACK
		
		var text_position = Vector2(rect.position.x + menu_item_padding, rect.position.y)
		
		if has_checkbox:
			var checkbox_width = checkbox_rect.size.x + menu_item_padding * 2
			text_position.x += checkbox_width
			rect.size.x += checkbox_width
		
		var text_box_params = TextInBoxParams.new()
		
		text_box_params.box_color = Color.DARK_VIOLET if get_current().index == index else Color.BLACK
		text_box_params.padding_left = checkbox_rect.size.x if has_checkbox else menu_item_padding
		text_box_params.padding_right = menu_item_padding 
		text_box_params.padding_top = menu_item_padding
		text_box_params.padding_bottom = menu_item_padding
		
		var text_box_rect = draw_text_in_box(menu_item_origin, label, text_box_params)
		
		if is_active != null:
			draw_rect(checkbox_rect, Color.WHITE if is_active else Color.DIM_GRAY)
			
		total_items_height += text_box_rect.size.y + menu_item_gutter
		
	current.draw.call(self)

class TextInBoxParams:
	var font_size: float = 16
	var text_color: Color = Color.WHITE
	var box_color: Color = Color.BLACK
	var padding_left: float = 0
	var padding_right: float = 0
	var padding_top: float = 0
	var padding_bottom: float = 0

func draw_text_in_box(origin: Vector2, text: String, params: TextInBoxParams = TextInBoxParams.new()) -> Rect2:
	var text_size = menu_item_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, params.font_size)
	var text_position = origin + Vector2(params.padding_left, params.padding_top + menu_item_font.get_ascent(params.font_size))
	var box_rect = Rect2(origin, text_size + Vector2(params.padding_left + params.padding_right, params.padding_top + params.padding_bottom))
	
	draw_rect(box_rect, params.box_color)
	draw_string(menu_item_font, text_position, text, HORIZONTAL_ALIGNMENT_LEFT, -1, params.font_size, params.text_color)
	
	return box_rect

func get_current() -> NavigationStackEntry:
	return navigation_stack[-1]
	
func navigate(direction: int) -> void:
	var current = get_current()
	current.index = wrapi(current.index + direction, 0, current.menu.size())
	
func back() -> void:
	if navigation_stack.size() == 1:
		visible = !visible
	else:
		navigation_stack.pop_back()
		
func select() -> void:
	if get_current().menu.is_empty(): return

	var entry = get_current().menu[get_current().index]
	var entry_action = entry.get("action")
	var entry_menu = entry.get("menu")
	
	if entry_action and typeof(entry_action) == TYPE_CALLABLE:
		(entry_action as Callable).call()
		reload_menu()
	
	if entry_menu and typeof(entry_menu) == TYPE_STRING:
		load_menu(entry_menu)

func reload_menu() -> void:
	get_current().menu = get_current().reload.call()
	
func noop_draw(_control: Control) -> void:
	pass
	
func load_menu(entry: String) -> void:
	var exists = ResourceLoader.exists("res://entities/debug_menu/menus/" + entry + ".gd")
	if not exists: return push_error("Debug menu does not exist for: " + entry)
	
	var resource = load("res://entities/debug_menu/menus/" + entry + ".gd")
	
	var menu = Object.new()
	menu.set_script(resource)
	if not menu.has_method("get_items"): return push_error("Menu does not have `get_items` method")
	
	var menu_items = menu.get_items()
	if typeof(menu_items) != TYPE_ARRAY: return push_error("Menu needs to return array")
	menu_items = menu_items as Array[Dictionary]
	
	if menu_items.is_empty():
		menu_items.append({ "label": "<no items>" })
		
	var draw_method = noop_draw if not menu.has_method("draw") else menu.draw
		
	var navigation_stack_entry = NavigationStackEntry.new(entry, menu_items, menu.get_items, draw_method)
	navigation_stack.append(navigation_stack_entry)
