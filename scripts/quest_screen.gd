extends Control
class_name MissionScreen

@onready var _title: Label = $HBoxContainer/VBoxContainer/Title
@onready var _subtitle: Label = $HBoxContainer/VBoxContainer/Subtitle

func _ready() -> void:
	if _title == null or _subtitle == null:
		push_error("MissionScreen: Nós de texto não encontrados na árvore de cena!")

# Exibido quando a missão é iniciada
func show_started(quest_id: String) -> void:
	update_display(quest_id)

# Exibição/Atualização dos dados na interface
func update_display(quest_id: String) -> void:
	var missao = QuestManager.obter_missao(quest_id)
	if missao == null: 
		return
		
	if _title:
		_title.text = missao.title
		
	if _subtitle:
		if "current_count" in missao and "target_count" in missao:
			_subtitle.text = missao.description + " (" + str(missao.current_count) + "/" + str(missao.target_count) + ")"
		else:
			_subtitle.text = missao.description

# Exibido quando a missão for concluída
func show_completed() -> void:
	if _title:
		_title.text = "MISSÃO COMPLETA!"
	if _subtitle:
		_subtitle.text = "Parabéns pelo seu esforço!"
