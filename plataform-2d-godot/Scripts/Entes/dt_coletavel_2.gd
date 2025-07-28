extends Area2D

@export_multiline var diary_text: String
@export var timeline: String = "DColetavel2"
var ja_tocou := false

func _ready():
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not ja_tocou:
		ja_tocou = true

		DiaryUI.diario_fechado.connect(_on_diario_fechado)
		DiaryUI.show_text(diary_text)

func _on_diario_fechado():
	DiaryUI.diario_fechado.disconnect(_on_diario_fechado)
	
	if Dialogic.current_timeline == null:
		Dialogic.start(timeline)
