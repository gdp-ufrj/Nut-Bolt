extends Node2D

@onready var corpo = get_parent()
@onready var animation: AnimatedSprite2D = $"../Animação"

func setAnimation(direction, turn_direction, esta_desativado, prev_state, state):
	# Animação de desativado
	if esta_desativado:
		if animation.animation != "Desativado":
			animation.play("Desativado")
		return  # Não continua se estiver desativado
	
	# IMPORTANTE: Se a animação "virar" estiver tocando, deixe-a terminar!
	if animation.get_animation() == "Virar" and animation.is_playing():
		return
	
	# Rotaciona em x graus dependendo do state
	match state:
		Vermelho.States.PAREDE_ESQUERDA:
			animation.rotation_degrees = 90
		Vermelho.States.PAREDE_DIREITA:
			animation.rotation_degrees = 270
		Vermelho.States.TETO_PERSPECTIVA_ESQUERDA, Vermelho.States.TETO_PERSPECTIVA_DIREITA:
			animation.rotation_degrees = 180
		_: # Caso padrão (CHAO, CAINDO, etc.)
			animation.rotation_degrees = 0
	
	# Define a ORIENTAÇÃO (flip_h) baseado na direção do input
	if direction > 0:
		animation.flip_h = false # Vira para a direita
	elif direction < 0:
		animation.flip_h = true  # Vira para a esquerda
	
	# Leitura de input para ver quando esta em idle e quando esta andando
	if turn_direction != 0:
		animation.play("Virar")
	elif Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_left_WASD"): 
		animation.play("Corrida")
	else: 
		animation.play("Idle")
	
	if state == Vermelho.States.CAINDO and prev_state == Vermelho.States.CHAO:
		if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD"):
			animation.play("Parede Descendo")
	if state == Vermelho.States.CAINDO and prev_state == Vermelho.States.PAREDE_DIREITA:
		if Input.is_action_pressed("ui_right_WASD"):
			animation.play("Parede Subindo")
	if state == Vermelho.States.CAINDO and prev_state == Vermelho.States.PAREDE_ESQUERDA:
		if Input.is_action_pressed("ui_left_WASD"):
			animation.play("Parede Subindo")
