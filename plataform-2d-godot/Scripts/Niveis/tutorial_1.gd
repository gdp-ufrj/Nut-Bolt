extends Node2D

@onready var animacao_plataforma = $"Plataforma movel/CollisionShape2D/AnimationPlayer"

func  _process(delta: float) -> void:
	if $Botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		animacao_plataforma.play("Subir")
		$Botao.is_untouched = false
		$Botao.emit_signal("ativar_oneshot")

#reinicio de fase ao cair (void)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		get_tree().reload_current_scene()
	pass # Replace with function body.
