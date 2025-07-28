extends CanvasLayer

@onready var text_box: RichTextLabel = $Panel/ScrollContainer/MarginContainer/VBoxContainer/DiaryText
@onready var button: Button = $Panel/ScrollContainer/MarginContainer/VBoxContainer/Fechar

var is_showing := false
var current_diary_id: int = 1

func _ready():
	hide()
	button.pressed.connect(_on_close_pressed)

func show_text(text: String, diary_id: int) -> void:
	text_box.clear()
	text_box.append_text(text)
	current_diary_id = diary_id
	is_showing = true
	show()
	get_tree().paused = true
	button.grab_focus()

func _on_close_pressed():
	get_tree().paused = false
	hide()
	is_showing = false
	
	# Quando fecha, inicia o Dialogic com a timeline correspondente
	Dialogic.start("Diario" + str(current_diary_id))

func reset():
	hide()
	is_showing = false
	get_tree().paused = false
