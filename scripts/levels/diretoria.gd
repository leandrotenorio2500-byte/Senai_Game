extends Node2D
class_name Diretoria

@onready var _hud: CanvasLayer = $HUD

func _ready() -> void:
	ActivityManager.iniciar_atividade(
	preload("res://scene/fase chamados/bancada_funcionario.tscn"),
	"bancada_ti"
)
	DialogManager.register_player($Player)
	DialogManager.register_hud(_hud)
	QuestManager.register_hud(_hud)

	Globals.area_atual = scene_file_path.get_file().get_basename()
