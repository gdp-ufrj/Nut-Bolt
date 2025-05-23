extends Area2D

func _ready() -> void:
	$zona_conexao_rot.collision_layer = 3
	$zona_conexao_rot.collision_mask = 3
