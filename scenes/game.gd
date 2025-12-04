extends Node2D

# 1. Use the correct paths to your Player and HealthBar nodes.
# Please adjust these paths if your node names or hierarchy are different!
@onready var player_node = $Player 
@onready var health_bar_ui = $CanvasLayer/HealthBar 

func _ready():
	# Crucially, check if the nodes were successfully found before calling functions on them.
	if is_instance_valid(player_node) and is_instance_valid(health_bar_ui):
		# 2. Call the setup function defined in health_bar.gd
		health_bar_ui.initialize_bar(player_node)
	else:
		# This will print an error if the paths are wrong or nodes are missing
		# which helps debugging!
		print("ERROR: Could not find Player node or HealthBar UI node in the scene tree.")
