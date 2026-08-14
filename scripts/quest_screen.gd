extends Control
class_name MissionScreen

@onready var _background: NinePatchRect = $Background
@onready var _title: Label = $Background/Title
@onready var _subtitle: Label = $Background/Subtitle

func _ready() -> void:
	if _title == null or _subtitle == null or _background == null:
		push_error("MissionScreen: Nós de texto não encontrados na árvore de cena!")
		return
		
	_centralizar_labels()

func _centralizar_labels() -> void:
	for label in [_title, _subtitle]:
		# Força o Label a ter exatamente a mesma largura do fundo
		label.position.x = 0
		label.size.x = _background.size.x
		label.custom_minimum_size.x = _background.size.x
		
		# Aplica o alinhamento centralizado
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

# Exibido quando a missão é iniciada
func show_started(quest_id: String) -> void:
	update_display(quest_id)

# Exibição/Atualização dos dados na interface
func update_display(quest_id: String) -> void:
	if not is_node_ready():
		await ready

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

	_centralizar_labels()

# Chamado pelo QuestManager ao iniciar a missão
func show_started(quest_id: String) -> void:
	update_display(quest_id)

# Método dedicado para quando a missão for concluída
func show_completed() -> void:
	if not is_node_ready():
		await ready
		
	if _title:
		_title.text = "MISSÃO COMPLETA!"
	if _subtitle:
		_subtitle.text = "Parabéns pelo seu esforço!"

	_centralizar_labels()
