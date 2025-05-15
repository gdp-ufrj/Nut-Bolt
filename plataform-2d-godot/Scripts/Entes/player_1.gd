extends CharacterBody2D

@export var SPEED: int = 130 # Alcance de 10 tiles (100px)
@export var JUMP_VELOCITY: int = -320 # Pulo de 5 tiles (50px)
@onready var timer = $Timer_conexao

var estado_original: Array = [SPEED, JUMP_VELOCITY]
var conectores: Array = [true, false] #são eles o outro player e o roteador
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

func _on_zona_conexao_1_area_entered(area: Area2D) -> void:
		if area.name == "zona_conexao_2":
			conectores[0] = true
		if area.name == "zona_conexao_rot":
			conectores[1] = true
			
		if conectores[0] or conectores[1]:
			conectar()
			

func _on_zona_conexao_1_area_exited(area: Area2D) -> void:
	if area.name == "zona_conexao_2":
		conectores[0] = false
	if area.name == "zona_conexao_rot":
		conectores[1] = false
		
	if conectores[0] or conectores[1]:
		pass
	else:
		if timer.is_stopped(): 
			timer.start()
			$aviso_conexao.play()
		

func _on_game_controller_restart() -> void:
	conectar()
	
#endregion
