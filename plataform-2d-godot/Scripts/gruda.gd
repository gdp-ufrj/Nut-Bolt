extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400

@export var SPEED: int = 150
#@export var other_character: Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var game_over = false  # Variável para impedir múltiplos prints

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and Input.is_action_pressed("ui_right_WASD") and Input.is_action_pressed("ui_up_WASD"):
		velocity.x = direction * SPEED
		velocity.y = -gravity * delta * 5
	
	if is_on_wall() and Input.is_action_pressed("ui_left_WASD") and Input.is_action_pressed("ui_up_WASD"):
		velocity.x = direction * SPEED
		velocity.y = -gravity * delta * 5
	
	if is_on_ceiling() and Input.is_action_pressed("ui_up_WASD"):
		velocity.x = 0
		velocity.y = 0
	
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
	
	move_and_slide()
	
	#if other_character:
	#	var distance = global_position.distance_to(other_character.global_position)
	#	if distance > DISTANCE and not game_over:
	#		game_over = true
	#		print("YOU RE DIE")
