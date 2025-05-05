extends Node2D
#
#@onready var player1: CharacterBody2D = $"../Players/player_1"
#@onready var player2: CharacterBody2D = $"../Players/player_2"
#@onready var roteador: StaticBody2D = $Roteador
#@onready var timer1 = $"../Players/player_1"/Timer_conexao
#@onready var timer2 = $"../Players/player_2"/Timer_conexao2


func _process(_delta: float) -> void:
	#conexao()
	pass

 
#func conexao()->void:
	###Checa se existe conexão ativa entre os players ou com roteadores
	#var posicoes: Array = [player1.global_position, player2.global_position]
	##distancia entre os players
	#var distPlayers = posicoes[0].distance_to(posicoes[1])
	##distancia do roteador até cada um dos players
	#var distRoteador: Array = [
		#roteador.global_position.distance_to(posicoes[0]),
		#roteador.global_position.distance_to(posicoes[1])
	#]
	#
	#if distPlayers > player1.MAX_DISTANCE:
		#player_timeout()
		#for d in distRoteador:
			#var i = 0
			#if d <= player1.MAX_DISTANCE:
				#if i:
					#timer2.stop()
					#player2.reconectar()
				#else:
					#timer1.stop()
					#player1.reconectar()
			#i+=1
	#else:
		#timer1.stop()
		#timer2.stop()
		#player1.reconectar()
		#player2.reconectar()
		#
		#
		#
#
#func player_timeout()->void:
	#if timer1.is_stopped(): 
		#timer1.start()
		#
	#if timer2.is_stopped(): 
		#timer2.start()
