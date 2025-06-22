extends Node2D

@onready var corpo = get_parent()
@onready var sprite: AnimatedSprite2D = corpo.get_node("Animaçao")

func atualizar_animacao(direcao, esta_pulando, no_chao, esta_desativado):
	if esta_desativado:
		if sprite.animation != "Desativado":
			sprite.play("Desativado")
		return

	if direcao > 0:
		sprite.flip_h = false
	elif direcao < 0:
		sprite.flip_h = true

	if not no_chao:
		if sprite.animation != "vertical_pular":
			sprite.play("vertical_pular")
	elif abs(direcao) > 0:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
