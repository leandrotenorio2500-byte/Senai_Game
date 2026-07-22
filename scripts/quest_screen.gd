extends Control
class_name MissionScreen

@onready var _title: Label = $HBoxContainer/VBoxContainer/Title
@onready var _subtitle: Label = $HBoxContainer/VBoxContainer/Subtitle

# Quando a missão COMEÇA
func show_started(quest_id: String) -> void:
	if not is_node_ready():
		await ready
		
	var missao = QuestManager.obter_missao(quest_id)
	if missao == null: return

	if _title:
		_title.text = "NOVA MISSÃO: " + missao.title
	if _subtitle:
		_subtitle.text = missao.description

# Quando a missão É CONCLUÍDA
func show_completed() -> void:
	if not is_node_ready():
		await ready
		
	if _title:
		_title.text = "MISSÃO COMPLETA!"
	if _subtitle:
		_subtitle.text = "Parabéns pelo seu esforço!"
