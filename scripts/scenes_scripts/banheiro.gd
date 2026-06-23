extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.area_atual = scene_file_path.get_file().get_basename()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
