extends Control
class_name MissionScreen

@onready var _title: Label = $HBoxContainer/VBoxContainer/Title
@onready var _subtitle: Label = $HBoxContainer/VBoxContainer/Subtitle

func show_started(quest_id: String) -> void:
	if not is_node_ready():
		await ready
		
	var missao = QuestManager.obter_missao(quest_id)
	if missao == null:
		push_error("MissionScreen: Não encontrou a missão com id: " + quest_id)
		return

	if _title:
		_title.text = "NOVA MISSÃO: " + missao.title
		
	if _subtitle:
		if "current_count" in missao and "target_count" in missao:
			_subtitle.text = missao.description + " (" + str(missao.current_count) + "/" + str(missao.target_count) + ")"
		else:
			_subtitle.text = missao.description

func show_completed() -> void:
	if not is_node_ready():
		await ready
		
	if _title:
		_title.text = "MISSÃO COMPLETA!"
	if _subtitle:
		_subtitle.text = "Parabéns pelo seu esforço!"
