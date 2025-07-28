extends Area2D

@onready var animation: AnimatedSprite2D = $"Abre e fecha"

var players_in_area: Array = []
var ja_tocou = false
var animacao_terminou = false
var chamou_transicao = false


func _ready():
	var tipo_fase = get_tree().get_root().get_node("Game Controller").get_fase_tipo()
	
	match tipo_fase:
		"tutorial":
			animation.animation = "Abre e fecha"
		"floresta":
			animation.animation = "Abre e fecha floresta"

func _process(delta: float) -> void:
	if not chamou_transicao:
		if has_both_players() and animacao_terminou:
			get_tree().get_root().get_node("Game Controller").animacao_transicao()
			chamou_transicao = true

func _on_body_entered(body):
	if body.is_in_group("Players"):
		if not players_in_area.has(body):
			players_in_area.append(body)

		#Só toca a animação quando AMBOS estiverem presentes e ainda não tocou
		if has_both_players() and not ja_tocou:
			$"Abre e fecha".visible = true
			animation.play()
			$audio_abrindo.play()
			ja_tocou = true
			
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

func _on_abre_e_fecha_animation_finished() -> void:
	animacao_terminou = true


func _on_fase_final_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
