extends Control

signal dialogue_finished

@export_file("*.json") var dialogue_file: String

@onready var name_label: RichTextLabel = $NinePatchRect/NameLabel
@onready var text_label: RichTextLabel = $NinePatchRect/TextLabel
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

var dialogue_data: Array = []
var current_line_index: int = 0
var is_dialogue_active: bool = false
var is_typing: bool = false

const TYPING_SPEED: float = 0.02 



func _ready():
	nine_patch_rect.hide()
	load_dialogue_data()

func load_dialogue_data():
	if not dialogue_file:
		return
	var file = FileAccess.open(dialogue_file, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		return
	var json_text = file.get_as_text()
	var parsed_data = JSON.parse_string(json_text)
	if parsed_data is Array:
		dialogue_data = parsed_data
		
func start():
	if is_dialogue_active or dialogue_data.is_empty():
		return
	is_dialogue_active = true
	current_line_index = 0
	nine_patch_rect.show()
	display_current_line()

func _process(delta):
	if is_dialogue_active and Input.is_action_just_pressed("chat"):
		if is_typing:
			text_label.visible_characters = -1
			is_typing = false
		else:
			advance_dialogue()

func display_current_line():
	if current_line_index < dialogue_data.size():
		var line = dialogue_data[current_line_index]
		name_label.text = line.get("name", "???") 
		text_label.text = line.get("text", "")
		text_label.visible_characters = 0 
		is_typing = true
		type_character()
		
	else:
		end_dialogue()

func type_character():
	if not is_typing:
		return
	if text_label.visible_characters < text_label.get_total_character_count():
		text_label.visible_characters += 1
		var timer = get_tree().create_timer(TYPING_SPEED, false)
		timer.timeout.connect(type_character)
	else:
		is_typing = false

func advance_dialogue():
	current_line_index += 1
	display_current_line()

func end_dialogue():
	is_dialogue_active = false
	nine_patch_rect.hide()
	emit_signal("dialogue_finished")
