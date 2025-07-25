extends Node2D

@onready var imagem: Sprite2D = $CanvasLayer/Sprite2D
@onready var legenda: Label = $CanvasLayer/Legenda
@onready var typing_timer: Timer = $TypingTimer

#Lista de imagens da cutscene
var imagens = [
	preload("res://Sprites/Cutscene/TemplateNovoCutscene1.png"),
	preload("res://Sprites/Cutscene/TemplateNovoCutscene2.png"),
	preload("res://Sprites/Cutscene/TemplateNovoCutscene3.png"),
	preload("res://Sprites/Cutscene/TemplateNovoCutscene4.png"),
	preload("res://Sprites/Cutscene/TemplateNovoCutscene5.png"),
	preload("res://Sprites/Cutscene/TemplateNovoCutscene6.png"),
	preload("res://Sprites/Cutscene/TemplateNovoCutscene7.png")
]

#Lista de falas
var falas = [
	"Querido aventureiro,\nHoje começa a sua jornada...", #Texto cutscene1
	"Você deve encontrar o templo perdido...", #Texto cutscene2
	"Boa sorte!", #Texto cutscene3
	"Boa sorte!", #Texto cutscene4
	"Boa sorte!", #Texto cutscene5
	"Boa sorte!", #Texto cutscene6
	"Boa sorte!" #Texto cutscene7
]

var fala_atual: int = 0
var texto_completo: String = ""
var indice_letra: int = 0
var velocidade: float = 0.03  #tempo entre letras

func _ready():
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	ajustar_imagem_para_tela()
	mostrar_fala(fala_atual)

func mostrar_fala(index: int):
	if index >= falas.size():
		ir_para_primeira_fase()
		return

	#Define imagem e texto
	imagem.texture = imagens[index]
	texto_completo = falas[index]
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
	if event.is_action_pressed("ui_accept"):  #Espaço ou enter
		if typing_timer.is_stopped():
			fala_atual += 1
			mostrar_fala(fala_atual)
		else:
			#Se ainda está digitando, mostra o texto inteiro de uma vez
			legenda.text = texto_completo
			typing_timer.stop()

func ir_para_primeira_fase():
	get_tree().change_scene_to_file("res://Cenas/game_controller.tscn")

func ajustar_imagem_para_tela():
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = imagem.texture.get_size()
	
	#Calcula escala mantendo a proporção e preenchendo toda a tela
	var scale_factor = max(screen_size.x / texture_size.x, screen_size.y / texture_size.y)
	imagem.scale = Vector2(scale_factor, scale_factor)
	
	#Centraliza
	imagem.position = screen_size / 2
