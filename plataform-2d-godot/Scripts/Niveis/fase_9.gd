extends Node2D

@onready var Botoes: Array = $Botoes.get_children()
@onready var plataformas_anim: Array = $Plataformas_espirradas/Animacoes_plataforma.get_children()
@onready var plantas_anim: Array = $Plataformas_espirradas/Animacoes_planta.get_children()
@onready var paredes_retrateis_anim: Array = $Paredes_retrateis/Animacoes.get_children()


func _process(delta: float) -> void:
	abrir_paredes()
	
func abrir_paredes():
	var i: int = 0
	for botao in Botoes:
		if botao.pode_ativar and Input.is_action_just_pressed("interagir"):
			paredes_retrateis_anim[i].play("Abrir")
			botao.is_untouched = false
			botao.emit_signal("ativar_oneshot")
		i+=1


func _on_trigger_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not plataformas_anim[0].is_playing() and not plantas_anim[0].is_playing():
		await get_tree().create_timer(0.5,false).timeout
		plataformas_anim[0].play("Ativar")
		plantas_anim[0].play("Ativar")


func _on_trigger_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not plataformas_anim[1].is_playing() and not plantas_anim[1].is_playing():
		await get_tree().create_timer(0.5,false).timeout
		plataformas_anim[1].play("Ativar")
		plantas_anim[1].play("Ativar")


func _on_trigger_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not plataformas_anim[2].is_playing() and not plantas_anim[2].is_playing():
		await get_tree().create_timer(0.5,false).timeout
		plataformas_anim[2].play("Ativar")
		plantas_anim[2].play("Ativar")


func _on_trigger_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not plataformas_anim[3].is_playing() and not plantas_anim[3].is_playing():
		await get_tree().create_timer(0.3,false).timeout
		plataformas_anim[3].play("Ativar")
		plantas_anim[3].play("Ativar")


func _on_trigger_5_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not plataformas_anim[4].is_playing() and not plantas_anim[4].is_playing():
		await get_tree().create_timer(0.3,false).timeout
		plataformas_anim[4].play("Ativar")
		plantas_anim[4].play("Ativar")


func _on_trigger_6_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not plataformas_anim[5].is_playing() and not plantas_anim[5].is_playing():
		await get_tree().create_timer(0.3,false).timeout
		plataformas_anim[5].play("Ativar")
		plantas_anim[5].play("Ativar")
