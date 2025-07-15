extends Area2D

#nao funcional, ainda tem que descobrir o erro.

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	print("Entrou algo:", body)
	if body.is_in_group("Players"):
		print("Item coletado!")
		queue_free()
