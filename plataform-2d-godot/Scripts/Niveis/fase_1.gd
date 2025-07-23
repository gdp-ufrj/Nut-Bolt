extends Node2D

@onready var botao1: Area2D = $Botoes/Botao1
@onready var botao2: Area2D = $Botoes/Botao2
@onready var botao3: Area2D = $Botoes/Botao3
@onready var botao4: Area2D = $Botoes/Botao4
@onready var botao5: Area2D = $Botoes/Botao5
@onready var botoes: Array = [botao1,botao2,botao3,botao4,botao5]

@onready var parede1: AnimationPlayer = $Paredes_Retrateis/PR1/AnimationPlayer
@onready var parede2: AnimationPlayer = $Paredes_Retrateis/PR2/AnimationPlayer
@onready var parede3: AnimationPlayer = $Paredes_Retrateis/PR3/AnimationPlayer
@onready var parede4: AnimationPlayer = $Paredes_Retrateis/PR4/AnimationPlayer
@onready var parede5: AnimationPlayer = $Paredes_Retrateis/PR5/AnimationPlayer
@onready var paredes: Array = [parede1,parede2,parede3,parede4,parede5]


func _process(delta: float) -> void:
	var i: int = 0
	for botao in botoes:
		if botao.pode_ativar and Input.is_action_just_pressed("interagir"):
			paredes[i].play("Abrir")
			botao.is_untouched = false
			botao.emit_signal("ativar_oneshot")
		i+=1
