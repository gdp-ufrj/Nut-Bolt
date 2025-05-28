extends Control

@onready var options_menu = $Opcoes_Menu as OptionsMenu
@onready var canvaslayer = $CanvasLayer as CanvasLayer

func _ready():
	handle_connecting_signals()

#botao de start carregando as cenas do game controller
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/game_controller.tscn")

#botao de quitar do jogo
func _on_quit_pressed() -> void:
	get_tree().quit()

#botao de creditos ainda nao completado
func _on_creditos_pressed() -> void:
	pass # Replace with function body.

#botão de Opções ainda ainda não completado 
func _on_opções_pressed() -> void:
	canvaslayer.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	
func _on_exit_options_menu() -> void:
	canvaslayer.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	options_menu.exit_options_menu.connect(_on_exit_options_menu)
	
