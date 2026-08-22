extends Node2D

@onready var introducao: Control = $Introducao
@onready var tutorial: Control = $Tutorial
@onready var tutorial_2: Control = $Tutorial2
@onready var tutorial_3: Control = $Tutorial3

func _ready() -> void:
	introducao.visible = true
	tutorial.visible = false
	tutorial_2.visible = false
	tutorial_3.visible = false


func _on_btn_continuar_pressed() -> void:
	introducao.visible = false
	tutorial.visible = true

func _on_btn_continuar_tutorial_pressed() -> void:
	tutorial.visible = false
	tutorial_2.visible = true

func _on_btn_continuar_tutorial_2_pressed() -> void:
	tutorial_2.visible = false
	tutorial_3.visible = true

func _on_btn_continuar_tutorial_3_pressed() -> void:
	Transicao.mudar_cena("res://scene/corredor.tscn")
