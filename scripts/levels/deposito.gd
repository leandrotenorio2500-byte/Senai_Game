extends Node2D
class_name Deposito


#@onready var _dialog_hud: CanvasLayer = $DialogHUD
#@onready var _mission_hud: CanvasLayer = $MissionHUD
@onready var _hud: CanvasLayer = $HUD

func _ready() -> void:
	DialogManager.register_player($Player)
	DialogManager.register_hud(_hud)
	QuestManager.register_hud(_hud)
	
	Globals.area_atual = scene_file_path.get_file().get_basename()
