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
	
	func _init(entry: String, menu: Array[Dictionary], reload: Callable = func(): pass) -> void:
		self.entry = entry
		self.menu = menu
		self.reload = reload

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

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	var font_height = menu_item_font.get_height(12)
	
	var title_text_size = menu_item_font.get_string_size("Debug Menu", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
	draw_string(menu_item_font, Vector2(5, title_text_size.y), "Debug Menu", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
	
	var items_origin = Vector2(5, title_text_size.y + 10)
	
	for index in get_current().menu.size():
		var item = get_current().menu[index]
		var label = item.get("label", "<untitled>")
		
		var text_size = menu_item_font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
		
		var width = text_size.x + (menu_item_padding * 2)
		var height = text_size.y + (menu_item_padding * 2)
		
		var rect = Rect2(items_origin.x + 0, items_origin.y + (height + menu_item_gutter) * index, width, height)
		var color = Color.DARK_VIOLET if get_current().index == index else Color.BLACK
		
		draw_rect(rect, color)
		draw_string(menu_item_font, Vector2(rect.position.x + menu_item_padding, rect.position.y + font_height), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
		
		var is_active = item.get("is_active")
		
		if is_active != null:
			var checkbox_rect = Rect2(rect)
			checkbox_rect.size.x = 10
			checkbox_rect.size.y = 10
			
			draw_rect(checkbox_rect, Color.WHITE if is_active else Color.DIM_GRAY)

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
	
func load_menu(entry: String) -> void:
	var exists = FileAccess.file_exists("res://entities/debug_menu/menus/" + entry + ".gd")
	if not exists: return push_error("Debug menu does not exist for: " + entry)
	
	var resource = load("res://entities/debug_menu/menus/" + entry + ".gd")
	
	var menu = Object.new()
	menu.set_script(resource)
	
	if not menu.has_method("get_items"): return push_error("Menu does not have `get_items` method")
	
	var menu_items = menu.get_items()
	var navigation_stack_entry = NavigationStackEntry.new(entry, menu_items, menu.get_items)
	
	navigation_stack.append(navigation_stack_entry)
