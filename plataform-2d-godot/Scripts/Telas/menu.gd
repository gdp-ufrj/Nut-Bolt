extends Node2D

#botao de start carregando as cenas do game controller
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/game_controller.tscn")

#botao de quitar do jogo
func _on_quit_pressed() -> void:
	get_tree().quit()

#botao de creditos ainda nao completado
func _on_creditos_pressed() -> void:
	pass # Replace with function body.

#botão de Opções ainda ainda não completado 
func _on_opções_pressed() -> void:
	pass # Replace with function body.
