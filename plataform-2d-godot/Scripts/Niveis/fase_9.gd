extends Node2D

@onready var Botoes: Array = $Botoes.get_children()
@onready var plats_anim: Array = $Plataformas_espirradas/Animacoes.get_children()
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
	if body.is_in_group("Players"):
		await get_tree().create_timer(0.3,false).timeout
		plats_anim[0].play("Ativar")


func _on_trigger_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		await get_tree().create_timer(0.3,false).timeout
		plats_anim[1].play("Ativar")


func _on_trigger_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		await get_tree().create_timer(0.3,false).timeout
		plats_anim[2].play("Ativar")


func _on_trigger_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		await get_tree().create_timer(0.3,false).timeout
		plats_anim[3].play("Ativar")


func _on_trigger_5_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		await get_tree().create_timer(0.3,false).timeout
		plats_anim[4].play("Ativar")


func _on_trigger_6_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		await get_tree().create_timer(0.3,false).timeout
		plats_anim[5].play("Ativar")
