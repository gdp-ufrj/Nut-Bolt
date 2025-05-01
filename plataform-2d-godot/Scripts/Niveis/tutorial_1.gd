extends Node2D

@onready var player1: CharacterBody2D = $"../Players/player_1"
@onready var player2: CharacterBody2D = $"../Players/player_2"


func _process(_delta: float) -> void:
	conexao()

 
func conexao()->void:
	##Checa se existe conexão ativa entre os players ou com roteadores
	var posicoes: Array = [player1.global_position,player2.global_position]
	var distJogadores = posicoes[0].distance_to(posicoes[1])
	
	for p in posicoes:
		if distJogadores > player1.MAX_DISTANCE:
			player_timers()
		else:
			$"../Players/player_1"/Timer_conexao.stop()
			$"../Players/player_2"/Timer_conexao2.stop()
			
			
func player_timers()->void:
	if $"../Players/player_1"/Timer_conexao.is_stopped(): 
		$"../Players/player_1"/Timer_conexao.start()
		
	if $"../Players/player_2"/Timer_conexao2.is_stopped(): 
		$"../Players/player_2"/Timer_conexao2.start()
