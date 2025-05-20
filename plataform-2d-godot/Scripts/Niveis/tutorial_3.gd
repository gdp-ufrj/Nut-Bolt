extends Node2D

@onready var plat_1 = $Plataformas/plat_1
@onready var plat_2 = $Plataformas/plat_2
@onready var plat_3 = $Plataformas/plat_3
@onready var plat_4 = $Plataformas/plat_4

func _process(delta: float) -> void:
	plat_1.mo



func _on_botao_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_botao_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
