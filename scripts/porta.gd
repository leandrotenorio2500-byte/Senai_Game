extends Area2D

@export var next_scene: PackedScene
var on_door := false

func _ready() -> void:
	pass 
	
func _on_body_entered(body: Node2D) -> void:
	on_door = true

func _on_body_exited(body: Node2D) -> void:
	on_door = false
	
func _process(delta: float) -> void:
	if on_door and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_packed(next_scene)
