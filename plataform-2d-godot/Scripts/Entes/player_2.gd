extends CharacterBody2D

@onready var animation = $Animacao_player_2
@onready var conexao = $Conexao_player_2

@export var SPEED: int = 90
@onready var raycast_chao = $RayCast2D_Centro
@onready var raycast_direita = $RayCast2D_direita
@onready var raycast_esquerda = $RayCast2D_esquerda
@onready var raycast_esquerda_meio = $RayCast2D_esquerda_meio
@onready var raycast_direita_meio = $RayCast2D_direita_meio

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
	conexao.conectar()

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
			$"Animação".rotation = 0
			$"Animação".flip_v = false
	
	# SOM DE ANDAR
	if Input.is_action_pressed("ui_left_WASD") or Input.is_action_pressed("ui_right_WASD") or Input.is_action_pressed("ui_up_WASD") and is_on_floor() and not esta_desativado:
		if not $audio_andar.is_playing():
			$audio_andar.play()
	else:
		$audio_andar.stop()
	
	if esta_desativado:
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
		
	animation.setAnimation(direction, esta_desativado)
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
		$"Animação".rotation = 0
		$"Animação".flip_v = true
		
	if is_on_floor():
		$"Animação".rotation = 0
		$"Animação".flip_v = false
		
	if is_on_wall() and Input.is_action_pressed("ui_right_WASD") and pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		$"Animação".rotation_degrees = -90
		if(Input.is_action_pressed("ui_up_WASD")):
			velocity.x = direction * SPEED
			velocity.y = -gravity * delta * 5
	
	if is_on_wall() and Input.is_action_pressed("ui_left_WASD") and pode_grudar:
		velocity.x = direction * SPEED
		velocity.y = gravity * delta * 4
		$"Animação".rotation_degrees = 90
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
