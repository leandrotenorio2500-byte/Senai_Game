extends Node2D
class_name Recep

@onready var _dialog_hud: CanvasLayer = $DialogHUD
@onready var _mission_hud: CanvasLayer = $MissionHUD

func _ready() -> void:
	DialogManager.register_player($Player)
	DialogManager.register_hud(_dialog_hud)
	QuestManager.register_hud(_mission_hud)
