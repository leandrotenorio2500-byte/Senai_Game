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
}

func _process(_delta):
	atualizar()
	
func _ready():
	Globals.mapa_aberto.connect(esconder_hud)
	Globals.mapa_fechado.connect(mostrar_hud)
	QuestManager.quest_started.connect(_on_quest_started)
	QuestManager.quest_completed.connect(_on_quest_completed)

	visible = false

	if QuestManager.quests["identificar_riscos"]["started"] \
	and !QuestManager.quests["identificar_riscos"]["completed"]:
		atualizar()

func esconder_hud():
	visible = false

func mostrar_hud():
	visible = true

func _on_quest_started(quest_id):
	if quest_id == "identificar_riscos":
		visible = true
		atualizar()
		
func _on_quest_completed(quest_id):
	if quest_id == "identificar_riscos":
		visible = false

func atualizar():
	var visitados = 0

	for setor in labels.keys():

		if Globals.setores_desbloqueados[setor]:

			visitados += 1
			labels[setor].text = "✓ " + setor

		else:

			labels[setor].text = "□ " + setor

	progresso.text = str(visitados) + "/" + str(labels.size()) + " setores visitados"


func _on_mapa_pressed() -> void:
	Globals.abrir_mapa.emit()
	
