extends Control

signal option_selected(option: Dictionary)

@onready var labels = [
	$Opcao1,
	$Opcao2,
	$Opcao3,
	$Exit
]

# Novo sistema de NPC
@onready var _name: Label = $Background/NinePatchRect/MarginContainer/Label
@onready var _faceset: TextureRect = $Background/TextureRect
@onready var _panel: NinePatchRect = $Background/NinePatchRect
@onready var _margin: MarginContainer = $Background/NinePatchRect/MarginContainer


var options: Array = []
var current_option := 0
const COLUNAS := 2


func _ready() -> void:
	hide_options()


func show_options(new_options: Array, npc_data: Dictionary = {}):

	options = new_options

	current_option = 0

	# Atualiza nome e rosto
	if npc_data.has("title"):
		_name.text = npc_data["title"]

	if npc_data.has("faceset"):
		_faceset.texture = load(npc_data["faceset"])

	await _ajustar_nome()

	visible = true

	update_options()


func _ajustar_nome() -> void:
	await get_tree().process_frame
	_panel.size = _margin.get_combined_minimum_size()


func update_options():

	for i in range(labels.size()):
		
		if i < options.size():
			labels[i].visible = true         
			labels[i].text = options[i].text
			
			if i == current_option:
				labels[i].text = "► " + labels[i].text
			else:
				labels[i].text = "   " + labels[i].text
		else:
			labels[i].visible = false


func _unhandled_input(event):

	if !visible:
		return

	if event.is_action_pressed("ui_right"):
		move_right()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("ui_left"):
		move_left()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("ui_down"):
		move_down()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("ui_up"):
		move_up()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("interect"):

		if options.is_empty():
			return

		get_viewport().set_input_as_handled()

		option_selected.emit(options[current_option])


func move_right():

	var destino = current_option + 1

	if destino < options.size() and current_option % 2 == 0:
		current_option = destino

	update_options()


func move_left():

	var destino = current_option - 1

	if destino >= 0 and current_option % 2 == 1:
		current_option = destino

	update_options()


func move_down():

	var destino = current_option + COLUNAS

	if destino < options.size():
		current_option = destino

	update_options()


func move_up():

	var destino = current_option - COLUNAS

	if destino >= 0:
		current_option = destino

	update_options()


func hide_options():
	visible = false
