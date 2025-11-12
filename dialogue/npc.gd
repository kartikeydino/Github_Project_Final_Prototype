extends CharacterBody2D

# ----------------------------------------------------
# 1. NODE REFERENCES
# ----------------------------------------------------
# IMPORTANT: Renamed to Sprite2D to match your scene setup
@onready var npc_sprite: Sprite2D = $Sprite2D 
@onready var chat_detection_area: Area2D = $ChatDetectionArea
# Must be an instanced child scene named "Dialogue"
@onready var dialogue_ui = $Dialogue 

# State Flags for Dialogue
var is_player_in_chat_zone: bool = false
var is_chatting: bool = false
var player = null

# ----------------------------------------------------
# 2. INITIALIZATION & SETUP
# ----------------------------------------------------
func _ready():
	# Signals are now connected via the editor, so we remove the code connections here:
	# chat_detection_area.body_entered.connect(_on_chat_detection_area_body_entered) # REMOVED
	# chat_detection_area.body_exited.connect(_on_chat_detection_area_body_exited) # REMOVED
	
	# Connect to the dialogue completion signal from DialogPlayer.gd (This is safe to keep)
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)
	
	# Optional: Display the initial idle animation (if you have one)
	# If using Sprite2D, no need to play animation.


# ----------------------------------------------------
# 3. INPUT & DIALOGUE TRIGGER
# ----------------------------------------------------
func _process(delta):
	# Check for chat input only if player is in the zone and we are NOT chatting
	if is_player_in_chat_zone and not is_chatting:
		# 'chat' is the custom input action (e.g., mapped to 'C' key)
		if Input.is_action_just_pressed("chat"):
			start_chat()

func start_chat():
	if not is_chatting:
		is_chatting = true
		print("Chat started with stationary NPC.")
		dialogue_ui.start()

# Connected to the 'dialogue_finished' signal from DialogPlayer.gd
func _on_dialogue_finished():
	# Return NPC state to normal
	is_chatting = false
	variables.max_jumps = 2
# ----------------------------------------------------
# 4. CHAT DETECTION AREA SIGNALS
# ----------------------------------------------------
func _on_chat_detection_area_body_entered(body: Node2D):
	# We check if the body entering has been added to the 'player' group
	if body.is_in_group("player"): 
		player = body
		is_player_in_chat_zone = true
		print("Player entered chat zone.")

func _on_chat_detection_area_body_exited(body: Node2D):
	if body == player:
		is_player_in_chat_zone = false
		player = null
		print("Player exited chat zone.")
		
