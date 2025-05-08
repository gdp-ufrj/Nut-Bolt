extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Niveis/tutorial_1.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Testes/CreditoFurreca.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
