extends Area2D
var is_untouched: bool = true 
var pode_ativar: bool = false
var ligado = false
signal ativar
signal ativar_oneshot

func _ready():
	$AnimatedSprite2D.play("b_inicial")

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
	if ligado: $AnimatedSprite2D.play("b_desligar")
	else: $AnimatedSprite2D.play("b_ligar")
	ligado = not ligado

func _on_ativar_oneshot() -> void:
	is_untouched = false
	$audio_interagir.play()
	$Label.hide()
	$AnimatedSprite2D.play("b_ligar")
