extends CharacterBody2D

@onready var movimento = $Movimento_player_1
@onready var conexao = $Conexao_player_1
@onready var animacao = $Animacao_player_1

func _ready():
	$zona_conexao_1.collision_layer = 3
	$zona_conexao_1.collision_mask = 3
	self.add_to_group("Players")
	conexao.conectar()
	

func _physics_process(delta):
	movimento.atualizar_gravidade(delta)
	movimento.processar_movimento()
	animacao.atualizar_animacao(movimento.direcao, movimento.esta_pulando, is_on_floor(), conexao.esta_desativado)
	


func _on_game_controller_restart() -> void:
	self.remove_from_group("Players")
	$process_timer.start()


func _on_process_timer_timeout() -> void:
	self.add_to_group("Players")
