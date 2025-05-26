extends CanvasLayer

#Referencia ao painel que contem o menu de pausa
@onready var panel = $Panel

#Funcao chamada quando o menu de pausa e ativado
func _ready():
	panel.visible = false #Inicialmente, o menu de pausa esta invisivel


#Funcao para mostrar o menu de pausa
func show_pause_menu():
	panel.visible = true  #Torna o painel visivel, mostrando o menu de pausa
	get_tree().paused = true #Pausa o jogo, bloqueando a execucao dos processos e fisica

#Funcao para esconder o menu de pausa
func hide_pause_menu():
	#Torna o painel invisivel, escondendo o menu de pausa
	panel.visible = false
	#Despausa o jogo, permitindo que a execucao e a fisica continuem normalmente
	get_tree().paused = false 

#Função chamada quando o botao "Continuar" e pressionado
func _on_continuar_pressed() -> void:
	hide_pause_menu() #Chama a funcao para esconder o menu de pausa

#Funcao chamada quando o botao "Sair" é pressionado
func _on_quit_pressed() -> void:
	get_tree().paused = false # Despausa o jogo
	#Muda para a cena principal (menu), carregando a cena de menu
	get_tree().change_scene_to_file("res://Cenas/UI/menu.tscn")

#botão de Opções ainda ainda não completado
func _on_opções_pressed() -> void:
	pass # Replace with function body.
