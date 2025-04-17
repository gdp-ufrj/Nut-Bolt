extends CharacterBody2D


#Cemitério de Código
#const SPEED = 300.0
#const JUMP_VELOCITY = -400
#signal sem_sinal
#var game_over = false  # Variável para impedir múltiplos prints
#funcao que determina a distancia dos players
	#if other_character:
		##calcula a distancia do player 1 ao 2
		#var distance = global_position.distance_to(other_character.global_position)
		#if distance > DISTANCE and not game_over:
			#game_over = true
			#print("YOU RE DIE")

@export var SPEED: int = 300
@export var JUMP_VELOCITY: int = -400
@export var MAX_DISTANCE: int = 100
@export var other_character: Node2D 
@export var conectado: bool = true

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
	is_conectado([other_character]) #aqui entram novos conectores
	
	#Reinicia a fase ao pressionar R
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

 
func is_conectado(conectores: Array):
	##Checa se existe conexão ativa e age de acordo
	var distancia
	for objeto in conectores:
		if objeto != null:
			distancia =  self.global_position.distance_to(objeto.global_position)
			if distancia > MAX_DISTANCE:
				if $Timer_sem_sinal.is_stopped(): #se o timer não já estiver ativo
					$Timer_sem_sinal.start()
			else:
				$Timer_sem_sinal.stop()


	
func _on_timer_sem_sinal_timeout() -> void:
	self.SPEED = 0
	self.JUMP_VELOCITY = 0
	other_character.SPEED = 0
	conectado = false
	
	
	
