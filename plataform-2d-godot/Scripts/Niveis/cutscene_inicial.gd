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
			"e indo em busca da solução para a catástrofe \nenergética que ameaça nosso planeta."
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene2.png"),
		"falas": [
			"Não vou mentir\n deixar minha melhor amiga na Terra...",
			"e atravessar um portal\n para outra galáxia não foi nada fácil…",
			
			"Querida Auri, \nNós duas fizemos esses robôs no final da faculdade", 
			"lembra?  Tínhamos tantos  sonhos e\n jamais poderíamos ter imaginado\n tudo o que viria a acontecer desde então.",
			"Espero que entenda que estamos fazendo\n isso por essas duas melhores amigas que sabiam\n que iam conquistar o mundo um dia.",
			"Deixo essas recordações com o desejo de serem\n essas as memórias que você guarda de mim…",
			"Sei que vai dar um jeito\n você sempre consegue.\n Boa sorte, Layla.",

		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene3.png"),
		"falas": [
			"Bem, imaginem minha sorte",
			"quando a nave passou pelo portal e colapsou a saída!",
			"E junto com ela,\n se foi qualquer esperança de voltar para casa…",
		
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene4.png"),
		"falas": [ 
			"Foi assim que cheguei no planeta\n mais extraordinário do universo",
			"Apeirokméia.\n Mas essa história eu conto melhor mais tarde."
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene5.png"),
		"falas": [
			"Acontece que meu plano para gerar energia\n também não estava saindo como esperado…"
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene6.png"),
		"falas": [
			"Porém, tudo mudou em uma noite de tempestade",
			"quando um raio atingiu uma jazida\n de um mineral desconhecido nos arredores da nave",
			"Assim formou-se um novo elemento\n com propriedades jamais vistas:\n o Apeiron"
		]
	},
	{
		"imagem": preload("res://Sprites/Cutscene/TemplateNovoCutscene7.png"),
		"falas": [
			"Depois disso, ainda tive a surpresa de ganhar\n dois companheiros robôs para ajudar na minha missão.",
			"E foi dessa forma que Nut e Bolt\n  entraram na minha história",
			"E essa história está só começando…"
		]
	}
]

var imagem_atual := 0
var fala_atual := 0
var texto_completo: String = ""
var indice_letra: int = 0
var velocidade: float = 0.06  # tempo entre letras

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
