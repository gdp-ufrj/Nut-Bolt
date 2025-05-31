extends CharacterBody2D

@export var SPEED: int = 130 # Alcance de 10 tiles (100px)
@export var JUMP_VELOCITY: int = -320 # Pulo de 5 tiles (50px)
@onready var timer = $Timer_conexao
@onready var animation: AnimatedSprite2D = $"Animaçao"
@onready var animador_conexao: AnimationPlayer = $zona_conexao_1/Sprite2D/AnimationPlayer

var estado_original: Array = [SPEED, JUMP_VELOCITY]
var _overlaping: Array = []
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var esta_desativado = false
var pode_pular = true
var esta_pulando = false
var proximo_som_salto = 1 # variavel para variar os sons de salto
var som_desligar_ja_tocado = false

func _ready() -> void:
	$zona_conexao_1.collision_layer = 3
	$zona_conexao_1.collision_mask = 3
	self.add_to_group("Players")
	conectar()

#region Physics process
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		
	setAnimation(direction)
	
	move_and_slide() 
	
	# SONS DO PULA
	# SOM DE CAMINHAR
	if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and is_on_floor() and not esta_desativado:
		if not $audio_caminhar.is_playing():
			$audio_caminhar.play()
	else:
		$audio_caminhar.stop()
	
	# SONS DE SALTO
	if pode_pular and Input.is_action_just_pressed("ui_up") and not esta_desativado:
		esta_pulando = true
		pode_pular = false
		if proximo_som_salto == 1:
			$audio_salto1.play()
			proximo_som_salto = 2
		else:
			$audio_salto2.play()
			proximo_som_salto = 1
	
	# SOM DE POUSO
	if esta_pulando and is_on_floor():
		esta_pulando = false
		pode_pular = true
		$audio_pouso.play()
	
#endregion

#region Conexão
func conectar(veio_de_desativado: bool = false)->void:
	esta_desativado = false  #ESSENCIAL
	SPEED = estado_original[0]
	JUMP_VELOCITY = estado_original[1]
	timer.stop()
	$aviso_conexao.stop()
	som_desligar_ja_tocado = false
	if veio_de_desativado:
		$reestabelece_conexao.play()

func desconectar()-> void:
	SPEED = 0
	JUMP_VELOCITY = 0
	$aviso_conexao.stop()

func _on_timer_conexao_timeout() -> void:
	#animaçao de desativado
	esta_desativado = true
	animation.play("Desativado")
	if not som_desligar_ja_tocado:
		$audio_desligar.play()
		som_desligar_ja_tocado = true
	desconectar()

func _on_zona_conexao_1_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao_2" or area.name == "zona_conexao_rot":
		_overlaping.append(area)
		conectar(esta_desativado)
		animador_conexao.play("Idle")

func _on_zona_conexao_1_area_exited(area: Area2D) -> void:
	_overlaping.erase(area)
	if _overlaping.is_empty():
		if timer.is_stopped(): 
			timer.start()
			$aviso_conexao.play()
			animador_conexao.play("desconectando")

func _on_game_controller_restart() -> void:
	conectar()  
#endregion

#animação
#flip
func setAnimation(direction):
	#Anim desativado
	if esta_desativado:
		if animation.animation != "Desativado":
			animation.play("Desativado")
		return  # Não continua se estiver desativado
	
	if direction > 0: 
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
	

#Corrida e pulo
	if not is_on_floor():
		if animation.animation != "vertical_pular":
			animation.play("vertical_pular")
	elif abs(direction) > 0:
		if animation.animation != "run":
			animation.play("run")
	else:
		if animation.animation != "idle":
			animation.play("idle")
