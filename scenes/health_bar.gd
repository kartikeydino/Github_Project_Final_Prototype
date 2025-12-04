extends Control

@onready var health_bar = $ProgressBar

# Call this function to initialize the health bar when the player loads
func initialize_bar(player_node):
	# 1. Set the initial max and current values
	health_bar.max_value = player_node.max_health
	health_bar.value = player_node.health
	
	# 2. Connect the player's health_changed signal to this script's update function
	# This ensures the bar updates whenever the player's health changes.
	player_node.health_changed.connect(_on_player_health_changed)

# This function is called every time the player's health_changed signal is emitted
func _on_player_health_changed(new_health, max_health):
	# Update the ProgressBar's value
	health_bar.value = new_health
	
	# Optional: Update the text displayed on the progress bar
	health_bar.set_text(str(new_health) + " / " + str(max_health))

# For a nice visual touch, you can customize the progress bar's fill color
# by adding a StyleBoxFlat to the "Fill" style property in the Inspector.
