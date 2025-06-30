extends Node2D

@onready var corpo = get_parent()
@onready var timer = corpo.get_node("Timer_conexao")
@onready var animador = corpo.get_node("zona_conexao_1/Sprite2D/AnimationPlayer")
@onready var aviso_conexao = corpo.get_node("aviso_conexao")
@onready var movimento = corpo.get_node("Movimento_player_1")
@onready var estado_original := [corpo.SPEED, movimento.jump_velocity]

var esta_desativado := false
var som_desligar_ja_tocado := false
var _overlaping := []

func conectar(veio_de_desativado := false):
	esta_desativado = false
	corpo.SPEED = estado_original[0]
	movimento.jump_velocity = estado_original[1]
	timer.stop()
	aviso_conexao.stop()
	som_desligar_ja_tocado = false
	if veio_de_desativado:
		corpo.get_node("reestabelece_conexao").play()

func desconectar():
	corpo.SPEED = 0
	movimento.jump_velocity = 0
	aviso_conexao.stop()

func _on_timer_conexao_timeout():
	esta_desativado = true
	corpo.get_node("Animaçao").play("Desativado")
	if not som_desligar_ja_tocado:
		corpo.get_node("audio_desligar").play()
		som_desligar_ja_tocado = true
	desconectar()

func _on_zona_conexao_1_area_entered(area):
	if area.name in ["zona_conexao_2", "zona_conexao_rot"]:
		_overlaping.append(area)
		conectar(esta_desativado)
		animador.play("Idle")

func _on_zona_conexao_1_area_exited(area):
	_overlaping.erase(area)
	if _overlaping.is_empty():
		if timer.is_stopped():
			timer.start()
			aviso_conexao.play()
			animador.play("desconectando")
