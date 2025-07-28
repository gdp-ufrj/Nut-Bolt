extends Area2D

@export_multiline var diary_text: String
@export var diary_id: int = 1  # ID do diário para saber qual timeline rodar

var can_collect := false

func _ready():
	await get_tree().create_timer(0.1).timeout
	can_collect = true

func _on_body_entered(body: Node2D) -> void:
	if can_collect and body.is_in_group("Players"):
		DiaryUI.show_text(diary_text, diary_id) # Passa o ID do diário
		queue_free()
