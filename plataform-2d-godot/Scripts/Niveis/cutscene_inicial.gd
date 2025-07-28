extends Node2D

@onready var imagem: Sprite2D = $CanvasLayer/Sprite2D
@onready var legenda: Label = $CanvasLayer/Legenda
@onready var typing_timer: Timer = $TypingTimer

# Lista de imagens e falas
var cutscene_data = [
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene1.png"),
		"falas": [
			"Essa sou eu, Auri\nme despedindo da minha parceira de pesquisa...",
			"e indo em busca da solução para a catástrofe energética que ameaça nosso planeta."
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene2.png"),
		"falas": [
			"Não vou mentir, deixar minha melhor amiga na Terra...",
			"e atravessar um portal para outra galáxia não foi nada fácil…"
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene3.png"),
		"falas": ["Boa sorte!"]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene4.png"),
		"falas": ["Boa sorte!"]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene5.png"),
		"falas": ["Boa sorte!"]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene6.png"),
		"falas": ["Boa sorte!"]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene7.png"),
		"falas": ["Boa sorte!"]
	}
]

var imagem_atual := 0
var fala_atual := 0
var texto_completo: String = ""
var indice_letra: int = 0
var velocidade: float = 0.03  # tempo entre letras

func _ready():
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	mostrar_fala()

func mostrar_fala():
	if imagem_atual >= cutscene_data.size():
		ir_para_primeira_fase()
		return

	var dados = cutscene_data[imagem_atual]
	var falas_da_imagem = dados["falas"]

	# Se todas as falas dessa imagem já foram mostradas, ir para a próxima imagem
	if fala_atual >= falas_da_imagem.size():
		imagem_atual += 1
		fala_atual = 0
		mostrar_fala()
		return

	# Atualiza a imagem apenas na primeira fala da imagem
	if fala_atual == 0:
		imagem.texture = dados["imagem"]
		ajustar_imagem_para_tela()

	texto_completo = falas_da_imagem[fala_atual]
	indice_letra = 0
	legenda.text = ""
	typing_timer.wait_time = velocidade
	typing_timer.start()

func _on_typing_timer_timeout():
	if indice_letra < texto_completo.length():
		legenda.text += texto_completo[indice_letra]
		indice_letra += 1
		typing_timer.start()
	else:
		typing_timer.stop()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):  # Espaço ou Enter
		if typing_timer.is_stopped():
			fala_atual += 1
			mostrar_fala()
		else:
			legenda.text = texto_completo
			typing_timer.stop()

func ir_para_primeira_fase():
	get_tree().change_scene_to_file("res://Cenas/game_controller.tscn")

func ajustar_imagem_para_tela():
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = imagem.texture.get_size()
	var scale_factor = max(screen_size.x / texture_size.x, screen_size.y / texture_size.y)
	imagem.scale = Vector2(scale_factor, scale_factor)
	imagem.position = screen_size / 2
