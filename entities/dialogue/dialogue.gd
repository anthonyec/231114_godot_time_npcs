class_name Dialogue
extends Node

static var instance: Dialogue = null

@onready var screen = %Screen as Control
@onready var balloon = %Balloon as Panel
@onready var character_label = %CharacterLabel as RichTextLabel
@onready var dialogue_label = %DialogueLabel as DialogueLabel

@export var is_active: bool = false

var line: DialogueLine
var resouce: DialogueResource

func _ready() -> void:
	if instance != null: push_error("Dialogue instance already exists in this scene, overriding previous")
	instance = self
	
	DialogueManager
	
	balloon.modulate = Color(0, 0, 0, 0)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		next()
		
	if event.is_action_pressed("ui_cancel"):
		end()

func start(dialogue_name: String) -> void:
	if is_active: return
	
	var resouce_path = "res://dialogue/%s.dialogue" % dialogue_name
	if not ResourceLoader.exists(resouce_path): return push_error("Dialogue file does not exist: " + resouce_path)

	resouce = load(resouce_path) as DialogueResource
	is_active = true
	World.instance.ticking = false
	
	animate_in()
	next()
	
func next(line_id: String = "") -> void:
	if not is_active: return
	
	var next_id: String = line.next_id if line else ""
	
	if line_id:
		next_id = line_id

	line = await resouce.get_next_dialogue_line(next_id, [self])
	if not line: return end()
	
	dialogue_label.dialogue_line = line
	dialogue_label.type_out()
	
	# TODO: Handle responses.
	#print(line.responses)

func end() -> void:
	animate_out()
	World.instance.ticking = true
	is_active = false
	resouce = null
	line = null
	
func animate_in() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(balloon, "modulate", Color(1, 1, 1, 1), 0.3)
	
func animate_out() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(balloon, "modulate", Color(1, 1, 1, 0), 0.3)
	
