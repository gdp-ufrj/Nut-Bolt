extends CharacterBody2D

@export var SPEED: int = 150
@onready var timer = $Timer_conexao
@onready var zona_conexao = $zona_conexao

var estado_original = SPEED
var colidiu_com_limites = false
var nao_pode_grudar = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#region physics process
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and Input.is_action_pressed("ui_right_WASD") and not nao_pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
			$Timer_grude.start()
	
	if is_on_wall() and Input.is_action_pressed("ui_left_WASD") and not nao_pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
			$Timer_grude.start()
	
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
#endregion

# FUNCAO PARA IDENTIFICAR SE ENCOSTA EM ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('limites'):
		print("colidiu")
		colidiu_com_limites = true

# FUNCAO PARA IDENTIFICAR SE DESENCOSTA DE ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = false
		nao_pode_grudar = true
		$Timer_grude.start()
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_Timer_grude_timeout():
	nao_pode_grudar = false

#region conexao
func conectar()->void:
	SPEED = estado_original
	timer.stop()
	$aviso_conexao.stop()

func desconectar()-> void:
	SPEED = 0
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
