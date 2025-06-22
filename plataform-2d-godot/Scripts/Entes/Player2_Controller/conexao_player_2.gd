extends Node2D

@onready var corpo = get_parent()
@onready var timer = corpo.get_node("Timer_conexao")
@onready var animador_conexao = corpo.get_node("zona_conexao_2/Sprite2D/AnimationPlayer")
@onready var aviso_conexao = corpo.get_node("aviso_conexao")
@onready var reestabelece_conexao = corpo.get_node("reestabelece_conexao")
@onready var audio_desligar = corpo.get_node("audio_desligar")

var estado_original = 90
var som_desligar_ja_tocado = false
var _overlaping: Array = []

func conectar(veio_de_desativado: bool = false)->void:
	corpo.esta_desativado = false  #ESSENCIAL
	corpo.SPEED = estado_original
	timer.stop()
	aviso_conexao.stop()
	animador_conexao.play("Idle")
	som_desligar_ja_tocado = false
	if veio_de_desativado:
		reestabelece_conexao.play()

func desconectar()-> void:
	corpo.SPEED = 0
	aviso_conexao.stop()

func _on_timer_conexao_timeout() -> void:
	#animaçao de desativado
	corpo.esta_desativado = true
	$"../Animação".play("Desativado")
	if not som_desligar_ja_tocado:
		audio_desligar.play()
		som_desligar_ja_tocado = true
	desconectar()

func _on_zona_conexao_2_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao_1" or area.name == "zona_conexao_rot":
		_overlaping.append(area)
		conectar(corpo.esta_desativado)
		

func _on_zona_conexao_2_area_exited(area: Area2D) -> void:
	_overlaping.erase(area)
	if _overlaping.is_empty():
		if timer.is_stopped(): 
			timer.start()
			aviso_conexao.play()
			animador_conexao.play("desconectando")
