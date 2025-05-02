extends Node2D

#@onready var player1: CharacterBody2D = $"../Players/player_1"
#@onready var player2: CharacterBody2D = $"../Players/player_2"
#@onready var timer1 = $"../Players/player_1"/Timer_conexao
#@onready var timer2 = $"../Players/player_2"/Timer_conexao2


func _process(_delta: float) -> void:
	#conexao()
	pass

 
#func conexao()->void:
	###Checa se existe conexão ativa entre os players ou com roteadores
	#var posicoes: Array = [player1.global_position, player2.global_position]
	#var distPlayers = posicoes[0].distance_to(posicoes[1])
	#
	#if distPlayers > player1.MAX_DISTANCE:
		#player_timeout()
	#else:
		#timer1.stop()
		#timer2.stop()
#
#
#func player_timeout()->void:
	#if timer1.is_stopped(): 
		#timer1.start()
		#
	#if timer2.is_stopped(): 
		#timer2.start()
