extends CharacterBody2D

@export var SPEED: int = 90
@onready var timer = $Timer_conexao
@onready var animation: AnimatedSprite2D = $"Animação"
@onready var animador_conexao: AnimationPlayer = $zona_conexao_2/Sprite2D/AnimationPlayer
@onready var raycast_chao = $RayCast2D_Centro
@onready var raycast_direita = $RayCast2D_direita
@onready var raycast_esquerda = $RayCast2D_esquerda 
@onready var raycast_esquerda_meio = $RayCast2D_esquerda_meio
@onready var raycast_direita_meio = $RayCast2D_direita_meio

var estado_original = SPEED
var _overlaping: Array = []
var colidiu_com_limites = false
var pode_grudar = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var desacoplou = false
var esta_desativado = false
var som_desligar_ja_tocado = false
var grudando: bool = false

func _ready() -> void:
	$zona_conexao_2.collision_layer = 3
	$zona_conexao_2.collision_mask = 3
	self.add_to_group("Players")

#region physics process
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left_WASD", "ui_right_WASD")
	
	#Grudar ativar e desativar
	if Input.is_action_just_pressed("toggle_grudar"):
		grudando = not grudando
		if grudando:
			print ("Modo GRUDAR Ativado")
		else:
			print ("Modo GRUDAR Desativado")
			# Restaurar gravidade e rotação quando desgrudar
			gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
			animation.rotation = 0
			animation.flip_v = false
	
	# SOM DE ANDAR
	if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_up_WASD") and is_on_floor() and not esta_desativado:
		if not $audio_andar.is_playing():
			$audio_andar.play()
	else:
		$audio_andar.stop()
	
	# SOM DE POUSO
	if colidiu_com_limites and is_on_floor():
		pode_grudar = true
		if desacoplou:
			$audio_pouso.play()
			desacoplou = false

	grudar(delta,direction)
	
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

func grudar(delta, direction)->void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not grudando:
		return
	#VERIFICA APOIO REAL MUdanca
	var em_chao = raycast_chao.is_colliding()
	var em_direita = raycast_direita.is_colliding()
	var em_esquerda = raycast_esquerda.is_colliding()
	var em_esquerda_meio = raycast_esquerda_meio.is_colliding()
	var em_direita_meio = raycast_direita_meio.is_colliding()

	#CONDICAO PARA DESLIGAR O MODO GRUDAR AUTOMATICAMENTE, NAO CONSEGUI FAZER
	#if not em_chao and not em_direita and not em_esquerda and not em_esquerda_meio and not em_direita_meio:
		#grudando = false
		#print("Desgrudado automaticamente por falta de apoio")
		#return
		
	if is_on_ceiling():
		animation.rotation = 0
		animation.flip_v = true
		
	if is_on_floor():
		animation.rotation = 0
		animation.flip_v = false
		
	if is_on_wall() and Input.is_action_pressed("ui_right_WASD") and pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		animation.rotation_degrees = -90
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
	
	if is_on_wall() and Input.is_action_pressed("ui_left_WASD") and pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		animation.rotation_degrees = 90
		#animation.flip_h = false
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
#endregion

#region conexao
func conectar(veio_de_desativado: bool = false)->void:
	esta_desativado = false  #ESSENCIAL
	SPEED = estado_original
	timer.stop()
	$aviso_conexao.stop()
	animador_conexao.play("Idle")
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
	if area.name == "zona_conexao_1" or area.name == "zona_conexao_rot":
		_overlaping.append(area)
		conectar(esta_desativado)
		

func _on_zona_conexao_2_area_exited(area: Area2D) -> void:
	_overlaping.erase(area)
	if _overlaping.is_empty():
		if timer.is_stopped(): 
			timer.start()
			$aviso_conexao.play()
			animador_conexao.play("desconectando")

func _on_game_controller_restart() -> void:
	self.remove_from_group("Players")

func _on_process_timer_timeout() -> void:
	self.add_to_group("Players")
#endregion

#region animacao
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
#endregion
