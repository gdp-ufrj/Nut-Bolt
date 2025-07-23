extends CanvasLayer

@onready var label = $Panel/DiaryLabel
@onready var button = $Panel/Fechar

func _ready():
	hide()
	button.pressed.connect(_on_close_pressed)

var is_showing := false  # controla se o popup está visível

func show_text(text: String) -> void:
	label.text = text
	is_showing = true
	show()
	get_tree().paused = true
	button.grab_focus()

func _on_close_pressed():
	get_tree().paused = false
	hide()
	is_showing = false
	
func reset():
	hide()
	is_showing = false
	get_tree().paused = false
