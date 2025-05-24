extends Area2D

@onready var animation: AnimatedSprite2D = $"Abre e fecha"

var players_in_area: Array = []
var ja_tocou = false

func _on_body_entered(body):
	if body.name == "player_1" or body.name == "player_2":
		
		#animação
		if not ja_tocou:
			$"Abre e fecha".visible = true
			animation.play("Abre e fecha")
			$audio_abrindo.play()
		if not players_in_area.has(body):
			players_in_area.append(body)
		ja_tocou = true

	if has_both_players():
		get_tree().get_root().get_node("Game Controller").go_to_next_level()
		

func _on_body_exited(body):
	if players_in_area.has(body):
		players_in_area.erase(body)

func has_both_players() -> bool:
	var has_player1 = false
	var has_player2 = false

	for player in players_in_area:
		if player.name == "player_1":
			has_player1 = true
		elif player.name == "player_2":
			has_player2 = true

	return has_player1 and has_player2
