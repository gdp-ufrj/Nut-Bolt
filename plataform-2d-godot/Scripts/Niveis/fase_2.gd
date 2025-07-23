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

@onready var plat_spit1: AnimationPlayer = $Plataformas_spit/PS1/Animation1
@onready var PS1_area: Area2D= $Plataformas_spit/PS1/TriggerArea1
@onready var plat_spit2: AnimationPlayer = $Plataformas_spit/PS2/Animation2
@onready var plat_spit3: AnimationPlayer = $Plataformas_spit/PS3/Animation3
@onready var plataformas: Array = [plat_spit1,plat_spit2,plat_spit3]
var restart = false

func _process(_delta: float) -> void:
	paredes_retrateis()
	if Input.is_action_just_pressed("restart"):
		restart = true
		
#func _ready() -> void:
	#print("Cena pronta")
	#ready.emit()
	

func paredes_retrateis()->void:
	var i: int = 0
	for botao in botoes:
		if botao.pode_ativar and Input.is_action_just_pressed("interagir"):
			botao.emit_signal("ativar")
			if estados[i]: 
				paredes[i].stop(true)
				paredes[i].play("Abrir")
			else: 
				paredes[i].stop(true)
				paredes[i].play("Fechar")
			estados[i]= not estados[i]
		i+=1


func _on_trigger_area_1_body_entered(body: Node2D) -> void:
	if not plat_spit1.is_playing():
		if body.is_in_group("Players"):
			plat_spit1.play("Ativar")

	

func _on_trigger_area_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		plat_spit2.play("Ativar")


func _on_trigger_area_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		plat_spit3.play("Ativar")
