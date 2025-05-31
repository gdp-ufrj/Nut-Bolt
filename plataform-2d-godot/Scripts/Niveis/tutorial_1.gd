extends Node2D

@onready var animacao_plataforma = $"Plataforma movel/CollisionShape2D/AnimationPlayer"

func  _process(delta: float) -> void:
	if $Botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		animacao_plataforma.play("Subir")
		$Botao.is_untouched = false
		$Botao.emit_signal("ativar_oneshot")
