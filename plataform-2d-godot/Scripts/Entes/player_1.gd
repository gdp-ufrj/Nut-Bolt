extends CharacterBody2D

@export var SPEED: int = 130 # Alcance de 10 tiles (100px)
@export var JUMP_VELOCITY: int = -320 # Pulo de 5 tiles (50px)
@onready var timer = $Timer_conexao

var estado_original: Array = [SPEED, JUMP_VELOCITY]
var _overlaping: Array = []
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	move_and_slide() 
	#checa_proximidade()
	
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

func _on_game_controller_restart() -> void:
	conectar()

func _on_zona_conexao_1_area_entered(area: Area2D) -> void:
	if area.name == "zona_conexao_2" or area.name == "zona_conexao_rot":
		_overlaping.append(area)
		conectar()

func _on_zona_conexao_1_area_exited(area: Area2D) -> void:
	_overlaping.erase(area)
	if _overlaping.is_empty():
		if timer.is_stopped(): 
			timer.start()
			$aviso_conexao.play()

#endregion

#region antigo codigo de conexao
	#func _on_zona_conexao_1_area_entered(area: Area2D) -> void:
		##var eh_conector: bool = false
		#if area.name == "zona_conexao_2":
			#conectores[0] = true
			##eh_conector = true
		#if area.name == "zona_conexao_rot":
			#conectores[1] = true
			##eh_conector = true
		## Se o jogador estiver dentro de alguma zona_conexao, conecta
		#if (conectores[0] or conectores[1]):
			#conectar()
#
#func _on_zona_conexao_1_area_exited(area: Area2D) -> void:
	#if $zona_conexao_1.has_overlapping_areas():
		#pass
	#else:
		#if area.name == "zona_conexao_2":
			#conectores[0] = false
		#if area.name == "zona_conexao_rot":
			#conectores[1] = false
		#
	## Se o jogador estiver fora de todas as zonas_conexao, começa o timer
	#if conectores[0] or conectores[1]:
		#pass
	#else:
		#if timer.is_stopped(): 
			#timer.start()
			#$aviso_conexao.play()
		
#endregion
