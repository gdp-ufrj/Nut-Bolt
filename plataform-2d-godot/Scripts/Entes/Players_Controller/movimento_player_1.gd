extends Node2D

@export var SPEED: int = 130
@export var JUMP_VELOCITY: int = -320

@onready var corpo: CharacterBody2D = get_parent()
@onready var coyote_timer: Timer = corpo.get_node("CoyoteTimer")

var direcao := 0.0
var esta_pulando := false
var pode_pular := true
var proximo_som_salto := 1

func atualizar_gravidade(delta: float):
	if not corpo.is_on_floor():
		corpo.velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

func processar_movimento():
	var estava_no_chao = corpo.is_on_floor()
	direcao = Input.get_axis("ui_left", "ui_right")
	
	if direcao:
		corpo.velocity.x = direcao * SPEED
	else:
		corpo.velocity.x = move_toward(corpo.velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("ui_up") and (corpo.is_on_floor() or not coyote_timer.is_stopped()):
		corpo.velocity.y = JUMP_VELOCITY
		esta_pulando = true
		pode_pular = false
		if proximo_som_salto == 1:
			corpo.get_node("audio_salto1").play()
			proximo_som_salto = 2
		else:
			corpo.get_node("audio_salto2").play()
			proximo_som_salto = 1

	corpo.move_and_slide()

	if esta_pulando and corpo.is_on_floor():
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
