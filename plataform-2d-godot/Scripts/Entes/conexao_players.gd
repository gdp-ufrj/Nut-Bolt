extends Line2D

@onready var p1 : CharacterBody2D = get_node("/root/Game Controller/Players/player_1")
@onready var p2 : CharacterBody2D = get_node("/root/Game Controller/Players/player_2")
@onready var max_dist = p1.get_child(2).get_child(0).shape.radius + p2.get_child(2).get_child(0).shape.radius
@onready var fade_start = max_dist * 0.7

func _ready() -> void:
	points = [Vector2.ZERO, Vector2.ZERO]

func _process(_delta: float) -> void:
	## Garante que os jogadores existam
	#if not p1 or not p2:
		##print("Tentando localizar jogadores...")
		#var p1_path = "/root/Game Controller/Players/player_1"
		#var p2_path = "/root/Game Controller/Players/player_2"
		#
		#if has_node(p1_path) and has_node(p2_path):
			##print("Encontrado:", p1_path)
			##print("Encontrado:", p2_path)
			#p1 = get_node(p1_path)
			#p2 = get_node(p2_path)
		#else:
			#return

	# Se ambos existem, continua
	if p1 and p2:
		var pos1 = p1.global_position
		var pos2 = p2.global_position
		var dist = pos1.distance_to(pos2)
		
		if dist <= max_dist:
			# Converte as posições para o espaço local da Line2D
			global_position = (pos1 + pos2) * 0.5  # Centraliza a linha entre os dois jogadores
			points[0] = to_local(pos1)
			points[1] = to_local(pos2)

			# Efeitos visuais
			var alfadist = remap(dist, fade_start, max_dist, 1.0, 0.4)
			modulate = Color(1, 1, 1, clamp(alfadist, 0.0, 1.0))
			width = remap(dist, 40, max_dist, 12, 6)
		else:
			# Oculta a linha
			points = [Vector2.ZERO, Vector2.ZERO]
			modulate.a = 0.0
