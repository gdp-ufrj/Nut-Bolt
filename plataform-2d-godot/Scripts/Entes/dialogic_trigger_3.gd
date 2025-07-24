extends Area2D

@export var timeline : String = "Fim do MVP"
var ja_tocou := false

func _on_body_entered(body: Node2D):
	if body.is_in_group("Players") and not ja_tocou:
		ja_tocou = true
		if Dialogic.current_timeline == null:
			print("Iniciando timeline:", timeline)
			Dialogic.start(timeline)
			Dialogic.timeline_ended.connect(_on_dialogo_finalizado)

func _on_dialogo_finalizado():
	Dialogic.timeline_ended.disconnect(_on_dialogo_finalizado)
	print("Diálogo final da fase terminado")
	get_tree().get_root().get_node("Game Controller").get_fase_tipo()
	get_tree().change_scene_to_file("res://proxima_fase.tscn")
