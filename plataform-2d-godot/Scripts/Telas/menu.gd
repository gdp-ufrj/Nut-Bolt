extends Control

#@onready var options_menu = $Opcoes_Menu as OptionsMenu
#@onready var canvaslayer = $CanvasLayer as CanvasLayer
@onready var main_menu = $CanvasLayer/VBoxContainer
@onready var configuracoes: Panel = $CanvasLayer/Configuracoes

func _ready():
	main_menu.visible = true
	configuracoes.visible = false
	#handle_connecting_signals()

#botao de start carregando as cenas do game controller
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/game_controller.tscn")
	
	
#botao de load game, nao implementado
func _on_load_pressed() -> void:
	pass # Replace with function body.

#botao de quitar do jogo
func _on_quit_pressed() -> void:
	get_tree().quit()

#botao de creditos ainda nao completado
func _on_creditos_pressed() -> void:
	pass # Replace with function body.

#botão de Opções ainda ainda não completado 
func _on_opções_pressed() -> void:
	main_menu.visible = false
	configuracoes.visible = true
	#options_menu.visible = true
	
#func _on_exit_options_menu() -> void:
	#canvaslayer.visible = true
	#options_menu.visible = false

#func handle_connecting_signals() -> void:
	#options_menu.exit_options_menu.connect(_on_exit_options_menu)
	

#Botao de sair das configuracoes
func _on_voltar_configuracoes_pressed() -> void:
	_ready()
