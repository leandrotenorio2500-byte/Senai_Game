extends CanvasLayer

@onready var mapa = $"../mapa_risco"
@onready var progresso = $Painel/Progresso

@onready var labels = {
	"Recepcao": $Painel/VBoxContainer/Recepcao,
	"Deposito": $Painel/VBoxContainer/Deposito,
	"Producao": $Painel/VBoxContainer/Producao,
	"Tecnico": $Painel/VBoxContainer/Tecnico,
	"Refeitorio": $Painel/VBoxContainer/Refeitorio,
	"Vestiario": $Painel/VBoxContainer/Vestiario,
	"Banheiro": $Painel/VBoxContainer/Banheiro,
	"RH": $Painel/VBoxContainer/RH,
	"Diretoria": $Painel/VBoxContainer/Diretoria
}

var quest_riscos: QuestIdentificarRiscos

func _ready() -> void:
	Globals.mapa_aberto.connect(esconder_hud)
	Globals.mapa_fechado.connect(mostrar_hud)
	Globals.setor_desbloqueado.connect(_on_setor_desbloqueado)

	# Tenta obter a instância da missão no QuestManager
	quest_riscos = QuestManager.obter_missao("identificar_riscos")
	if quest_riscos:
		quest_riscos.iniciada.connect(_on_quest_started)
		quest_riscos.finalizada.connect(_on_quest_completed)

		quest_riscos.setor_visitado.connect(_on_progresso_atualizado)
		quest_riscos.setor_analisado.connect(_on_progresso_atualizado)
		quest_riscos.mapa_pronto.connect(_on_mapa_pronto)

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

	var analisados := 0

	if quest_riscos:
		analisados = quest_riscos.setores_analisados.size()

	progresso.text = (
		#"Setores visitados: "
		#+ str(visitados)
		#+ "/"
		#+ str(labels.size())
		#+ "\n"
		"Setores registrados: "
		+ str(analisados)
		+ "/"
		+ str(labels.size())
	)

func _on_mapa_pressed() -> void:
	Globals.abrir_mapa.emit()
	
func _on_setor_desbloqueado(_nome: String) -> void:
	if visible:
		atualizar()
		
func _on_progresso_atualizado(_setor = "") -> void:
	if visible:
		atualizar()


func _on_mapa_pronto() -> void:
	if visible:
		atualizar()
