class_name Vermelho
extends CharacterBody2D

@onready var animation = $Animacao_player_2
@onready var conexao = $Conexao_player_2
@onready var som = $Gerenciador_de_som

@export var SPEED: int = 90
@export var gravity_speed = 400

var gravity = Vector2.ZERO
var esta_desativado = false

var state
var prev_state = null
var state_timeout = false

var last_direction: int = 1

enum States {
	CHAO, # 0
	PAREDE_ESQUERDA, # 1
	PAREDE_DIREITA, # 2
	TETO_PERSPECTIVA_ESQUERDA, #3
	TETO_PERSPECTIVA_DIREITA, #4
	CAINDO, # 5
	DESACOPLOU # 6
}

func _ready() -> void:
	$zona_conexao_2.collision_layer = 3
	$zona_conexao_2.collision_mask = 3
	self.add_to_group("Players")
	conexao.conectar()
	state = States.CAINDO

#region physics process
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	# Detecta a troca de direção para tocar a animação "Virar"
	var turn_direction = 0
	if direction != 0 and last_direction != 0 and sign(direction) != last_direction:
		turn_direction = sign(direction) # Armazena a nova direção do "Virar"
	
	# Atualiza a última direção apenas se houver movimento
	if direction != 0:
		last_direction = sign(direction)
	
	process_input()
	process_gravity()
	velocity += gravity * delta
	move_and_slide()
	update_state()
	som.processar_som()
	voltou_ao_chao()
	#debugar_state()
	animation.setAnimation(direction, turn_direction, esta_desativado, prev_state, state)
#endregion

func process_input():
	if state == States.CHAO or state == States.CAINDO or States.TETO_PERSPECTIVA_ESQUERDA or States.TETO_PERSPECTIVA_DIREITA:
		# Nao permite que ele fique deslizando que nem maluco
		if state != States.CAINDO:
			velocity.x = 0
	
	if Input.is_action_pressed("ui_right_WASD") and state == States.CHAO:
		# Andar pra direita, se encontrar uma parede, sobe nela e entra em
		# State de PAREDE_DIREITA
		velocity.x += SPEED
		if ray_right():
			enter_state(States.PAREDE_DIREITA)
	
	if Input.is_action_pressed("ui_left_WASD") and state == States.CHAO:
		# Andar pra esquerda, se encontrar uma parede, sobe nela e entra em
		# State de PAREDE_ESQUERDA
		velocity.x -= SPEED
		if ray_left():
			enter_state(States.PAREDE_ESQUERDA)
	
	# Inputs para subir em parede que esta na esquerda
	if state == States.PAREDE_ESQUERDA:
		velocity.y = 0
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.y += SPEED
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.y -= SPEED
	
	# Inputs para subir em parede que esta na direita
	if state == States.PAREDE_DIREITA:
		velocity.y = 0
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.y += SPEED
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.y -= SPEED
	
	# Logica para subir no teto ou descer pro chao a partir de uma parede
	if state == States.PAREDE_ESQUERDA or state == States.PAREDE_DIREITA:
		if ray_down():
			if Input.is_action_pressed("ui_right_WASD") and !ray_right():
				enter_state(States.CHAO)
			if Input.is_action_pressed("ui_left_WASD") and !ray_left():
				enter_state(States.CHAO)
		elif ray_up():
			if Input.is_action_pressed("ui_right_WASD") and ray_right():
				enter_state(States.TETO_PERSPECTIVA_DIREITA)
			if Input.is_action_pressed("ui_left_WASD") and ray_left():
				enter_state(States.TETO_PERSPECTIVA_ESQUERDA)
	
	# SUBIR EM PAREDE COM "CANTO" E CONTINUAR GRUDADO
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
	
	# CAIR DE PRECIPICIO E CONTINUAR GRUDADO
	if state == States.CAINDO and prev_state == States.CHAO and !is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.y -= 0.5
			if is_on_wall():
				enter_state(States.PAREDE_ESQUERDA)
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.y -= 0.5
			if is_on_wall():
				enter_state(States.PAREDE_DIREITA)
	
	# Leitura de desacoplamento -> TECLA 'S'
	if state != States.DESACOPLOU and state != States.CHAO and not esta_desativado:
		if Input.is_action_pressed("ui_down_WASD"):
			enter_state(States.DESACOPLOU)
	
	if state == States.TETO_PERSPECTIVA_ESQUERDA:
		# SE O PLAYER ESTIVER INDO PRA ESQUERDA
		if Input.is_action_pressed("ui_right_WASD"):
			# E TIVER UMA PAREDE NA ESQUERDA
			if ray_left():
				# ENTRA EM ESTADO DE PAREDE_ESQUERDA
				velocity.x -= SPEED / 2
				enter_state(States.PAREDE_ESQUERDA)
	if state == States.TETO_PERSPECTIVA_DIREITA:
		# SE O PLAYER ESTIVER INDO PRA DIREITA
		if Input.is_action_pressed("ui_left_WASD"):
			# E TIVER UMA PAREDE NA DIREITA
			if ray_right():
				# ENTRA EM ESTADO DE PAREDE_DIREITA
				velocity.x += SPEED / 2
				enter_state(States.PAREDE_DIREITA)
	
	# CONTROLE DE TETO -> PERSPECTIVA A PARTIR DA PAREDE ESQUERDA APENAS
	if state == States.TETO_PERSPECTIVA_ESQUERDA:
		velocity.y = 0
		velocity.y -= SPEED / 2
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.x += SPEED
			if ray_right():
				enter_state(States.PAREDE_DIREITA)
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.x -= SPEED
		if Input.is_action_pressed("ui_down_WASD"):
			velocity.x = 0
			enter_state(States.DESACOPLOU)
	# CONTROLE DE TETO -> PERSPECTIVA A PARTIR DA PAREDE DIREITA APENAS
	if state == States.TETO_PERSPECTIVA_DIREITA:
		velocity.y = 0
		velocity.y -= SPEED / 2
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.x -= SPEED
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.x += SPEED
		if Input.is_action_pressed("ui_down_WASD"):
			velocity.x = 0
			enter_state(States.DESACOPLOU)
	
	# TENTATIVA DE LEITURA DE CANTO
	if !ray_right() and prev_state == States.PAREDE_DIREITA and state == States.CAINDO:
		if Input.is_action_pressed("ui_left_WASD"):
			velocity.x = 0
			velocity.y = 0
			velocity.y -= SPEED
			velocity.x += 15
			position.y -= 2.5
			if ray_dd():
				enter_state(States.TETO_PERSPECTIVA_ESQUERDA)
	# TO-DO: ATUALIZAR ESSE OUTRO LADO DEPOIS
	if !ray_left() and state == States.CAINDO and ray_de():
		if Input.is_action_pressed("ui_right_WASD"):
			velocity.y = 0
			velocity.y += 15
			velocity.x += 15
			if ray_up():
				enter_state(States.TETO_PERSPECTIVA_DIREITA)
	
	if state == States.CAINDO and prev_state == States.TETO_PERSPECTIVA_ESQUERDA:
		if Input.is_action_pressed("ui_right_WASD"):
			position.x = position.x
			velocity.y = -SPEED
			position.x += 2
			if ray_right():
				enter_state(States.PAREDE_DIREITA)
	if state == States.CAINDO and prev_state == States.TETO_PERSPECTIVA_DIREITA:
		if Input.is_action_pressed("ui_right_WASD"):
			position.x = position.x
			velocity.y = -SPEED
			position.x += 2
			if ray_right():
				enter_state(States.PAREDE_DIREITA)

func process_gravity():
	if state == States.PAREDE_DIREITA:
		gravity = Vector2(gravity_speed, 0)
	elif state == States.PAREDE_ESQUERDA:
		gravity = Vector2(-gravity_speed, 0)
	elif state == States.TETO_PERSPECTIVA_ESQUERDA:
		gravity = Vector2(0, -gravity_speed)
	elif state == States.TETO_PERSPECTIVA_DIREITA:
		gravity = Vector2(0, -gravity_speed)
	else:
		gravity = Vector2(0, gravity_speed)

func update_state():
	if !ray_left() and !ray_right() and !ray_down() and !ray_up() and !ray_dd() and !ray_de() and !(state == States.CAINDO) and !(state == States.DESACOPLOU):
		enter_state(States.CAINDO)
	
	if state == States.CAINDO:
		if velocity.y == 0:
			enter_state(States.DESACOPLOU)
		if ray_down():
			enter_state(States.CHAO)
		if ray_left():
			enter_state(States.PAREDE_ESQUERDA)
		if ray_right():
			enter_state(States.PAREDE_DIREITA)
	
	if state == States.PAREDE_ESQUERDA or state == States.PAREDE_DIREITA or state == States.TETO_PERSPECTIVA_ESQUERDA or state == States.TETO_PERSPECTIVA_DIREITA:
		if !ray_left() and !ray_right() and !ray_dd() and !ray_de():
			enter_state(States.DESACOPLOU)
	
	if state == States.TETO_PERSPECTIVA_DIREITA or state == States.TETO_PERSPECTIVA_ESQUERDA:
		var collider = $Raycasts/RayUp.get_collider()
		if collider:
			if collider.is_in_group("paredes_retrateis"):
				enter_state(States.DESACOPLOU)


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

func debugar_state():
	if state == States.CHAO:
		print("CHAO")
	elif state == States.PAREDE_ESQUERDA:
		print("PAREDE ESQUERDA")
	elif state == States.PAREDE_DIREITA:
		print("PAREDE DIREITA")
	elif state == States.TETO_PERSPECTIVA_ESQUERDA:
		print("TETO_PERSPECTIVA_ESQUERDA")
	elif state == States.TETO_PERSPECTIVA_DIREITA:
		print("TETO_PERSPECTIVA_DIREITA")
	elif state == States.CAINDO:
		print("CAINDO")
	elif state == States.DESACOPLOU:
		print("DESACOPLOU")
