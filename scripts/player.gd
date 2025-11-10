extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var gun = $gun

const SPEED = 230.0
const JUMP_VELOCITY = -300.0
var jump_count = 0
var max_jumps = 2

var bullet = preload("res://scenes/bullet.tscn")
var gun_equipped = false
# 🛠️ FIX 2: Set gun_cooldown to true so the player can fire initially
var gun_cooldown = true
# 🛠️ FIX 1: Initialize gun_direction to 1 (right)
var gun_direction = 1 
var bullet_pos = Input.get_axis("left", "right")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		jump_count = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	
	if direction > 0 and gun_equipped:
		gun.flip_h = false
		gun.position = Vector2(14,3)
		# Set direction when facing right
		gun_direction = 1
	elif direction < 0 and gun_equipped:
		gun.flip_h = true
		gun.position = Vector2(-14,3)
		# Set direction when facing left
		gun_direction = -1
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if Input.is_action_just_pressed("e"):
		if gun_equipped:
			gun_equipped = false
			gun.visible = false
		else:
			gun_equipped = true
			gun.visible = true
	
	# Shooting logic
	if Input.is_action_just_pressed("left_mouse") and gun_equipped and gun_cooldown:
		gun_cooldown = false
		
		var bullet_instance = bullet.instantiate()
		
		# --- FIX START ---
		# Determine the spawn offset based on direction
		# If facing right (1), use a positive X offset (12).
		# If facing left (-1), use a negative X offset (-12).
		var spawn_offset_x = 12 * gun_direction
		var spawn_offset_y = -5 # Keep the Y offset constant
		var spawn_offset = Vector2(spawn_offset_x, spawn_offset_y)
		
		# 1. Set the bullet's direction property (for the bullet script to use)
		bullet_instance.direction = gun_direction
		
		# 2. Set the bullet's global position: gun's tip + directional offset
		bullet_instance.global_position = gun.global_position + spawn_offset
		# --- FIX END ---
		
		# 3. Add the bullet to the main scene tree (the player's parent)
		get_parent().add_child(bullet_instance)
		
		await get_tree().create_timer(0.5).timeout
		gun_cooldown = true

func player():
	pass
