extends Control

# Signals are essential for letting other nodes (like the NPC) know when dialogue is over.
signal dialogue_finished

# ----------------------------------------------------
# 1. Configuration and Variables
# ----------------------------------------------------

# --- Exported Property ---
# This is where you drag your JSON file (e.g., worker_dialog_1.json) in the Inspector.
@export_file("*.json") var dialogue_file: String

# --- Node References ---
@onready var name_label: RichTextLabel = $NinePatchRect/NameLabel
@onready var text_label: RichTextLabel = $NinePatchRect/TextLabel
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

# --- Dialogue State ---
var dialogue_data: Array = []
var current_line_index: int = 0
var is_dialogue_active: bool = false
var is_typing: bool = false

# --- Typing Speed ---
const TYPING_SPEED: float = 0.05 # Seconds per character

# ----------------------------------------------------
# 2. Initialization and Start
# ----------------------------------------------------

func _ready():
	# Hide the dialogue box initially
	nine_patch_rect.hide()
	# Attempt to load the JSON file specified in the inspector
	load_dialogue_data()

# Load and parse the JSON file into the dialogue_data array
func load_dialogue_data():
	if not dialogue_file:
		push_error("Dialogue file path is not set in the inspector!")
		return

	# Use FileAccess to open and read the JSON file
	var file = FileAccess.open(dialogue_file, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Failed to open dialogue file: ", dialogue_file)
		return

	var json_text = file.get_as_text()
	var parsed_data = JSON.parse_string(json_text)
	
	if parsed_data is Array:
		dialogue_data = parsed_data
		print("Successfully loaded dialogue with ", dialogue_data.size(), " lines.")
	else:
		push_error("Failed to parse JSON data or data is not an array.")
		
# Called by the NPC when the 'chat' input is pressed
func start():
	if is_dialogue_active or dialogue_data.is_empty():
		return
		
	is_dialogue_active = true
	current_line_index = 0
	nine_patch_rect.show()
	display_current_line()

# ----------------------------------------------------
# 3. Input Handling (Advancing Dialogue)
# ----------------------------------------------------

func _process(delta):
	# Only process input if dialogue is active
	if is_dialogue_active and Input.is_action_just_pressed("chat"):
		# If text is currently typing, skip to the end of the line
		if is_typing:
			text_label.visible_characters = -1 # Show all text immediately
			is_typing = false
		else:
			# Otherwise, advance to the next line
			advance_dialogue()

# ----------------------------------------------------
# 4. Display Logic
# ----------------------------------------------------

func display_current_line():
	if current_line_index < dialogue_data.size():
		var line = dialogue_data[current_line_index]
		
		# 1. Update Name
		name_label.text = line.get("name", "???") # Use "???" if name field is missing
		
		# 2. Reset and Start Text Typing
		text_label.text = line.get("text", "")
		text_label.visible_characters = 0 # Start with no characters visible
		is_typing = true
		
		# Use a Timer to display text one character at a time
		# This will call type_character immediately, and then type_character sets up the next interval.
		type_character()
		
	else:
		# Dialogue finished
		end_dialogue()

func type_character():
	# Stop the function if we've already finished typing this line
	if not is_typing:
		return
		
	# Check if we have more characters to show
	if text_label.visible_characters < text_label.get_total_character_count():
		# Increment visible characters to show the next one
		text_label.visible_characters += 1
		
		# Set up a new Timer for the next character
		var timer = get_tree().create_timer(TYPING_SPEED, false)
		timer.timeout.connect(type_character)
	else:
		# Text is fully displayed
		is_typing = false

# ----------------------------------------------------
# 5. Advance and End
# ----------------------------------------------------

func advance_dialogue():
	current_line_index += 1
	display_current_line()

func end_dialogue():
	is_dialogue_active = false
	nine_patch_rect.hide()
	# Emit the signal to notify the NPC that the conversation is over
	emit_signal("dialogue_finished")
	print("Dialogue finished.")
