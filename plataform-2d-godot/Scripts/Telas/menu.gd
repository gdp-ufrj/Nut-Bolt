extends Control

@onready var main_menu = $CanvasLayer/VBoxContainer
@onready var settings_spawner = $CanvasLayer/SettingsSpawner

func _ready():
	call_deferred("_apply_saved_settings")
	main_menu.visible = true

# Botão de Start: inicia o jogo
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/game_controller.tscn")

# Botão de Load Game (ainda não implementado)
func _on_load_pressed() -> void:
	pass

# Botão de Créditos (ainda não implementado)
func _on_creditos_pressed() -> void:
	pass

# Botão de Quit: fecha o jogo
func _on_quit_pressed() -> void:
	get_tree().quit()

# Botão de Opções: instancia a nova cena de configurações
func _on_opções_pressed() -> void:
	main_menu.visible = false
	
	var settings_scene = load("res://Cenas/UI/configuracoes.tscn")  #Caminho da nova cena
	var instance = settings_scene.instantiate()
	
	instance.origem = "menu"
	
	settings_spawner.add_child(instance)
	#Conecta o sinal que será emitido quando o usuário sair das configurações
	instance.connect("fechar_configuracoes", Callable(self, "_on_fechar_configuracoes"))

#Quando fecha a tela de configurações, volta ao menu principal
func _on_fechar_configuracoes(origem: String):
	if origem == "menu":
		main_menu.visible = true

#Aperte ESC para sair das configurações (aplica-se apenas se uma instância estiver ativa)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var config_screen = settings_spawner.get_child(0)
		if config_screen and config_screen.has_method("fechar"):
			config_screen.fechar()

#Carrega as configurações de vídeo
func _apply_saved_settings():
	await get_tree().process_frame
	await get_tree().process_frame

	var config = ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		print("⚠️ Nenhuma configuração salva")
		return

	var res = config.get_value("video", "resolution", Vector2i(1280, 720))
	var fullscreen = config.get_value("video", "fullscreen", false)

	#Primeiro define o modo de janela
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
	
	#Espera o modo de tela aplicar
	await get_tree().process_frame
	
	#Depois aplica a resolução
	if !fullscreen:
		DisplayServer.window_set_size(res)
	
	#Áudio
	var volume_musica = config.get_value("audio", "audio_controller", 0.5)
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(volume_musica))

	var volume_sfx = config.get_value("audio", "sfx", 0.5)
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(volume_sfx))

	print("✅ Configurações aplicadas. Resolução:", res, "Fullscreen:", fullscreen)
