extends Area2D

@export var next_scene = ""

var player1_in_area := false
var player2_in_area := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player1"):
		player1_in_area = true
	elif body.is_in_group("Player2"):
		player2_in_area = true
	
	_check_players()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player1"):
		player1_in_area = false
	elif body.is_in_group("Player2"):
		player2_in_area = false
	
func _check_players() -> void:
	if player1_in_area and player2_in_area:
		get_tree().change_scene_to_file(next_scene)
