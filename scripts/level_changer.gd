extends Area2D

@export_file("*.tscn") var next_level: String = ""
@export var next_player_position: Vector2 = Vector2(0.0, 147.0)
@export var need_interaction: bool = true

# Referência para o nó de texto
@onready var interaction_label: Label = $Label

# Variável para controlar se o jogador está dentro da área
var jogador_on_area: bool = false
# Guardará a referência do Tween de flutuação
var float_tween: Tween

func _ready() -> void:
	# Garante que a mensagem comece escondida ao iniciar o jogo
	interaction_label.visible = false
	
	# Inicia a animação de flutuar
	start_floating_animation()

# Quando o jogador entra na área
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		jogador_on_area = true
		
		if not need_interaction:
			transport()
		else:
			interaction_label.visible = true

# Quando o jogador sai da área
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		jogador_on_area = false
		interaction_label.visible = false

# O Godot roda esta função automaticamente sempre que qualquer tecla é pressionada
func _unhandled_input(event: InputEvent) -> void:
	if need_interaction and jogador_on_area and event.is_action_pressed("interect"):
		get_viewport().set_input_as_handled()
		transport()

# Função que cria o efeito de subir e descer
func start_floating_animation() -> void:
	var original_y = interaction_label.position.y
	
	# Mudamos para 1.0. O movimento total na tela será de exatamente 1 pixel.
	var amplitude = 1.0 
	# Aumentamos o tempo para 0.8 ou 1.0 para tornar a transição de 1 pixel bem calma
	var duration = 0.3

	float_tween = create_tween().set_loops()
	
	# 1. Sobe 1 pixel a partir da posição original
	float_tween.tween_property(interaction_label, "position:y", original_y - amplitude, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	# 2. Retorna para a posição original (em vez de descer mais)
	float_tween.tween_property(interaction_label, "position:y", original_y, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

# Lógica do teleporte
func transport() -> void:
	Globals.next_player_position = next_player_position
	Globals.should_position = true
	call_deferred("load_next_scene")

func load_next_scene() -> void:
	if next_level != "":
		get_tree().change_scene_to_file(next_level)
	else:
		push_warning("Aviso: 'next_level' não foi definido nesta Area2D!")
