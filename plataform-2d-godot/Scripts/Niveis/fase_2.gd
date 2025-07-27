extends Node2D

@onready var botoes: Array = $Botoes.get_children()
var fechada1: bool = true
var fechada2: bool = true
@onready var paredes_anim: Array = $Paredes_Retrateis/Animacoes.get_children()
var estados: Array = [fechada1,fechada2]
@onready var plataformas_anim: Array = $Plataformas_Espirro/Animacoes/plataformas.get_children()
@onready var plantas_anim: Array = $Plataformas_Espirro/Animacoes/plantas.get_children()


func _process(delta: float) -> void:
	paredes_retrateis()

func paredes_retrateis()->void:
	var i: int = 0
	var current_time: float
	for botao in botoes:
		if botao.pode_ativar and Input.is_action_just_pressed("interagir"):
			botao.emit_signal("ativar")
			if estados[i]: 
				paredes_anim[i].pause()
				paredes_anim[i].play("Abrir")
			else: 
				paredes_anim[i].pause()
				current_time = Time.get_ticks_usec() - paredes_anim[i].get_animation("Abrir").get_length()
				paredes_anim[i].play_section_backwards("Abrir",current_time)
			estados[i]= not estados[i]
		i+=1


func _on_trigger_1_body_entered(body: Node2D) -> void:
	if body.name == "player_2" and not plataformas_anim[0].is_playing() and not plantas_anim[0].is_playing():
		await get_tree().create_timer(0.5,false).timeout
		plataformas_anim[0].play("Ativar")
		plantas_anim[0].play("Ativar")


func _on_trigger_2_body_entered(body: Node2D) -> void:
	if body.name == "player_2" and not plataformas_anim[1].is_playing() and not plantas_anim[1].is_playing():
		await get_tree().create_timer(0.5,false).timeout
		plataformas_anim[1].play("Ativar")
		plantas_anim[1].play("Ativar")


func _on_trigger_3_body_entered(body: Node2D) -> void:
	if body.name == "player_2" and not plataformas_anim[2].is_playing() and not plantas_anim[2].is_playing():
		await get_tree().create_timer(0.5,false).timeout
		plataformas_anim[2].play("Ativar")
		plantas_anim[2].play("Ativar")
