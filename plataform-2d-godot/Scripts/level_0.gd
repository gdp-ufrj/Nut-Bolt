extends Node2D

#acessando filhos 
@onready var player1: CharacterBody2D = $player_1
@onready var player2: CharacterBody2D = $player_2
@onready var roteador: StaticBody2D = $Roteador
#@onready var conectores: Array = [roteador]

func _process(_delta: float) -> void:
	conexao()

 
func conexao()->void:
	##Checa se existe conexão ativa entre os players ou com roteadores
	var posicoes: Array = [player1.global_position,player2.global_position]
	var distRoteador
	var distJogadores = posicoes[0].distance_to(posicoes[1])
	for p in posicoes:
		distRoteador = p.distance_to(roteador.global_position)
		if distRoteador > player1.MAX_DISTANCE and distJogadores > player1.MAX_DISTANCE:
			player_timers()
		else:
			$player_1/Timer_conexao.stop()
			$player_2/Timer_conexao2.stop()
			
func player_timers()->void:
	if $player_1/Timer_conexao.is_stopped(): 
		$player_1/Timer_conexao.start()
		
	if $player_2/Timer_conexao2.is_stopped(): 
		$player_2/Timer_conexao2.start()
