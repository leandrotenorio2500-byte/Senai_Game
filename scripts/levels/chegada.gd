extends Node2D
class_name Chegada

@onready var _hud: CanvasLayer = $HUD

func _ready() -> void:
	DialogManager.register_player($Player)
	DialogManager.register_hud(_hud)
