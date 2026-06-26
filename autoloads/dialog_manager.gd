extends Node

signal dialog_ended

const _DIALOG_SCREEN: PackedScene = preload("res://entities/dialog_screen.tscn")

var _player: CharacterBody2D = null
var _hud: CanvasLayer = null

func register_player(player: CharacterBody2D) -> void:
	_player = player

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud

func start_dialog(dialog_data: Array[Dictionary]) -> void:
	if _hud == null or _hud.get_child_count() > 0:
		return

	var dialog_dict: Dictionary = {}
	for i in dialog_data.size():
		dialog_dict[i] = {
			"title": dialog_data[i]["title"],
			"dialog": dialog_data[i]["dialog"],
			"faceset": dialog_data[i]["faceset"]
		}

	var new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_dict

	_hud.add_child(new_dialog)

	if _player:
		_player.blocked = true
		_player.go_to_idle_state()

	new_dialog.tree_exited.connect(_on_dialog_closed)
	new_dialog.start_dialog()

func _on_dialog_closed() -> void:
	if _player:
		_player.blocked = false
		
	dialog_ended.emit()
