extends CanvasLayer

@onready var mapa = $"../mapa_risco"
@onready var progresso = $Painel/Progresso

@onready var labels = {
	"Recepcao": $Painel/VBoxContainer/Recepcao,
	"Deposito": $Painel/VBoxContainer/Deposito,
	"Producao": $Painel/VBoxContainer/Producao,
	"Almoxarifado": $Painel/VBoxContainer/Almoxarife,
	"Refeitorio": $Painel/VBoxContainer/Refeitorio,
	"Vestiario": $Painel/VBoxContainer/Vestiario,
	"Banheiro": $Painel/VBoxContainer/Banheiro,
	"RH": $Painel/VBoxContainer/RH,
}

func _ready() -> void:
	Globals.mapa_aberto.connect(esconder_hud)
	Globals.mapa_fechado.connect(mostrar_hud)

	# Tenta obter a instância da missão no QuestManager
	var quest_riscos = QuestManager.obter_missao("identificar_riscos")
	if quest_riscos:
		quest_riscos.iniciada.connect(_on_quest_started)
		quest_riscos.finalizada.connect(_on_quest_completed)

	# Checa o estado atual usando o novo sistema
	var estado = QuestManager.obter_estado("identificar_riscos")
	
	if estado == "em_andamento":
		visible = true
		atualizar()
	else:
		visible = false

func esconder_hud() -> void:
	visible = false

func mostrar_hud() -> void:
	# Só mostra a HUD ao fechar o mapa se a missão estiver ativa
	var estado = QuestManager.obter_estado("identificar_riscos")
	if estado == "em_andamento":
		visible = true
		atualizar()

func _on_quest_started(_quest_id: String) -> void:
	visible = true
	atualizar()

func _on_quest_completed(_quest_id: String) -> void:
	visible = false

func atualizar() -> void:
	var visitados = 0

	for setor in labels.keys():
		if Globals.setores_desbloqueados.get(setor, false):
			visitados += 1
			labels[setor].text = "✓ " + setor
		else:
			labels[setor].text = "□ " + setor

	progresso.text = str(visitados) + "/" + str(labels.size()) + " setores visitados"

func _on_mapa_pressed() -> void:
	Globals.abrir_mapa.emit()
