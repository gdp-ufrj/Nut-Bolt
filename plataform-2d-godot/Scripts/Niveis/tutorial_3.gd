extends Node2D

var pode_interagir: bool = false
@onready var ativavel = $plataforma_ativavel/CollisionShape2D
@onready var estatica_1 = $"Plataformas Estaticas/estatica_1/CollisionShape2D"
@onready var estatica_2 = $"Plataformas Estaticas/estatica_2/CollisionShape2D"
@onready var estatica_3 = $"Plataformas Estaticas/estatica_3/CollisionShape2D"
@onready var estatica_4 = $"Plataformas Estaticas/estatica_4/CollisionShape2D"
@onready var plataformas_estaticas: Array = [self.estatica_1,self.estatica_2, self.estatica_3, self.estatica_4]
@onready var fadein = get_parent().get_node("AnimationPlayer")

func _ready() -> void:
	estado_inicial_plataformas()
	#Dialogic
	#Espera o Dialogic estar pronto
	await get_tree().process_frame

	if Dialogic.current_timeline == null:
		Dialogic.start("Antes da ultima fase do tutorial")

func _input(event: InputEvent):
#ve se o dialogic esta rodando
	if Dialogic.current_timeline != null:
		return
	
	
	
func _process(_delta: float) -> void:
	if $Botao.pode_ativar and Input.is_action_just_pressed("interagir"):
		inverte_estado()
		$Botao/audio_interagir.play()
		$Botao.emit_signal("ativar")

func estado_inicial_plataformas()->void:
	ativavel.disabled = true
	ativavel.visible = false
	for estatica in plataformas_estaticas:
		estatica.disabled = false
		estatica.visible = true

func inverte_estado()->void:
	ativavel.disabled = not ativavel.disabled
	ativavel.visible = not ativavel.visible
	for e in plataformas_estaticas:
		e.disabled = not e.disabled
		e.visible = not e.visible


#reinicio de fase ao cair (void)
#Consertado, volta ao nivel certo
func _on_void_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		if not fadein.is_playing():
			fadein.play("fade_in")
			await fadein.animation_finished
			get_tree().get_root().get_node("Game Controller").restart_level()

		
