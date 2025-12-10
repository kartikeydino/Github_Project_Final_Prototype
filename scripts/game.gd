extends Node2D

@onready var label = $Player/CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "Health = 100"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "Health = " + str(variables.player_health)
