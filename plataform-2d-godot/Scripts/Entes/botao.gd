extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var is_untouched: bool = true 
var pode_ativar: bool = false
var ligado = false
signal ativar
signal ativar_oneshot

var prefixo_anim := "b"  #Vai virar "b" (tutorial) ou "b2" (floresta)

func _ready():
	var tipo_fase = get_tree().get_root().get_node("Game Controller").get_fase_tipo()

	match tipo_fase:
		"tutorial":
			prefixo_anim = "b"
		"floresta":
			prefixo_anim = "b2"

	#Garante que o botão comece com a aparência de inicial
	animation.play(prefixo_anim + "_inicial")
	ligado = false

func _on_body_entered(body: Node2D) -> void:
	if is_untouched and body.is_in_group("Players"):
		$Label.show()
		self.pode_ativar = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		$Label.hide()
		self.pode_ativar = false

func _on_ativar() -> void:
	$audio_interagir.play()
	$Label.hide()

	if ligado:
		animation.play(prefixo_anim + "_desligar")
	else:
		animation.play(prefixo_anim + "_ligar")

	ligado = not ligado

func _on_ativar_oneshot() -> void:
	is_untouched = false
	$audio_interagir.play()
	$Label.hide()
	animation.play(prefixo_anim + "_ligar")
