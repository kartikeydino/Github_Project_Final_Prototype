extends Area2D

var speed = 800
var direction = 1 
var damage = 1 # Define how much damage this bullet does
@onready var bullet_sprite = $Sprite2D

func _ready():
	set_as_top_level(true)
	if direction == -1:
		bullet_sprite.flip_h = true
	
	# 🎯 NEW: Connect the collision signal
	body_entered.connect(_on_body_entered) 

func _process(delta):
	position.x += speed * direction * delta

# 🎯 NEW: Collision handler function
func _on_body_entered(body):
	# Check if the body that entered is an enemy and has the required function
	if body.has_method("take_damage"):
		body.take_damage(damage) # Deal damage to the enemy
	
	queue_free() # Destroy the bullet on hit

func deal_damge():
	pass # This function is now deprecated, using _on_body_entered instead

