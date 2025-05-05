extends CharacterBody2D

@export var SPEED: int = 300
@export var JUMP_VELOCITY: int = -400
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

#region Tutorial 2 
func _on_botao_body_entered(body: Node2D) -> void:
	if body == self:
		$"../Botao/Label".visible = true
		pode_ativar_botao = true

func _on_botao_body_exited(body: Node2D) -> void:
	if body == self:
		$"../Botao/Label".visible = false
		pode_ativar_botao = false

# FUNCAO PRO PERSONAGEM NAO SER ESMAGADO PELA PLATAFORMA
func _on_area_para_evitar_bug_body_entered(body: Node2D) -> void:
	if body == self:
		if $"../plataforma/AnimationPlayer".is_playing(): 
			$"../plataforma/AnimationPlayer".pause()
			$"../plataforma".position.y - 10

# QUANDO O PERSONAGEM SAI DE BAIXO DA PLATAFORMA A ANIMACAO VOLTA A TOCAR
func _on_area_para_evitar_bug_body_exited(body: Node2D) -> void:
	if body == self:
		$"../plataforma/AnimationPlayer".play("move")
		
#endregion
	
#region Conexão
func conectar()->void:
	SPEED = estado_original[0]
	JUMP_VELOCITY = estado_original[1]
	timer.stop()

func desconectar()-> void:
	SPEED = 0
	JUMP_VELOCITY = 0

func _on_timer_conexao_timeout() -> void:
	desconectar()

func _on_zona_conexao_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao":
		conectar()

func _on_zona_conexao_area_exited(area: Area2D) -> void:
	if area.name == "zona_conexao":
		if timer.is_stopped(): 
			timer.start()

#endregion
