extends Control

#@onready var options_menu = $Opcoes_Menu as OptionsMenu
#@onready var canvaslayer = $CanvasLayer as CanvasLayer
@onready var main_menu = $CanvasLayer/VBoxContainer
@onready var configuracoes: Panel = $CanvasLayer/Configuracoes

func _ready():
	main_menu.visible = true
	configuracoes.visible = false
	load_display_settings()
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
	

#Botao de sair das configuracoes
func _on_voltar_configuracoes_pressed() -> void:
	configuracoes.call("_on_salvar_pressed")
	_ready()
	
#Aperte ESC para sair das configuracoes
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and configuracoes.visible:
		_on_voltar_configuracoes_pressed()
		
func load_display_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return
	
	var res = config.get_value("video", "resolution", Vector2i(1280, 720))
	var fullscreen = config.get_value("video", "fullscreen", false)
	
	DisplayServer.window_set_size(res)
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
