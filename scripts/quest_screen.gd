extends Control
class_name MissionScreen

@onready var _title: Label = $HBoxContainer/VBoxContainer/Title
@onready var _subtitle: Label = $HBoxContainer/VBoxContainer/Subtitle

func _ready() -> void:
	if _title == null or _subtitle == null:
		push_error("MissionScreen: Nós de texto não encontrados na árvore de cena!")

# Exibição normal durante o jogo
func update_display(quest_id: String) -> void:
	var missao = QuestManager.obter_missao(quest_id)
	if missao == null: return
		
	_title.text = missao.title
	
	if "current_count" in missao and "target_count" in missao:
		_subtitle.text = missao.description + " (" + str(missao.current_count) + "/" + str(missao.target_count) + ")"
	else:
		_subtitle.text = missao.description

# NOVO: Método dedicado para quando a missão for concluída
func show_completed() -> void:
	if _title:
		_title.text = "MISSÃO COMPLETA!"
	if _subtitle:
		_subtitle.text = "Parabéns pelo seu esforço!"
