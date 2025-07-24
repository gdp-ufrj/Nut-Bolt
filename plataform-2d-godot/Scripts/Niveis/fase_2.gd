extends Node2D

@onready var botao1: Area2D = $Botoes/Botao1
@onready var botao2: Area2D = $Botoes/Botao2
@onready var botoes: Array = [botao1,botao2]

@onready var parede1: AnimationPlayer = $Paredes_Retrateis/PR1/AnimationPlayer
var fechada1: bool = true
@onready var parede2: AnimationPlayer = $Paredes_Retrateis/PR2/AnimationPlayer
var fechada2: bool = true
@onready var paredes: Array = [parede1, parede2]
var estados: Array = [fechada1,fechada2]

@onready var PE1: AnimationPlayer = $Plataformas_Espirro/PE1/AnimationPlayer
#@onready var PE1_area: Area2D = $Plataformas_Espirro/PE1/trigger1
@onready var PE2: AnimationPlayer = $Plataformas_Espirro/PE2/AnimationPlayer
@onready var PE3: AnimationPlayer = $Plataformas_Espirro/PE3/AnimationPlayer
@onready var plataformas: Array = [PE1,PE2,PE3]
#var restart: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	paredes_retrateis()
	#if Input.is_action_just_pressed("restart"):
		#restart = true
		#PE1.stop()

func paredes_retrateis()->void:
	var i: int = 0
	var current_time: float
	for botao in botoes:
		if botao.pode_ativar and Input.is_action_just_pressed("interagir"):
			botao.emit_signal("ativar")
			if estados[i]: 
				paredes[i].pause()
				paredes[i].play("Abrir")
			else: 
				paredes[i].pause()
				current_time = Time.get_ticks_usec() - paredes[i].get_animation("Abrir").get_length()
				paredes[i].play_section_backwards("Abrir",current_time)
			estados[i]= not estados[i]
		i+=1


func _on_trigger_1_body_entered(body: Node2D) -> void:
	if body.name == "player_2":
		await get_tree().create_timer(0.3,false).timeout
		if not PE1.is_playing():
			PE1.play("Ativar")


func _on_trigger_2_body_entered(body: Node2D) -> void:
	if body.name == "player_2":
		await get_tree().create_timer(0.3,false).timeout
		if not PE2.is_playing():
			PE2.play("Ativar")


func _on_trigger_3_body_entered(body: Node2D) -> void:
	if body.name == "player_2":
		await get_tree().create_timer(0.3,false).timeout
		if not PE3.is_playing():
			PE3.play("Ativar")
