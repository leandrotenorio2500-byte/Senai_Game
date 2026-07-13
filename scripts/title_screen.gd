extends Control

@onready var start: Button = $Buttons_manager/VBoxContainer/start
@onready var credits: Button = $Buttons_manager/VBoxContainer/credits
@onready var quit_button: Button = $Buttons_manager/VBoxContainer/QuitButton
@onready var skin_changer_button: Button = $Buttons_manager/VBoxContainer/skin_changer
@onready var toque: AudioStreamPlayer = $toque


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Trilha.stream_paused = false


func _on_start_pressed() -> void:
	toque.play()
	Transicao.mudar_cena("res://scene/chegada.tscn")

func _on_skin_changer_pressed() -> void:
	toque.play()
	Transicao.mudar_cena("res://scene/skin_changer/page1.tscn")

func _on_credits_pressed() -> void:
	toque.play()
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	toque.play()
	get_tree().quit()
