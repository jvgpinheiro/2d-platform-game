extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -800.0
@onready var sprite_2d = $Sprite2D
@onready var game_manager = %GameManager

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentJumps = 0

func _physics_process(delta):
	handle_global_actions()
	handle_movement(delta)
	choose_animation()
	choose_animation_direction()
	move_and_slide()

func handle_global_actions():
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		game_manager.on_scene_reset()

func handle_movement(delta):
	if is_on_floor():
		currentJumps = 0
	else:
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		currentJumps = 1
	
	if Input.is_action_just_pressed("jump") and not is_on_floor() and currentJumps <= 1:
		velocity.y = JUMP_VELOCITY
		currentJumps = 2
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 35)

func choose_animation():
	if abs(velocity.x) > 1 and is_on_floor():
		sprite_2d.play("running")
	elif is_on_floor():
		sprite_2d.play("idle")
	elif velocity.y > 0:
		sprite_2d.play("falling")
	elif currentJumps == 1:
		sprite_2d.play('jumping')
	elif currentJumps == 2:
		sprite_2d.play('double_jumping')
	

func choose_animation_direction():
	var isLeft = velocity.x < 0
	if velocity.x == 0:
		isLeft = sprite_2d.flip_h
	sprite_2d.flip_h = isLeft
