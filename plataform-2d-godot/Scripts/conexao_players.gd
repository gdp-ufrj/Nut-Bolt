extends Line2D

@onready var path_p1 = "/root/Game Controller/Players/player_1"
@onready var path_p2 = "/root/Game Controller/Players/player_2"

var p1 :Node2D
var p2 :Node2D
var max_dist = 159
var fade_start = max_dist * 0.7

func _ready() -> void:
	points = [ Vector2.ZERO, Vector2.ZERO ]

func _process(delta: float) -> void:
	
	#Espera os players carregarem na cena
	if not p1 or p2:
		if has_node(path_p1) and has_node(path_p2):
			p1 = get_node(path_p1)
			p2 = get_node(path_p2)
		else:
			return 
	
	if p1 and p2 :
		#Acha a distância entre os robôs
		var dist = p1.global_position.distance_to(p2.global_position)
		
		if dist <= max_dist:
			#posiciona um ponto em cada player
			points[0] = to_local(p1.global_position)
			points[1] = to_local(p2.global_position)
			
			#muda a transparência e largura de acordo com a distância
			var alfadist = remap(dist,fade_start,max_dist,1,0.5)
			modulate = Color(1,1,1,alfadist)
			width = remap(dist,40,max_dist,10,8)
			
		else:
			#posiciona os dois pontos no 0,0 evitando que a linha renderize
			points = [ Vector2.ZERO, Vector2.ZERO ]
