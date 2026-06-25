# MapLocation.gd
extends Area2D

# Exporta uma variável para você definir no Inspetor do Godot (ex: "Entrance", "Warehouse")
@export var location_id: String = ""

var is_player_here: bool = false

func _ready() -> void:
	# Conecta os sinais de entrada e saída do pino do jogador
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPin": # Certifique-se de que o pino do jogador seja um CharacterBody2D ou Area2D
		is_player_here = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPin":
		is_player_here = false

func _process(_delta: float) -> void:
	# Se o jogador estiver em cima deste ponto e apertar o botão de aceitar (UI Accept / Enter / Espaço)
	if is_player_here and Input.is_action_just_pressed("ui_accept"):
		enter_level()

func enter_level() -> void:
	# Verifica se esse ponto tem uma cena correspondente no ProgressManager
	if ProgressManager.SCENE_ROUTER.has(location_id):
		var scene_path: String = ProgressManager.SCENE_ROUTER[location_id]
		
		# Salva que esta é a área atual antes de mudar de cena
		ProgressManager.current_area = location_id
		
		# Muda a cena do jogo para o arquivo .tscn da fase correspondente
		get_tree().change_scene_to_file(scene_path)
