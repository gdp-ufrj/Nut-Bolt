extends Node2D

# VARIAVEIS PARA FUNCIONAMENTO DO BOTAO E DA PLATAFORMA
var pode_interagir: bool = false
var jogador: Node2D = null
var botao_foi_ativado = false

#
#@onready var player1: CharacterBody2D = $"../Players/player_1"
#@onready var player2: CharacterBody2D = $"../Players/player_2"
#@onready var roteador: StaticBody2D = $Roteador
#@onready var timer1 = $"../Players/player_1"/Timer_conexao
#@onready var timer2 = $"../Players/player_2"/Timer_conexao2


func _process(_delta: float) -> void:
	#conexao()
	if pode_interagir and Input.is_action_just_pressed("interagir"):
		print("interagiu")
		$plataforma/AnimationPlayer.play("move")
		$Botao/Label.visible = false
 
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

# SCRIPT PRO BOTAO E PLATAFORMA
func _on_botao_body_entered(body: Node2D) -> void:
	if body.name == "player_2" and not botao_foi_ativado:
		$Botao/Label.visible = true
		pode_interagir = true
		jogador = body
		botao_foi_ativado = true

# SCRIPT PRO BOTAO E PLATAFORMA
func _on_botao_body_exited(body: Node2D) -> void:
	if body.name == "player_2":
		$Botao/Label.visible = false
		pode_interagir = false
		jogador == null

func _on_area_para_evitar_bug_body_entered(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		if $plataforma/AnimationPlayer.is_playing(): 
			$plataforma/AnimationPlayer.pause()
			$plataforma.position.y - 10

func _on_area_para_evitar_bug_body_exited(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		$plataforma/AnimationPlayer.play("move")
