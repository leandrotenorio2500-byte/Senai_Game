extends Control

@onready var start: Button = $Buttons_manager/VBoxContainer/start
@onready var credits: Button = $Buttons_manager/VBoxContainer/credits
@onready var quit_button: Button = $Buttons_manager/VBoxContainer/QuitButton
@onready var toque: AudioStreamPlayer = $toque


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Trilha.stream_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	toque.play()
	get_tree().change_scene_to_file("res://scene/chegada.tscn")

func _on_credits_pressed() -> void:
	toque.play()
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	toque.play()
	get_tree().quit()
