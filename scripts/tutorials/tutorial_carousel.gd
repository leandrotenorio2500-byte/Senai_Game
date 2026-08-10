extends Control

signal tutorial_finished

@export var steps: Array[PackedScene] = []
var dot_scene: PackedScene = preload("res://scene/tutorials/dot.tscn")

var current_step: int = 0
var current_content: Node = null
var dots: Array = []

@onready var content_host: Control = $RootVBox/MainRow/ContentHost
@onready var btn_prev: Button = $RootVBox/MainRow/BtnPrev
@onready var btn_next: Button = $RootVBox/MainRow/BtnNext
@onready var dots_container: HBoxContainer = $RootVBox/DotsContainer

func _ready() -> void:
	btn_prev.pressed.connect(_on_btn_prev_pressed)
	btn_next.pressed.connect(_on_btn_next_pressed)
	
	setup_dots()
	if steps.size() > 0:
		show_step(0)

func setup_dots() -> void:
	for child in dots_container.get_children():
		child.queue_free()
	dots.clear()

	if dot_scene:
		for i in range(steps.size()):
			var dot_instance = dot_scene.instantiate()
			dots_container.add_child(dot_instance)
			dots.append(dot_instance)

func show_step(index: int) -> void:
	if index < 0 or index >= steps.size():
		return

	current_step = index

	if current_content and is_instance_valid(current_content):
		current_content.queue_free()

	current_content = steps[current_step].instantiate()
	content_host.add_child(current_content)

	# Se a cena filha for do tipo Control, ajusta para preencher o ContentHost
	if current_content is Control:
		var control_content = current_content as Control
		control_content.set_anchors_preset(Control.PRESET_FULL_RECT)
		control_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control_content.size_flags_vertical = Control.SIZE_EXPAND_FILL

	update_dots()
	update_buttons()
	
func update_dots() -> void:
	for i in range(dots.size()):
		var dot = dots[i] as Node
		if dot and dot.has_method("set_active"):
			dot.call("set_active", i == current_step)

func update_buttons() -> void:
	btn_prev.disabled = (current_step == 0)
	btn_prev.text = "<"
	
	if current_step == steps.size() - 1:
		pass
		#btn_next.text = "Concluir"
	else:
		btn_next.text = ">"

func _on_btn_prev_pressed() -> void:
	if current_step > 0:
		show_step(current_step - 1)

func _on_btn_next_pressed() -> void:
	if current_step < steps.size() - 1:
		show_step(current_step + 1)
	else:
		_on_tutorial_finished()

# Função virtual destinada a ser sobrescrita pelos scripts filhos
func _on_tutorial_finished() -> void:
	emit_signal("tutorial_finished")
