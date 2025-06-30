extends Node2D

@onready var corpo: CharacterBody2D = get_parent()
@onready var jump_velocity: float = ((2.0 * corpo.jump_height) / corpo.jump_time_peak)* -1
@onready var jump_gravity: float = ((-2.0 * corpo.jump_height) / (corpo.jump_time_peak**2))* -1
@onready var fall_gravity: float = ((-2.0 * corpo.jump_height) / (corpo.jump_time_descent**2)) * -1
@onready var coyote_timer: Timer = corpo.get_node("CoyoteTimer")

var direcao := 0.0
var esta_pulando := false
var pode_pular := true
var proximo_som_salto := 1


func atualizar_gravidade(delta: float):
	if not corpo.is_on_floor():
		corpo.velocity.y += get_gravity() * delta

func get_gravity():
	return jump_gravity if corpo.velocity.y < 0.0 else fall_gravity
	
func processar_movimento(delta):
	var estava_no_chao = corpo.is_on_floor()
	direcao = Input.get_axis("ui_left", "ui_right")

	if direcao:
		corpo.velocity.x = direcao * corpo.SPEED
	else:
		corpo.velocity.x = move_toward(corpo.velocity.x, 0, corpo.SPEED)

	var no_chao = corpo.is_on_floor()
	var pode_usar_coyote = not coyote_timer.is_stopped()

	# CORRIGIDO: pulo só acontece se estiver no chão ou com coyote time
	if (no_chao or pode_usar_coyote) and Input.is_action_just_pressed("ui_up"):
		corpo.velocity.y = jump_velocity
		esta_pulando = true
		pode_pular = false

		if proximo_som_salto == 1 and not corpo.get_node("Conexao_player_1").esta_desativado:
			corpo.get_node("audio_salto1").play()
			proximo_som_salto = 2
		else:
			if not corpo.get_node("Conexao_player_1").esta_desativado:
				corpo.get_node("audio_salto2").play()
				proximo_som_salto = 1

	corpo.move_and_slide()

	if esta_pulando and corpo.is_on_floor() and not corpo.get_node("Conexao_player_1").esta_desativado:
		esta_pulando = false
		pode_pular = true
		corpo.get_node("audio_pouso").play()

	if estava_no_chao and not corpo.is_on_floor():
		coyote_timer.start()

	# sons de caminhar
	var som_caminhar = corpo.get_node("audio_caminhar")
	if direcao != 0 and corpo.is_on_floor() and not corpo.get_node("Conexao_player_1").esta_desativado:
		if not som_caminhar.is_playing():
			som_caminhar.play()
	else:
		som_caminhar.stop()
