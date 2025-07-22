extends Node2D

@onready var fadein = get_parent().get_parent().get_parent().get_node("AnimationPlayer")
@onready var esta_desativado_player_1 = get_parent().get_parent().get_parent().get_node("Players").get_node("player_1").get_node("Conexao_player_1")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		if not fadein.is_playing():
			if body.name == "player_1":
				esta_desativado_player_1.esta_desativado = true
			elif body.name == "player_2":
				body.esta_desativado = true
			fadein.play("fade_in")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player_1":
		esta_desativado_player_1.esta_desativado = false
	elif body.name == "player_2":
		body.esta_desativado = false
