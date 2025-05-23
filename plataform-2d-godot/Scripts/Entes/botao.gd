extends Area2D
var is_untouched: bool = true

func _ready() -> void:
	self.remove_from_group("pode_ativar")

func _on_body_entered(body: Node2D) -> void:
	if is_untouched and body.is_in_group("Players"):
		$Label.show()
		self.add_to_group("pode_ativar")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		$Label.hide()
		self.remove_from_group("pode_ativar")

func _on_tutorial_2_botao_ativado() -> void:
	is_untouched = false
