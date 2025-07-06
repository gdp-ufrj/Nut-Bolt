extends Panel

@onready var resolution_option: OptionButton = $Resolution
@onready var fullscreen_checkbox: CheckButton = $Fullscreen

#Lista de resoluções disponíveis
var resolutions = [
	Vector2i(800, 600),
	Vector2i(1024, 600),
	Vector2i(1440, 900),
	Vector2i(1600, 900),
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
]

func _ready():
	#Preenche o OptionButton com as resoluções
	for res in resolutions:
		resolution_option.add_item(str(res.x) + " x " + str(res.y))
	
	load_config()  #Carrega a configuração salva

#Salvar as configurações em um arquivo
func _on_salvar_pressed():
	var config = ConfigFile.new()
	
	#Pega a resolução escolhida
	var selected = resolution_option.get_selected()
	var res = resolutions[selected]
	config.set_value("video", "resolution", res)
	
	#Pega se o modo fullscreen está ativado
	var fullscreen = fullscreen_checkbox.button_pressed
	config.set_value("video", "fullscreen", fullscreen)
	
	#Salva no arquivo user://settings.cfg
	config.save("user://settings.cfg")
	
	#Aplica imediatamente
	apply_settings(res, fullscreen)

#Carrega e aplica a configuração salva
func load_config():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		return  #Nenhuma configuração salva ainda
	
	var res = config.get_value("video", "resolution", Vector2i(1280, 720))
	var fullscreen = config.get_value("video", "fullscreen", false)
	
	#Aplica nos elementos da UI
	var index = resolutions.find(res)
	if index != -1:
		resolution_option.select(index)
	fullscreen_checkbox.button_pressed = fullscreen
	
	#Aplica de verdade
	apply_settings(res, fullscreen)

#Aplica a resolução e fullscreen no jogo
func apply_settings(resolution: Vector2i, fullscreen: bool):
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
