# npc_interactive.gd
extends "res://scripts/npc.gd"
class_name NpcInteractive

@export var dialog_data: Array[Dictionary] = []
@export var faceset_path: String = ""

@onready var _area: Area2D = $rea2D

var _player_nearby: bool = false

func _ready() -> void:
	super._ready()  # chama o _ready do npc_base
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if not _player_nearby:
		return
	
	if Input.is_action_just_pressed("interect"):
		DialogManager.start_dialog(dialog_data, faceset_path)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = false
