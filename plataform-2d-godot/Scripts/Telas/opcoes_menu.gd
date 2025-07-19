extends Control

signal fechar_configuracoes

@onready var resolution_option: OptionButton = $Configuracoes/Resolution
@onready var fullscreen_checkbox: CheckButton = $Configuracoes/Fullscreen
@onready var music_slider: HSlider = $Configuracoes/Audio_Controller
@onready var sfx_slider: HSlider = $Configuracoes/SFX

#"menu" ou "pause"
var origem: String = "menu"  #Padrão

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
	process_mode = Node.PROCESS_MODE_ALWAYS
	#Preenche o OptionButton com as resoluções
	for res in resolutions:
		resolution_option.add_item(str(res.x) + " x " + str(res.y))
	
	load_config()

#Função chamada ao clicar no botão "Salvar e Voltar"
func _on_voltar_pressed():
	_on_salvar_pressed()
	emit_signal("fechar_configuracoes", origem)
	queue_free()

#Também pode ser chamada via ESC pelo script do menu
func fechar():
	_on_voltar_pressed()

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
	
	#Pega o volume da musica escolhido
	var volume_musica = music_slider.value
	config.set_value("audio", "audio_controller", volume_musica)
	
	#Pega o volume dos sfx escolhido
	var volume_sfx = sfx_slider.value
	config.set_value("audio", "sfx", volume_sfx)

	# Salva no arquivo user://settings.cfg
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
	var volume_musica = config.get_value("audio", "audio_controller", 0.5)
	music_slider.value = volume_musica
	var volume_sfx = config.get_value("audio", "sfx", 0.5)
	sfx_slider.value = volume_sfx

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
