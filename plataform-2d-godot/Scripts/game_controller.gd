extends Node
signal restart

#Lista com os caminhos para os arquivos de cena dos niveis
var level_paths = [
	"res://Cenas/Niveis/fase_4.tscn",
	"res://Cenas/Niveis/tutorial_2.tscn",
	"res://Cenas/Niveis/tutorial_3.tscn",
	"res://Cenas/Niveis/fase_1.tscn",
	"res://Cenas/Niveis/fase_3.tscn",
	"res://Cenas/Niveis/fase_4.tscn"
]

var current_level: Node = null  #Referencia para o nivel atual
var current_index: int = -1     #Indice do nivel atual

@onready var player_1: CharacterBody2D = $Players/player_1 
@onready var player_2: CharacterBody2D = $Players/player_2 
@onready var conexao_players: Line2D = $conexao_players
@onready var pause_menu = $Pause_menu
@onready var music_player: AudioStreamPlayer2D = $SoundTrack_laboratorio

const music_tutorial = preload("res://Audio/Laboratorio_soundtrack/mus_laboratorio_loop.ogg")
const music_fases = preload("res://Audio/Floresta_soundtrack/mus_solarpunk_loop.ogg")

#Funcao chamada quando a cena começa a ser processada
func _ready():
	#Inicializa o indice do nivel atual e carrega o primeiro nivel
	current_index = 0
	_load_level(current_index)

#Funcao chamada sempre que uma acao de input não tratada acontece (como pressionar teclas)
func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			$Pause_menu.hide_pause_menu()
		else:
			$Pause_menu.show_pause_menu()
	elif Input.is_action_just_pressed("restart") and not get_tree().paused and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("fade_in")

# funcao chamada quando fade_in acaba e para animacao de troca de fase
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		restart_level()
		restart.emit()
		$AnimationPlayer.play("fade_out")
	if anim_name == "trocar_fase":
		go_to_next_level()
		$AnimationPlayer.play("fade_out")

func animacao_transicao():
	$AnimationPlayer.play("trocar_fase")

#Funcao para avancar para o proximo nivel
func go_to_next_level():
	#Verifica se ha um próximo nivel disponivel
	if current_index + 1 < level_paths.size():
		#Remove o nivel atual da cena antes de carregar o proximo
		if current_level:
			current_level.queue_free()
		current_index += 1  #Incrementa o indice para o próximo nivel
		_load_level(current_index)  #Carrega o próximo nivel
	else:
		#Se nao houver mais niveis, exibe mensagem de fim de jogo
		print("Fim do jogo!")


#Funcao para reiniciar o nivel atual (chamada quando o jogador aperta a tecla 'R')
func restart_level():
	#Se um nivel estiver carregado, libere a memoria (remove da cena) no proximo ciclo de frame
	if current_level:
		#Para garantir que o nivel sera removido na proxima interação de frame
		call_deferred("_remove_current_level")
		#Chama a funcao de carregamento apos um breve atraso para garantir que a remocao tenha ocorrido
		call_deferred("_load_level", current_index)

#Funcao para remover o nivel atual da cena de maneira segura
func _remove_current_level():
	if current_level:
		current_level.queue_free()

#Funcao para carregar um nivel baseado no indice
func _load_level(index: int):
	#Obtem o caminho da cena do nivel baseado no indice
	var level_path = level_paths[index]
	#Carrega a cena do nivel (arquivo .tscn)
	var level_scene = load(level_path)
	#Cria uma instancia do nivel carregado
	var level_instance = level_scene.instantiate()

	#Para adiar a adicao do nivel e evitar o erro de fisica
	call_deferred("_add_level_to_scene", level_instance)
	
	#O nivel sera adicionado no proximo ciclo, apos o processamento da fisica.
	current_level = level_instance  #Define o nível atual como o recem-carregado

	#Posiciona os jogadores nos pontos de spawn do novo nivel
	#Encontra os pontos de spawn para o player 1 e player 2 dentro da cena do nivel
	var spawn1 = current_level.get_node_or_null("player_1_spawn")
	var spawn2 = current_level.get_node_or_null("player_2_spawn")

	#Se ambos os pontos de spawn foram encontrados, posiciona os jogadores nessas posicoes
	if spawn1 and spawn2:
		print("Spawn player 1 em: ", spawn1.global_position)
		print("Spawn player 2 em: ", spawn2.global_position)
		player_1.global_position = spawn1.global_position
		player_2.global_position = spawn2.global_position
		conexao_players.global_position = spawn1.global_position
	else:
		#Caso nao encontre os pontos de spawn exibe um aviso
		push_warning("Pontos de spawn não encontrados no nível: " + level_path)
		
	#Controle da musica
	_update_music(index)

#Funcao para adicionar o nivel a cena, que sera chamada com call_deferred
func _add_level_to_scene(level_instance: Node):
	#Adiciona o nivel a arvore de nos
	add_child(level_instance)
	
func _update_music(index: int) -> void:
	if index <= 2:
		#Tutorial (fases 0,1,2)
		if music_player.stream != music_tutorial:
			music_player.stop()  # <- PARA a música atual
			music_player.stream = music_tutorial
			music_player.play()
	elif index >= 3:
		#Floresta (fases 3 em diante)
		if music_player.stream != music_fases:
			music_player.stop()  # <- PARA a música atual
			music_player.stream = music_fases
			music_player.play()
				

#funcao de update da animacao da porta
func get_fase_tipo() -> String:
	if current_index <= 2:
		return "tutorial"
	else:
		return "floresta"
