extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400

@export var SPEED: int = 150
#@export var other_character: Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var game_over = false  # Variável para impedir múltiplos prints
var pode_ativar_botao = false
var colidiu_com_limites = false

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and Input.is_action_pressed("ui_right_WASD"):
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
	
	if is_on_wall() and Input.is_action_pressed("ui_left_WASD"):
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
	
	if is_on_ceiling() and (Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD")):
		if(colidiu_com_limites):
			gravity = -50
			velocity.y = -velocity.y
	
	if is_on_ceiling() and Input.is_action_pressed("ui_down_WASD"):
		if gravity == -50:
			gravity = 980
			velocity.y = -velocity.y
	
	if is_on_wall() and gravity == -50:
		if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD"):
			gravity = 980
			velocity.y = -velocity.y
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
	
	move_and_slide()
	
	if pode_ativar_botao and Input.is_action_just_pressed("interagir"):
		$"../plataforma/AnimationPlayer".play("move")
	
	#if other_character:
	#	var distance = global_position.distance_to(other_character.global_position)
	#	if distance > DISTANCE and not game_over:
	#		game_over = true
	#		print("YOU RE DIE")

# Funcao para quando o personagem entra na area do botao
func _on_botao_body_entered(body: Node2D) -> void:
	if body == self:
		$"../Botao/Label".visible = true
		pode_ativar_botao = true

# Funcao para quando o personagem sai da area do botao
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

func _on_timer_conexao_2_timeout() -> void:
	self.SPEED = 0

# FUNCAO PARA IDENTIFICAR SE ENCOSTA EM ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = true

# FUNCAO PARA IDENTIFICAR SE DESENCOSTA DE ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = false
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
