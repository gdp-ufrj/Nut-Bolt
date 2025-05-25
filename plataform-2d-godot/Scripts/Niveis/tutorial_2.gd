extends Node2D

# VARIAVEIS PARA FUNCIONAMENTO DO BOTAO E DA PLATAFORMA
@onready var botao = $Botao
signal botao_ativado

func _process(_delta: float) -> void:
	if botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		$plataforma/AnimationPlayer.play("move")
		$Botao/Label.visible = false
		botao_ativado.emit()

func _on_area_para_evitar_bug_body_entered(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		if $plataforma/AnimationPlayer.is_playing(): 
			$plataforma/AnimationPlayer.pause()
			$plataforma.position.y - 10

func _on_area_para_evitar_bug_body_exited(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		$plataforma/AnimationPlayer.play("move")
