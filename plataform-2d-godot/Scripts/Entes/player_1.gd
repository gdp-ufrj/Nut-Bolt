extends CharacterBody2D

@export var SPEED: int = 130 # Alcance de 10 tiles (100px)
@export var JUMP_VELOCITY: int = -320 # Pulo de 5 tiles (50px)
#@export var MAX_DISTANCE: int = 250
@onready var timer = $Timer_conexao
@onready var zona_conexao = $zona_conexao

var estado_original: Array = [SPEED, JUMP_VELOCITY]
var pode_ativar_botao = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	move_and_slide() 
	
	if pode_ativar_botao and Input.is_action_just_pressed("interagir"):
		$"../plataforma/AnimationPlayer".play("move")
		
#endregion

#region Conexão
func conectar()->void:
	SPEED = estado_original[0]
	JUMP_VELOCITY = estado_original[1]
	timer.stop()
	$aviso_conexao.stop()
	

func desconectar()-> void:
	SPEED = 0
	JUMP_VELOCITY = 0
	$aviso_conexao.stop()

func _on_timer_conexao_timeout() -> void:
	desconectar()

func _on_zona_conexao_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao":
		conectar()

func _on_zona_conexao_area_exited(area: Area2D) -> void:
	if area.name == "zona_conexao":
		if timer.is_stopped(): 
			timer.start()
			$aviso_conexao.play()

			

#endregion
