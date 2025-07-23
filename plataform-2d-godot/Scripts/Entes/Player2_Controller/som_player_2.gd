extends Node2D

@onready var jogador = get_parent()

@onready var som_andar = $audio_andar
@onready var som_pouso = $audio_pouso

func processar_som():
	var state = jogador.state
	var prev_state = jogador.prev_state
	
	processar_som_passos(state)
	processar_som_pouso(state, prev_state)

func processar_som_passos(state):
	var esta_andando = Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD")
	var esta_desativado = jogador.esta_desativado
	
	if state != Vermelho.States.CAINDO and state != Vermelho.States.DESACOPLOU:
		if esta_andando and not esta_desativado:
			if not som_andar.is_playing():
				som_andar.play()
		else:
			som_andar.stop()

func processar_som_pouso(state, prev_state):
	if state == Vermelho.States.DESACOPLOU and prev_state != Vermelho.States.CAINDO:
		if jogador.is_on_floor():
			som_pouso.play()
