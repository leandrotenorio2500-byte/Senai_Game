extends CanvasLayer

signal started

@onready var title = $Panel/Titulo
@onready var description = $Panel/Descripton
@onready var objectives = $Panel/Objectives

func configurar(
	titulo:String,
	descricao:String,
	objetivos:String,
):
	title.text = titulo
	description.text = descricao
	objectives.text = objetivos

func _on_start_button_pressed():
	started.emit()

	queue_free()
