extends Area2D
@onready var animador = $zona_conexao_rot/sprite_conexao/AnimationPlayer

func _ready() -> void:
	animador.play("Idle")
