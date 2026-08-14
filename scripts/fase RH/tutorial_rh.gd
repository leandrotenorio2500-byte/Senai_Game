extends "res://scripts/tutorials/tutorial_carousel.gd"

# Define a fase final diretamente via preload
@export var next_scene: PackedScene = preload("res://scene/fase RH/triagem_curriculos.tscn")

func _ready() -> void:
	steps = [
		preload("res://scene/fase RH/tutorial/etapa1.tscn"),
		preload("res://scene/fase RH/tutorial/etapa2.tscn"),
		preload("res://scene/fase RH/tutorial/etapa3.tscn"),
		preload("res://scene/fase RH/tutorial/etapa4.tscn"),
	]
	
	super._ready()

func _on_tutorial_finished() -> void:
	emit_signal("tutorial_finished")
	
	if next_scene:
		Transicao.mudar_cena(next_scene.resource_path)
	else:
		print("Tutorial finalizado, mas nenhuma 'next_scene' foi definida!")
