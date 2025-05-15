extends Node2D

# VARIAVEIS PARA FUNCIONAMENTO DO BOTAO E DA PLATAFORMA
var pode_interagir: bool = false
var jogador: Node2D = null
var botao_foi_ativado = false

func _process(_delta: float) -> void:
	if pode_interagir and Input.is_action_just_pressed("interagir"):
		print("interagiu")
		$plataforma/AnimationPlayer.play("move")
		$Botao/Label.visible = false
		botao_foi_ativado = true
 

# SCRIPT PRO BOTAO E PLATAFORMA
func _on_botao_body_entered(body: Node2D) -> void:
	if body.name == "player_2" and not botao_foi_ativado:
		$Botao/Label.visible = true
		pode_interagir = true
		jogador = body

# SCRIPT PRO BOTAO E PLATAFORMA
func _on_botao_body_exited(body: Node2D) -> void:
	if body.name == "player_2":
		$Botao/Label.visible = false
		pode_interagir = false
		jogador == null

func _on_area_para_evitar_bug_body_entered(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		if $plataforma/AnimationPlayer.is_playing(): 
			$plataforma/AnimationPlayer.pause()
			$plataforma.position.y - 10

func _on_area_para_evitar_bug_body_exited(body: Node2D) -> void:
	if body.name == "player_2" or body.name == "player_1":
		$plataforma/AnimationPlayer.play("move")
