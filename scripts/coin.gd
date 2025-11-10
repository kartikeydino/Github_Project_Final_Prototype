extends Area2D

# This function runs when any solid physics body enters the coin's area
func _on_body_entered(body):
	# Check if the body that entered has the 'player' function
	# This confirms the body is your Player CharacterBody2D
	if body.has_method("player"):
		# 1. Tell the player to collect the coin (we'll add this function next)
		body.collect_coin(1) 
		
		# 2. Destroy the coin immediately
		queue_free()

# This is equivalent to connecting the signal in the editor
func _ready():
	body_entered.connect(_on_body_entered)
