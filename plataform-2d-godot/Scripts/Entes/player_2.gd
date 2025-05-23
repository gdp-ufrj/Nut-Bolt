extends CharacterBody2D

@export var SPEED: int = 90
@onready var timer = $Timer_conexao

var estado_original = SPEED
var _overlaping: Array = []
var colidiu_com_limites = false
var pode_grudar = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var desacoplou = false

func _ready() -> void:
	$zona_conexao_2.collision_layer = 3
	$zona_conexao_2.collision_mask = 3
	self.add_to_group("Players")

#region physics process
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	# SOM DE ANDAR
	if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_up_WASD") and is_on_floor():
		if not $audio_andar.is_playing():
			$audio_andar.play()
	else:
		$audio_andar.stop()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() and Input.is_action_pressed("ui_right_WASD") and pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
	
	if is_on_wall() and Input.is_action_pressed("ui_left_WASD") and pode_grudar:
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
	
	if colidiu_com_limites and is_on_floor():
		pode_grudar = true
		if desacoplou:
			$audio_pouso.play()
			desacoplou = false
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
	
	move_and_slide()
	#checa_proximidade()
#endregion

#region movimentação
# FUNCAO PARA IDENTIFICAR SE ENCOSTA EM ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = true

# FUNCAO PARA IDENTIFICAR SE DESENCOSTA DE ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = false
		pode_grudar = false
		$audio_desacoplar.play()
		desacoplou = true
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#endregion

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

func _on_game_controller_restart() -> void:
	conectar()
	
func _on_zona_conexao_2_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao_1" or area.name == "zona_conexao_rot":
		_overlaping.append(area)
		conectar()

func _on_zona_conexao_2_area_exited(area: Area2D) -> void:
	_overlaping.erase(area)
	if _overlaping.is_empty():
		if timer.is_stopped(): 
			timer.start()
			$aviso_conexao.play()

#endregion

#region antiga conexao
#func _on_zona_conexao_2_area_entered(area: Area2D) -> void:
	#var eh_conector: bool = false
	#if area.name == "zona_conexao_1":
		#conectores[0] = true
		#eh_conector = true
	#if area.name == "zona_conexao_rot":
		#conectores[1] = true
		#eh_conector = true
#
	#if (conectores[0] or conectores[1]) and eh_conector:
		#conectar()
#
#func _on_zona_conexao_2_area_exited(area: Area2D) -> void:
	#if area.name == "zona_conexao_1":
		#conectores[0] = false
	#if area.name == "zona_conexao_rot":
		#conectores[1] = false
	#
	#if conectores[0] or conectores[1]:
		#pass
	#else:
	#endregion 
