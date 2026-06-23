extends Control

@onready var iniciar: Button = $Buttons_manager/VBoxContainer/Iniciar
@onready var créditos: Button = $Buttons_manager/VBoxContainer/Créditos
@onready var sair: Button = $Buttons_manager/VBoxContainer/Sair


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/chegada.tscn")


func _on_créditos_pressed() -> void:
	pass # Replace with function body.


func _on_sair_pressed() -> void:
	get_tree().quit()
