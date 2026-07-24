extends Control
class_name DialogScreen

const TEXT_SPEED := 0.03

var _id := 0
var data: Dictionary = {}

var _typing := false
var _current_text := ""
var _visible_chars := 0
var _timer := 0.0

@onready var _name: Label = $Background/HBoxContainer/VBoxContainer/Label
@onready var _dialog: RichTextLabel = $Background/HBoxContainer/VBoxContainer/Dialog
@onready var _faceset: TextureRect = $Background/HBoxContainer/Border/TextureRect


func start_dialog() -> void:
	_show_dialog()


func _process(delta: float) -> void:

	# Digitação
	if _typing:
		_timer += delta

		if _timer >= TEXT_SPEED:
			_timer = 0

			_visible_chars += 1
			_dialog.visible_characters = _visible_chars

			if _visible_chars >= _dialog.get_total_character_count():
				_typing = false

	# Entrada do jogador
	if Input.is_action_just_pressed("interect"):

		if _typing:
			_finish_typing()
		else:
			_next_dialog()


func _show_dialog() -> void:

	if !data.has(_id):
		queue_free()
		return

	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	_faceset.texture = load(data[_id]["faceset"])

	_current_text = data[_id]["dialog"]

	_visible_chars = 0
	_dialog.visible_characters = 0

	_timer = 0
	_typing = true


func _finish_typing() -> void:

	_typing = false
	_visible_chars = _dialog.get_total_character_count()
	_dialog.visible_characters = _visible_chars


func _next_dialog() -> void:

	_id += 1

	if _id >= data.size():
		queue_free()
		return

	_show_dialog()
