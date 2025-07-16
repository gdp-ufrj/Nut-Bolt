extends Node2D

@onready var corpo = get_parent()
@onready var animation: AnimatedSprite2D = $"../Animação"

func setAnimation(direction, esta_desativado, state):
	# Animação de desativado
	if esta_desativado:
		if animation.animation != "Desativado":
			animation.play("Desativado")
		return  # Não continua se estiver desativado
	
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
	if Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_left_WASD"): 
		animation.play("Corrida")
	else: 
		animation.play("Idle")
