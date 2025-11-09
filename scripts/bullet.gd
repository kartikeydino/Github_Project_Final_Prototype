extends Area2D

var speed = 10 # How fast the bullet travels
# This variable is crucial for movement and is set by the Player script
var direction = 1 

# 🛠️ NEW: Get the bullet's Sprite2D node
@onready var bullet_sprite = $Sprite2D

func _ready():
	# Makes the bullet ignore the camera and move globally
	set_as_top_level(true)
	
	# 🎯 NEW: Flip the sprite horizontally if the direction is left (-1)
	if direction == -1:
		bullet_sprite.flip_h = true
	# Note: If direction is 1 (right), flip_h remains false (default)

# 🛠️ FIX: ADDING THE MOVEMENT CODE
func _process(delta):
	# Update the bullet's X position using (Speed * Direction * Time)
	position.x += speed * direction * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	# Cleans up the bullet when it leaves the screen area
	queue_free()

func deal_damge():
	# Logic for handling damage on impact goes here
	pass
