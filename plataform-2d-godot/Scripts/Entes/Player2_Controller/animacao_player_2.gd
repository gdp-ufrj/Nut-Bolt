extends Node2D

@onready var corpo = get_parent()
@onready var animation: AnimatedSprite2D = $"../Animação"

func setAnimation(direction, esta_desativado):
#Anim desativado
	if esta_desativado:
		if animation.animation != "Desativado":
			animation.play("Desativado")
		return  # Não continua se estiver desativado
		
#flip do sprite
	if direction > 0: animation.flip_h = false
	elif direction < 0: animation.flip_h = true

#Parede subindo e descendo
	if Input.is_action_pressed("ui_up_WASD"): animation.play("Parede Subindo")
	elif Input.is_action_pressed("ui_down_WASD"): animation.play("Parede Descendo")
	elif Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_left_WASD"): animation.play("Corrida")
	else: animation.play("Idle")
