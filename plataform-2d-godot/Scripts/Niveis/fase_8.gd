extends Node2D

@onready var botoes: Array = $botoes.get_children()
@onready var paredes_retrateis_anim: Array = $Paredes_retrateis/Animacoes.get_children()
enum Pisos{
	PISO0,
	PISO1,
	PISO2
	}
var piso = Pisos.PISO0
@onready var plataformas_anim: Array = $Plataformas_espirradas/Animacoes/plataformas.get_children()
@onready var plantas_anim: Array = $Plataformas_espirradas/Animacoes/plantas.get_children()

func _ready() -> void:
	botoes[1].set_process_mode(botoes[0].PROCESS_MODE_DISABLED)

func _process(delta: float) -> void:
	paredes_retrateis()

func paredes_retrateis()-> void:
	if botoes[0].pode_ativar and Input.is_action_just_pressed("interagir") and piso == Pisos.PISO0:
		botoes[0].emit_signal("ativar")
		paredes_retrateis_anim[0].play("Subir1")
		botoes[1].set_process_mode(botoes[0].PROCESS_MODE_ALWAYS)
		
	else: 
		if botoes[1].pode_ativar and Input.is_action_just_pressed("interagir"):
			paredes_retrateis_anim[0].play("Subir2")
			botoes[1].is_untouched = false
			botoes[1].emit_signal("ativar_oneshot")
		else: 
			if botoes[2].pode_ativar and Input.is_action_just_pressed("interagir"):
				paredes_retrateis_anim[1].play("Abrir")
				botoes[2].is_untouched = false
				botoes[2].emit_signal("ativar_oneshot")

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
