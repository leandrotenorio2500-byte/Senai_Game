extends Node2D
class_name Almoxarifado

@onready var _hud: CanvasLayer = $HUD

func _ready() -> void:
	DialogManager.register_player($Player)
	DialogManager.register_hud(_hud)
	QuestManager.register_hud(_hud)
