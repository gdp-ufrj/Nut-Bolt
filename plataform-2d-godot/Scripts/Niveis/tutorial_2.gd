extends Node2D

func _process(_delta: float) -> void:
	if $Botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		$plataforma/AnimationPlayer.play("plataforma-tutorial2")
		$Botao.emit_signal("ativar_oneshot")

func _on_area_para_evitar_bug_body_entered(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		if $plataforma/AnimationPlayer.is_playing(): 
			$plataforma/AnimationPlayer.pause()
			$plataforma.position.y - 10

func _on_area_para_evitar_bug_body_exited(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		$plataforma/AnimationPlayer.play("plataforma-tutorial2")

#Dialogic

func _ready():
	#Espera o Dialogic estar pronto
	await get_tree().process_frame

	if Dialogic.current_timeline == null:
		Dialogic.start("Na que aparece o repetidor")

func _input(event: InputEvent):
#ve se o dialogic esta rodando
	if Dialogic.current_timeline != null:
		return
