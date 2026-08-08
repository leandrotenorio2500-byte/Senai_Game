extends Node

signal dialog_ended

const _DIALOG_SCREEN: PackedScene = preload("res://entities/dialog_screen.tscn")
const _OPTION_MENU: PackedScene = preload("res://prefabs/DialogOptionMenu.tscn")

var _current_option_menu: Control = null
var _current_npc: Node = null
var _player: CharacterBody2D = null
var _hud: CanvasLayer = null
var _conversation_active := false

func is_conversation_active() -> bool:
	return _conversation_active

func register_player(player: CharacterBody2D) -> void:
	_player = player

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud

func start_dialog(dialog_data: Array[Dictionary], npc: Node = null) -> void:
	if _hud == null or _conversation_active:
		return

	_conversation_active = true
	_current_npc = npc

	if _player:
		_player.blocked = true
		_player.go_to_idle_state()

	show_dialog(dialog_data)

func show_dialog(dialog_data: Array[Dictionary]) -> void:

	if _current_option_menu:
		_current_option_menu.queue_free()
		_current_option_menu = null

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

	new_dialog.dialog_finished.connect(_on_dialog_finished)

	new_dialog.start_dialog()

func continue_dialog(dialog_data: Array[Dictionary]) -> void:
	show_dialog(dialog_data)

func _on_dialog_closed():

	if _player:
		_player.blocked = false

	_current_npc = null
	_conversation_active = false

	dialog_ended.emit()

func _on_dialog_finished(dialog: DialogScreen) -> void:

	dialog.queue_free()

	if _current_npc:
		_current_npc._on_dialog_completed()

	if _current_npc != null and _current_npc.pode_mostrar_opcoes_dialogo():

		_current_option_menu = _OPTION_MENU.instantiate()

		_hud.add_child(_current_option_menu)

		_current_option_menu.option_selected.connect(_on_option_selected)

		_current_option_menu.show_options(
			_current_npc.get_dialog_options(),
			_current_npc.get_npc_info()
		)
	else:

		_on_dialog_closed()

func _on_option_selected(option: Dictionary) -> void:

	if _current_option_menu:
		_current_option_menu.queue_free()
		_current_option_menu = null

	if _current_npc:
		_current_npc.on_dialog_option_selected(option)
		
func end_conversation() -> void:

	if _current_option_menu:
		_current_option_menu.queue_free()
		_current_option_menu = null

	_on_dialog_closed()
