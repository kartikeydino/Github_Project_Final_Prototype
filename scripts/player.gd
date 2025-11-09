extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var gun = $gun

const SPEED = 230.0
const JUMP_VELOCITY = -300.0
var jump_count = 0
var max_jumps = 2

var bullet = preload("res://scenes/bullet.tscn")
var gun_equipped = false
var gun_cooldown = false
var gun_direction = null


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
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if direction > 0 and gun_equipped:
		gun.flip_h = false
		gun.position = Vector2(14,3)
	elif direction < 0 and gun_equipped:
		gun.flip_h = true
		gun.position = Vector2(-14,3)
		
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
	
	if Input.is_action_just_pressed("left_mouse") and gun_equipped and gun_cooldown:
		gun_cooldown = false
		var bullet_instance = bullet.instantiate()
		add_child(bullet_instance)
		
		await get_tree().create_timer(0.5).timeout
		gun_cooldown = true

func player():
	pass
