extends AnimatableBody2D
#
#var ativo = false
#
#func _ready():
	#connect("body_entered", _on_body_entered)
#
#func _on_body_entered(body):
	#if body.name == "pula":  # ou use body.is_in_group("player")
		#$AnimatedSprite2D.stop()  # ou $AnimationPlayer.stop()
#
#func _process(delta: float) -> void:
	#if ativo:
		#
