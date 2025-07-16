extends Node2D

@onready var jogador = get_parent()

@onready var som_andar = $audio_andar
@onready var som_pouso = $audio_pouso
@onready var som_desacoplar = $audio_desacoplar

func processar_som():
	processar_som_passos()

func processar_som_passos():
	var esta_andando = Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD")
	var esta_desativado = jogador.esta_desativado
	var state = jogador.state
	
	if state != Vermelho.States.CAINDO and state != Vermelho.States.DESACOPLOU:
		if esta_andando and not esta_desativado:
			if not som_andar.is_playing():
				som_andar.play()
		else:
			som_andar.stop()
