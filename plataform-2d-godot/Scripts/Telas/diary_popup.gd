extends CanvasLayer

signal diario_fechado

@onready var text_box: RichTextLabel = $Panel/ScrollContainer/MarginContainer/VBoxContainer/DiaryText
@onready var button: Button = $Panel/ScrollContainer/MarginContainer/VBoxContainer/Fechar

var is_showing := false

func _ready():
	hide()
	button.pressed.connect(_on_close_pressed)

func show_text(text: String) -> void:
	text_box.clear()
	text_box.append_text(text)
	is_showing = true
	show()
	get_tree().paused = true
	button.grab_focus()

func _on_close_pressed():
	get_tree().paused = false
	hide()
	is_showing = false
	emit_signal("diario_fechado")
	
func reset():
	hide()
	is_showing = false
	get_tree().paused = false
