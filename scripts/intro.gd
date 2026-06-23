extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(6.0).timeout
	$AnimationPlayer.play("fade out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://prefabs/title_screen.tscn")
