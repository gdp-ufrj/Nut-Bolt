extends Line2D

@onready var p2 : CharacterBody2D = get_node("/root/Game Controller/Players/player_2")
@onready var roteador : Node2D = self.get_parent()
@onready var max_dist = p2.get_child(3).get_child(0).shape.radius + roteador.get_child(1).get_child(0).shape.radius 
@onready var fade_start = max_dist * 0.7

func _ready() -> void:
	points = [ Vector2.ZERO,Vector2.ZERO ]

func _process(_delta: float) -> void:
	
	#if not p2:
		#var possible_path = "/root/Game Controller/Players/player_2"
		#if has_node(possible_path):
			#p2 = get_node(possible_path)
		#else:
			#return 
	
	if p2:
		#Acha a distância até o player 2
		var rot = global_position
		var dist = rot.distance_to(p2.global_position)
		
		if dist <= max_dist:
			#posiciona o outro ponto da linha no player 2
			points[1] = to_local(p2.global_position)
			
			#muda a transparência e largura de acordo com a distância
			var alfadist = remap(dist,fade_start,max_dist,1,0.5)
			modulate = Color(1,1,1,alfadist)
			width = remap(dist,40,max_dist,10,8)
			
		else:
			#posiciona os dois pontos no 0,0 evitando que a linha renderize
			points[1] = Vector2.ZERO
