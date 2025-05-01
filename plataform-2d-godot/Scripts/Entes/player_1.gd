extends CharacterBody2D

@export var SPEED: int = 300
@export var JUMP_VELOCITY: int = -400
@export var MAX_DISTANCE: int = 250
var pode_ativar_botao = false


func _ready() -> void:
	pass

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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


func _on_timer_conexao_timeout() -> void:
	self.SPEED = 0
	self.JUMP_VELOCITY = 0
