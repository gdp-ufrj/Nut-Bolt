extends CharacterBody2D

@onready var animation = $Animacao_player_2
@onready var conexao = $Conexao_player_2

@export var SPEED: int = 90
@export var gravity_speed = 400

var unit_direction: Vector2
var gravity = Vector2.ZERO
var esta_desativado = false

var state = States.CAINDO
var prev_state = null
var state_timeout = false

enum States {
	CHAO, # 0
	PAREDE_ESQUERDA, # 1
	PAREDE_DIREITA, # 2
	TETO, # 3
	CAINDO, # 4
	DESACOPLOU # 5
}

func _ready() -> void:
	#velocity = Vector2.ZERO
	$zona_conexao_2.collision_layer = 3
	$zona_conexao_2.collision_mask = 3
	self.add_to_group("Players")
	conexao.conectar()

#region physics process
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	process_input()
	process_gravity()
	velocity += gravity * delta
	move_and_slide()
	update_state()
	print(state)
	voltou_ao_chao()
	# SOM DE ANDAR
	if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD") and is_on_floor() and not esta_desativado:
		if not $audio_andar.is_playing():
			$audio_andar.play()
	else:
		$audio_andar.stop()
	
	if esta_desativado:
		$audio_andar.stop()
	
	animation.setAnimation(direction, esta_desativado)
#endregion

func process_input():
	if state == States.CHAO or state == States.TETO or state == States.CAINDO:
		if state != States.CAINDO:
			velocity.x = 0
	if Input.is_action_pressed("ui_right_WASD") and state == States.CHAO:
		velocity.x += SPEED
		if ray_right():
			velocity.y += SPEED
			enter_state(States.PAREDE_DIREITA)
	if Input.is_action_pressed("ui_left_WASD") and state == States.CHAO:
		velocity.x -= SPEED
		if ray_left():
			velocity.y += SPEED
			enter_state(States.PAREDE_ESQUERDA)
	if Input.is_action_pressed("ui_down_WASD") and state == States.TETO:
		if ray_right():
			enter_state(States.PAREDE_DIREITA)
		elif ray_left():
			enter_state(States.PAREDE_ESQUERDA)
		else:
			enter_state(States.CAINDO)
	
	if state == States.TETO:
		velocity.y = 0
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.x += SPEED
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.x -= SPEED
	
	if state == States.PAREDE_ESQUERDA:
		velocity.y = 0
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.y += SPEED
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.y -= SPEED
	
	if state == States.PAREDE_DIREITA:
		velocity.y = 0
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.y += SPEED
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.y -= SPEED
	
	if state == States.PAREDE_ESQUERDA or state == States.PAREDE_DIREITA:
		if ray_down():
			if Input.is_action_pressed("ui_right_WASD") and !ray_right():
				enter_state(States.CHAO)
			if Input.is_action_pressed("ui_left_WASD") and !ray_left():
				enter_state(States.CHAO)
		elif ray_up():
			if Input.is_action_pressed("ui_right_WASD") and !ray_right():
				enter_state(States.TETO)
			if Input.is_action_pressed("ui_left_WASD") and !ray_left():
				enter_state(States.TETO)
		else:
			if Input.is_action_pressed("ui_right_WASD") and !ray_right():
				enter_state(States.CAINDO)
			if Input.is_action_pressed("ui_left_WASD") and !ray_left():
				enter_state(States.CAINDO)
	
	# Leitura de desacoplamento -> TECLA 'S'
	if state != States.DESACOPLOU and not esta_desativado:
		if Input.is_action_pressed("ui_down_WASD"):
			enter_state(States.DESACOPLOU)
	
	if state == States.CAINDO and prev_state == States.PAREDE_ESQUERDA or prev_state == States.PAREDE_DIREITA:
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.x += 0.5
			velocity.y -= 0.5
			if is_on_floor():
				enter_state(States.CHAO)
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.x -= 0.5
			velocity.y -= 0.5
			if is_on_floor():
				enter_state(States.CHAO)
	
	if state == States.CAINDO and prev_state == States.CHAO and !is_on_floor():
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.x = 0
			velocity.y -= 0.5
			if is_on_wall():
				enter_state(States.PAREDE_ESQUERDA)
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.x = 0
			velocity.y -= 0.5
			if is_on_wall():
				enter_state(States.PAREDE_DIREITA)
	
	if !ray_right() and state == States.CAINDO and ray_dd():
		print("ENTROU")
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.y = SPEED / 4
			velocity.x += SPEED / 4
			if is_on_ceiling():
				enter_state(States.TETO)

func process_gravity():
	if state == States.PAREDE_DIREITA:
		gravity = Vector2(gravity_speed, 0)
	elif state == States.PAREDE_ESQUERDA:
		gravity = Vector2(-gravity_speed, 0)
	elif state == States.TETO:
		gravity = Vector2(0, -gravity_speed)
	else:
		gravity = Vector2(0, gravity_speed)

func update_state():
	if !ray_left() and !ray_right() and !ray_down() and !ray_up() and !(state == States.CAINDO):
		enter_state(States.CAINDO)
	
	if state == States.CAINDO:
		if ray_down():
			enter_state(States.CHAO)
		if ray_up():
			enter_state(States.TETO)
		if ray_left():
			enter_state(States.PAREDE_ESQUERDA)
		if ray_right():
			enter_state(States.PAREDE_DIREITA)

func enter_state(new_state):
	if new_state != prev_state or !state_timeout:
		prev_state = state
		state = new_state
		$StateChangeTimer.start()
		state_timeout = true

func _on_state_change_timer_timeout() -> void:
	state_timeout = false

func voltou_ao_chao():
	if state == States.DESACOPLOU:
		if is_on_floor():
			enter_state(States.CHAO)

# Funcoes auxiliares para detectar colisao nos raycasts
func ray_up():
	return $Raycasts/RayUp.is_colliding()

func ray_down():
	return $Raycasts/RayDown.is_colliding()

func ray_right():
	return $Raycasts/RayRight.is_colliding()

func ray_left():
	return $Raycasts/RayLeft.is_colliding()

# Diagonal direita -> dd
func ray_dd():
	return $Raycasts/RayDiagonalDireita.is_colliding()

# Diagonal esquerda -> de
func ray_de():
	return $Raycasts/RayDiagonalEsquerda.is_colliding()
