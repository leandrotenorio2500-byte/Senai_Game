extends Control
class_name DialogScreen

var _step: float = 0.05
var _id: int = 0
var data: Dictionary = {}

@onready var _name: Label = $Background/HBoxContainer/VBoxContainer/Label
@onready var _dialog: RichTextLabel = $Background/HBoxContainer/VBoxContainer/Dialog
@onready var _faceset: TextureRect = $Background/HBoxContainer/Border/TextureRect

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interect") and _dialog.visible_ratio < 1:
		_step = 0.01
		return
	
	_step = 0.05
	if Input.is_action_just_pressed("interect"):
		_id += 1
		if _id == data.size():
			queue_free()
			return
		
		_initialize_dialog()

func start_dialog() -> void:
	_initialize_dialog()

func _initialize_dialog() -> void:
	if _name == null or _dialog == null or _faceset == null:
		push_error("DialogScreen: nós não encontrados na árvore de cena!")
		return

	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	_faceset.texture = load(data[_id]["faceset"])
	
	_dialog.visible_characters = 0
	
	var current_dialog_id = _id
	while _dialog.visible_ratio < 1:
		await get_tree().create_timer(_step).timeout
		if _id != current_dialog_id:
			return
		_dialog.visible_characters += 1
