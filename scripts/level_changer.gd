extends Area2D

@export var next_level: String = ""
@export var next_player_position_x: float = 0.0
@export var next_player_position_y: float = 147.0
@export var need_interaction: bool = true

# Variável para controlar se o jogador está dentro da área
var jogador_on_area: bool = false

# Quando o jogador entra na área
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player": # Garante que é o jogador
		jogador_on_area = true
		
		if not need_interaction:
			transport()

# Quando o jogador sai da área
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		jogador_on_area = false

# O Godot roda esta função automaticamente sempre que qualquer tecla é pressionada
func _unhandled_input(event: InputEvent) -> void:
	# Só checa o botão se a variável "precisa_interagir" for verdadeira
	if need_interaction and jogador_on_area and event.is_action_pressed("interect"):
		transport()
		
# Isolamos a lógica do teleporte em uma função própria para não repetir código
func transport() -> void:
	Globals.next_player_position = Vector2(next_player_position_x, next_player_position_y)
	Globals.should_position = true
	call_deferred("load_next_scene")

func load_next_scene() -> void:
	get_tree().change_scene_to_file("res://scene/" + next_level + ".tscn")
