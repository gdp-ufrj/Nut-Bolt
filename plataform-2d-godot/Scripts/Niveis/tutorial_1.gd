extends Node2D

@onready var animacao_plataforma = $"Plataforma movel/CollisionShape2D/AnimationPlayer"
@onready var fadein = get_parent().get_node("AnimationPlayer")


func  _process(delta: float) -> void:
	if $Botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		animacao_plataforma.play("Subir")
		$Botao.is_untouched = false
		$Botao.emit_signal("ativar_oneshot")

#reinicio de fase ao cair (void)
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entrou:", body.name)
	if body.is_in_group("Players"):
		print(body.name, "está no grupo Players")
		if not fadein.is_playing():
			fadein.play("fade_in")


#Dialogic
func _ready():
	# Espera o Dialogic estar pronto
	await get_tree().process_frame

	#permite que o Dialogic funcione mesmo se o jogo estiver pausado
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if Dialogic.current_timeline == null:
		Dialogic.start("Antes de começar a fase 1")


func _input(event: InputEvent):
#ve se o dialogic esta rodando
	if Dialogic.current_timeline != null:
		return
