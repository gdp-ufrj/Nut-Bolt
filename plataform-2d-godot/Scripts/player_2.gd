extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400

@export var SPEED: int = 300
@export var JUMP_VELOCITY: int = -400
@export var DISTANCE: int = 200
#@export var other_character: Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var game_over = false  # Variável para impedir múltiplos prints

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_up_WASD") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
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
