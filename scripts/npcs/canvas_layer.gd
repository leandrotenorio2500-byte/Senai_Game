extends CanvasLayer
class_name ActivityPrompt

signal accepted
signal declined

@onready var label := $Panel/Background/VBoxContainer/Pergunta
@onready var start_button := $Panel/Background/VBoxContainer/HBoxContainer/Comecar
@onready var later_button := $Panel/Background/VBoxContainer/HBoxContainer/Depois

func _ready():
	hide()

	start_button.pressed.connect(_on_comecar_pressed)
	later_button.pressed.connect(_on_depois_pressed)

func show_prompt(text: String):
	label.text = text
	show()

func _on_comecar_pressed() -> void:
	hide()
	accepted.emit()


func _on_depois_pressed() -> void:
	hide()
	declined.emit()
