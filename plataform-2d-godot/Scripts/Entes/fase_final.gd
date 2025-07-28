extends Area2D

@onready var animation: AnimatedSprite2D = $"Abre e fecha"

var ja_tocou := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not ja_tocou:	
		if Dialogic.current_timeline == null:
			Dialogic.start("DialogoFinal")
			ja_tocou = true
