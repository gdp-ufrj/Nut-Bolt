extends CharacterBody2D

@export var SPEED: int = 95
@export var jump_height: float 
@export var jump_time_peak: float
@export var jump_time_descent: float

@onready var movimento = $Movimento_player_1
@onready var conexao = $Conexao_player_1
@onready var animacao = $Animacao_player_1

func _ready():
	$zona_conexao_1.collision_layer = 3
	$zona_conexao_1.collision_mask = 3
	conexao.conectar()
	
	

func _physics_process(delta):
	movimento.atualizar_gravidade(delta)
	movimento.processar_movimento(delta)
	animacao.atualizar_animacao(movimento.direcao, movimento.esta_pulando, is_on_floor(), conexao.esta_desativado)
	


func _on_game_controller_restart() -> void:
	self.set_process_mode(self.PROCESS_MODE_DISABLED)


func _on_game_controller_fase_carregada() -> void:
	self.set_process_mode(self.PROCESS_MODE_INHERIT)
