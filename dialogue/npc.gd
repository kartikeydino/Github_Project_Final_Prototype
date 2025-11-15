extends CharacterBody2D

@onready var npc_sprite: Sprite2D = $Sprite2D 
@onready var chat_detection_area: Area2D = $ChatDetectionArea
@onready var dialogue_ui = $Dialogue 


var is_player_in_chat_zone: bool = false
var is_chatting: bool = false
var player = null

func _ready():
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)
	if variables.death_count >= 1 and variables.talked:
		queue_free()

func _process(delta):
	if is_player_in_chat_zone and not is_chatting:
		if Input.is_action_just_pressed("chat"):
			start_chat()

func start_chat():
	if not is_chatting:
		is_chatting = true
		dialogue_ui.start()

func _on_dialogue_finished():
	# Return NPC state to normal
	is_chatting = false
	variables.max_jumps = 2
	variables.talked = true
	queue_free()

func _on_chat_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"): 
		player = body
		is_player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body: Node2D):
	if body == player:
		is_player_in_chat_zone = false
		player = null
		
