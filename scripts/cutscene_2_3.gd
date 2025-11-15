extends Node2D

@onready var animplayer = $AnimationPlayer
@onready var camera = $Path2D/PathFollow2D/Camera2D

var is_opening_cutscene = false

var has_player_entered_area = false
var player = null

var is_path_following = false

func _ready():
	camera.enabled = false

func _physics_process(delta):
	if is_opening_cutscene:
		var pathfollower = $Path2D/PathFollow2D	
		if is_path_following:
			pathfollower.progress_ratio += 0.005
			if pathfollower.progress_ratio >= 1:
				cutsceneending23()

func _on_player_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		if !has_player_entered_area:
			has_player_entered_area = true
			cutsceneopening23()
			
			
func cutsceneopening23():
	variables.player_speed = 0
	is_opening_cutscene = true
	animplayer.play("cover_fade")
	player.camera.enabled = false
	camera.enabled = true
	is_path_following = true


func cutsceneending23():
	variables.levels_discovered = 3
	variables.player_speed = 230
	is_opening_cutscene = false
	is_path_following = false
	camera.enabled = false
	player.camera.enabled = true
