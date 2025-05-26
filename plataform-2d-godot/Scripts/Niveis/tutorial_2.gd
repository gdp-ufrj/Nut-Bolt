extends Node2D

# VARIAVEIS PARA FUNCIONAMENTO DO BOTAO E DA PLATAFORMA
signal botao_ativado

func _process(_delta: float) -> void:
	if $Botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		$plataforma/AnimationPlayer.play("plataforma-tutorial2")
		$Botao/Label.visible = false
		botao_ativado.emit()
		$Botao/audio_interagir.play()

func _on_area_para_evitar_bug_body_entered(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		if $plataforma/AnimationPlayer.is_playing(): 
			$plataforma/AnimationPlayer.pause()
			$plataforma.position.y - 10

func _on_area_para_evitar_bug_body_exited(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		$plataforma/AnimationPlayer.play("plataforma-tutorial2")
