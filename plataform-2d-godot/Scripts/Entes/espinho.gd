extends Node2D

@onready var fadein = get_parent().get_parent().get_node("AnimationPlayer")

func _on_area_2d_area_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		if not fadein.is_playing():
			fadein.play("fade_in")
