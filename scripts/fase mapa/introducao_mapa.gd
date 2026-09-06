extends Node2D

@onready var toque: AudioStreamPlayer = $toque

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
	toque.play()
	introducao.visible = false
	tutorial.visible = true

func _on_btn_continuar_tutorial_pressed() -> void:
	toque.play()
	tutorial.visible = false
	tutorial_2.visible = true

func _on_btn_continuar_tutorial_2_pressed() -> void:
	toque.play()
	tutorial_2.visible = false
	tutorial_3.visible = true

func _on_btn_continuar_tutorial_3_pressed() -> void:
	toque.play()
	
	Transicao.mudar_cena("res://scene/corredor.tscn")
