extends Area2D

@export var tela_prateleira : PackedScene

@onready var label: Label = $Label
@export var id_prateleira = "A-01"
@export var categoria = "EPI"
@export var produtos : Array[String]

var jogador_perto := false

func _ready() -> void:
	label.visible = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		jogador_perto = true
		label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		jogador_perto = false
		label.visible = false
		
func _unhandled_input(event: InputEvent) -> void:
	if jogador_perto and Input.is_action_just_pressed("interect"):
		var tela = tela_prateleira.instantiate()
		
		get_tree().current_scene.add_child(tela)
