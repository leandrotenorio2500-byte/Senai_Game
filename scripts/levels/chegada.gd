extends Node2D
class_name Chegada

const _DIALOG_SCREEN: PackedScene = preload("res://entities/dialog_screen.tscn")

var robson_faceset = "res://sprites/npcs/npc3_dialog.png"
var _robson_dialog_data: Dictionary = {
	0: {
		"faceset": robson_faceset,
		"dialog": "Opa, tudo bem? Rapaz, deixa eu te perguntar uma coisa...",
		"title": "Robson"
	},
	1: {
		"faceset": robson_faceset,
		"dialog": "Você por acaso é o novo Jovem Aprendiz que estava para chegar hoje?",
		"title": "Robson"
	},
	2: {
		"faceset": robson_faceset,
		"dialog": "Ah, que massa! Cara, fico feliz demais da vida quando ver a garotada tendo oportunidades assim logo cedo.",
		"title": "Robson"
	},
	3: {
		"faceset": robson_faceset,
		"dialog": "O mercado de trabalho precisa muito disso, e começar com o pé direito num lugar legal faz toda a diferença.",
		"title": "Robson"
	},
	4: {
		"faceset": robson_faceset,
		"dialog": "Seja muito bem-vindo, viu? Aproveite bastante. Se precisar de qualquer ajuda para se situar por aqui, é só me gritar!",
		"title": "Robson"
	}
}

@onready var _hud: CanvasLayer = $HUD
@onready var _interaction_area: Area2D = $NpcsInteractive/NpcInteractive/Area2D

var _player_nearby: bool = false

func _ready() -> void:
	_interaction_area.body_entered.connect(_on_body_entered)
	_interaction_area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if not _player_nearby:
		return

	if Input.is_action_just_pressed("interect"):
		if _hud.get_child_count() > 0:
			return
		
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _robson_dialog_data
		
		_hud.add_child(_new_dialog)
		_new_dialog.start_dialog()

func _on_body_entered(body: Node2D) -> void:
	# print("corpo entrou: ", body.name, " | grupos: ", body.get_groups())
	if body.is_in_group("Player"):
		_player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = false
