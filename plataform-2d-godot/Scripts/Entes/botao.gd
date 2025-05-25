extends Area2D
var is_untouched: bool = true 
var pode_ativar: bool = false

func _on_body_entered(body: Node2D) -> void:
	if is_untouched and body.is_in_group("Players"):
		$Label.show()
		self.pode_ativar = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		$Label.hide()
		self.pode_ativar = false

func _on_tutorial_2_botao_ativado() -> void:
	is_untouched = false
