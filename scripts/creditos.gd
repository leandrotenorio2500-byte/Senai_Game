extends Control

@onready var toque: AudioStreamPlayer = $toque

func _on_voltar_pressed() -> void:
	toque.play()
	Transicao.mudar_cena("res://prefabs/title_screen.tscn")
