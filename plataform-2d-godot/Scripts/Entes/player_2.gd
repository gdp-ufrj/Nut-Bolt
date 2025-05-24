extends CharacterBody2D

@export var SPEED: int = 90
@onready var timer = $Timer_conexao
@onready var animation: AnimatedSprite2D = $"Animação"

var estado_original = SPEED
var conectores: Array = [false, false] #conectores[0] = outro player e [1] é o roteador
var colidiu_com_limites = false
var pode_grudar = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var desacoplou = false
var esta_desativado = false
var som_desligar_ja_tocado = false

#region physics process
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	# SOM DE ANDAR
	if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_up_WASD") and is_on_floor() and not esta_desativado:
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
	
	# SOM DE POUSO
	if colidiu_com_limites and is_on_floor():
		pode_grudar = true
		if desacoplou:
			$audio_pouso.play()
			desacoplou = false
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		
	setAnimation(direction)
	
	move_and_slide()
#endregion

#region movimentação
# FUNCAO PARA IDENTIFICAR SE ENCOSTA EM ALGUMA BARREIRA (MOVIMENTACAO)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = true

	
# FUNCAO PARA IDENTIFICAR SE DESENCOSTA DE ALGUMA BARREIRA (MOVIMENTACAO)
# SOM DE DESACOPLAR
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('limites'):
		colidiu_com_limites = false
		pode_grudar = false
		$audio_desacoplar.play()
		desacoplou = true
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _on_Timer_grude_timeout():
	#nao_pode_grudar = false

#endregion

#region conexao
func conectar(veio_de_desativado: bool = false)->void:
	esta_desativado = false  #ESSENCIAL
	SPEED = estado_original
	timer.stop()
	$aviso_conexao.stop()
	som_desligar_ja_tocado = false
	if veio_de_desativado:
		$reestabelece_conexao.play()

func desconectar()-> void:
	SPEED = 0
	$aviso_conexao.stop()

func _on_timer_conexao_timeout() -> void:
	#animaçao de desativado
	esta_desativado = true
	animation.play("Desativado") #animação
	if not som_desligar_ja_tocado:
		$audio_desligar.play()
		som_desligar_ja_tocado = true
	desconectar()

func _on_zona_conexao_2_area_entered(area: Area2D) -> void:
	var eh_conector: bool = false
	if area.name == "zona_conexao_1":
		conectores[0] = true
		eh_conector = true
	if area.name == "zona_conexao_rot":
		conectores[1] = true
		eh_conector = true
	

	if (conectores[0] or conectores[1]) and eh_conector:
		conectar()

func _on_zona_conexao_2_area_exited(area: Area2D) -> void:
	if area.name == "zona_conexao_1":
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
	animation.play("Idle")
	
#endregion

#Animação 
func setAnimation(direction):
#Anim desativado
	if esta_desativado:
		if animation.animation != "Desativado":
			animation.play("Desativado")
		return  # Não continua se estiver desativado
		
#flip do sprite
	if direction > 0: animation.flip_h = false
	elif direction < 0: animation.flip_h = true
	
#Parede subindo e descendo
	if Input.is_action_pressed("ui_up_WASD"): animation.play("Parede Subindo")
	elif  Input.is_action_pressed("ui_down_WASD"): animation.play("Parede Descendo")
	elif  Input.is_action_pressed("ui_right_WASD"): animation.play("Corrida")
	else: animation.play("Idle")
	
