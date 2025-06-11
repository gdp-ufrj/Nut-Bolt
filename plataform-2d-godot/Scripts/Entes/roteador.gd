extends Node2D
@onready var animador = $zona_conexao_rot/sprite_conexao/AnimationPlayer
@onready var sprite_conexao = $zona_conexao_rot/sprite_conexao
@onready var linha1 = $linha_player1_rot
@onready var linha2 = $linha_player2_rot
var _overlaping: Array = []

func _ready() -> void:
	animador.play("Idle")
	sprite_conexao.self_modulate.a = 0.3

func _on_zona_conexao_rot_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao_1" or area.name == "zona_conexao_2":
		_overlaping.append(area)
		sprite_conexao.self_modulate.a = 1

func _on_zona_conexao_rot_area_exited(area: Area2D) -> void:
	if area.name == "zona_conexao_1" or area.name == "zona_conexao_2":
		_overlaping.erase(area)
		if _overlaping.is_empty():
			sprite_conexao.self_modulate.a = 0.3
