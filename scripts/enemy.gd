extends CharacterBody2D

# --- ENEMY MOVEMENT & COMBAT PROPERTIES ---
var SPEED = 60 # Horizontal walking speed
var health = 3
var damage = 1 # Damage the enemy deals (if needed)

# Patrol boundaries
var starting_x = 0.0 # Will be set in _ready()
@export var DISTANCE_TO_TRAVEL: int = 100 # How far to walk (100 pixels each way)
var move_direction = 1 # 1 = right, -1 = left (starts moving right)

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var enemy_sprite = $Sprite2D # Assuming your enemy has a Sprite2D child

# This function runs when the enemy enters the scene tree
func _ready():
	# Record the starting X position for the patrol route
	starting_x = position.x

# The function the bullet will call when it hits the enemy
func take_damage(damage_amount):
	health -= damage_amount
	print("Enemy took damage. Health remaining: " + str(health))
	
	# Check if the enemy is defeated
	if health <= 0:
		queue_free() # Destroys the enemy node

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# --- PATROL LOGIC ---
	
	# 1. Check if we reached the right boundary
	if position.x >= starting_x + DISTANCE_TO_TRAVEL:
		move_direction = -1 # Change direction to left
		enemy_sprite.flip_h = true # Optional: Flip sprite to face left
	
	# 2. Check if we reached the left boundary
	elif position.x <= starting_x - DISTANCE_TO_TRAVEL:
		move_direction = 1 # Change direction to right
		enemy_sprite.flip_h = false # Optional: Flip sprite to face right
		
	# 3. Apply the calculated velocity
	velocity.x = move_direction * SPEED
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		SPEED = 100


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		SPEED = 60



