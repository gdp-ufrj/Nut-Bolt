extends Area2D

@export_multiline var diary_text: String

var can_collect := false

func _ready():
	#connect("body_entered", Callable(self, "_on_body_entered")) tava dando erro
	await get_tree().create_timer(0.1).timeout
	can_collect = true  #Só permite coleta após 0.1s

func _on_body_entered(body: Node2D) -> void:
	if can_collect and body.is_in_group("Players"):
		DiaryUI.show_text(diary_text)
		queue_free()
