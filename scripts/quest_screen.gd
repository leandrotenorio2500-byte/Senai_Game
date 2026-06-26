extends Control
class_name MissionScreen

# Referências baseadas na estrutura da imagem enviada
@onready var _title: Label = $HBoxContainer/VBoxContainer/Title
@onready var _subtitle: Label = $HBoxContainer/VBoxContainer/Subtitle

func _ready() -> void:
	# Garante que os nós existem ao iniciar
	if _title == null or _subtitle == null:
		push_error("MissionScreen: Nós de texto não encontrados na árvore de cena!")

# Função chamada pelo QuestManager para atualizar os textos visualizados
func update_display(quest_id: String) -> void:
	if not QuestManager.quests.has(quest_id):
		return
		
	var quest_data = QuestManager.quests[quest_id]
	
	# Define o título principal da missão
	_title.text = quest_data["title"]
	
	# Pega o passo atual da missão
	var current_step_idx = quest_data["current_step"]
	
	# Previne erros caso a missão já tenha fechado mas a UI tente atualizar
	if current_step_idx < quest_data["steps"].size():
		var step = quest_data["steps"][current_step_idx]
		
		# Monta a String final ex: "Encontre os pontos de risco no mapa (1/3)"
		_subtitle.text = step["description"] + " (" + str(step["current_count"]) + "/" + str(step["target_count"]) + ")"
