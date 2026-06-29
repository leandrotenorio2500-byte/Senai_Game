extends Node2D
@onready var intro: AudioStreamPlayer = $Intro

func _ready() -> void:
	intro.play()
	Trilha.stream_paused = true
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(6.0).timeout
	$AnimationPlayer.play("fade out")
	await get_tree().create_timer(3.0).timeout
	
	get_tree().change_scene_to_file("res://prefabs/title_screen.tscn")
	
	
	
