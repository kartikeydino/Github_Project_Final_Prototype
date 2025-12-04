extends CharacterBody2D

# --- ENEMY MOVEMENT & COMBAT PROPERTIES ---
var SPEED = 60 # Horizontal walking speed
var health = 3
var damage = 1 # Damage the enemy deals (if needed)

# Patrol boundaries
var starting_x = 0.0 # Will be set in _ready()
@export var DISTANCE_TO_TRAVEL: int = 100 # How far to walk (100 pixels each way)
@export var level_number: int = 1
var move_direction = 1 # 1 = right, -1 = left (starts moving right)

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var enemy_sprite = $Sprite2D # Assuming your enemy has a Sprite2D child
@onready var heart1 = $hearts/heart1
@onready var heart2 = $hearts/heart2
@onready var heart3 = $hearts/heart3

# The function the bullet will call when it hits the enemy
# THIS FUNCTION IS ESSENTIAL FOR THE BULLET TO WORK!
func take_damage(damage_amount):
	health -= damage_amount
	print("Enemy took damage. Health remaining: " + str(health))
	
	_update_heart_visuals() # Update visuals immediately after taking damage
	
	# Check if the enemy is defeated
	if health <= 0:
		queue_free() # Destroys the enemy node

# Updates the visibility of the heart icons based on current health
func _update_heart_visuals():
	if health == 3:
		heart1.visible = true
		heart2.visible = true
		heart3.visible = true
	elif health == 2:
		heart1.visible = false
		heart2.visible = true
		heart3.visible = true
	elif health == 1:
		heart1.visible = false
		heart2.visible = false
		heart3.visible = true
	else: # health <= 0
		heart1.visible = false
		heart2.visible = false
		heart3.visible = false

# This function runs when the enemy enters the scene tree
func _ready():
	# Record the starting X position for the patrol route
	starting_x = position.x
	_update_heart_visuals() # Set initial state of hearts

func _physics_process(delta):
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# --- PATROL LOGIC ---
	
	# 1. Check if we reached the right boundary
	if position.x >= starting_x + DISTANCE_TO_TRAVEL and variables.levels_discovered >= level_number:
		move_direction = -1 # Change direction to left
		enemy_sprite.flip_h = true # Optional: Flip sprite to face left
	
	# 2. Check if we reached the left boundary
	elif position.x <= starting_x - DISTANCE_TO_TRAVEL and variables.levels_discovered >= level_number:
		move_direction = 1 # Change direction to right
		enemy_sprite.flip_h = false # Optional: Flip sprite to face right
		
	# 3. Apply the calculated velocity

	if variables.levels_discovered>= level_number:
		velocity.x = move_direction * SPEED
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		SPEED = 100
	
	# === THE LIKELY ROOT CAUSE IS HERE: PLAYER'S COLLISION SCRIPT ===
	# If the Player is hitting the Enemy, you should check the Player's script 
	# to see what it does when it collides with something named 'Enemy'.
	# The Player's script should call a function like 'body.player_take_damage(self.damage)' 
	# on the Player node, NOT 'body.take_damage' on the Enemy node.


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		SPEED = 60
