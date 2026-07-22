extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/julia_dialog.png"
var npc_name = "Jacson"

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/npc7.png")
	hframes = 8
	
	# Se a missão existe no QuestManager, conectamos aos sinais próprios dela
	var quest_riscos = QuestManager.obter_missao("atender_chamados")
	if quest_riscos:
		quest_riscos.iniciada.connect(_on_quest_state_changed)
		quest_riscos.em_andamento.connect(_on_quest_state_changed)
		quest_riscos.finalizada.connect(_on_quest_state_changed)
	
	# Define o diálogo inicial com base no estado atual da missão
	atualizar_dialogo()
	
	super._ready()

# Função auxiliar para verificar se o jogador está ocupado com outra missão
func _tem_outra_missao_ativa() -> bool:
	for quest_id in QuestManager.missoes.keys():
		if quest_id != "atender_chamados":
			if QuestManager.obter_estado(quest_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo() -> void:
	var estado = QuestManager.obter_estado("atender_chamados")
	
		# 1. Se o jogador já tem outra missão em andamento
	if _tem_outra_missao_ativa() and estado == "nao_iniciada":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Percebi que você já está ocupado com outra tarefa no momento.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Termine o que está fazendo primeiro e depois volte aqui para falarmos sobre os chamados!",
				"faceset": npc_faceset_path
			}
		]
	
	
	elif estado == "finalizada":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Parabéns, você completou a missão!",
				"faceset": npc_faceset_path
			}
		]
	
	elif estado == "em_andamento":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Lembre-se, você precisa identificar os 3 pontos de risco no ambiente.",
				"faceset": npc_faceset_path
			}
		]
	
	else: # "nao_iniciada" ou não registrada ainda
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá, tudo bem? Seja muito bem-vindo!",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Como seu primeiro momento aqui no T.I iremos atender à alguns chamados.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Vamos nessa!",
				"faceset": npc_faceset_path
			}
		]

# Função que reage aos sinais da missão
func _on_quest_state_changed(quest_id: String) -> void:
	if quest_id == "atender_chamados":
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()
	_atender_chamados_marcar_conversado()

func _atender_chamados_marcar_conversado() -> void:
	var estado = QuestManager.obter_estado("atender_chamados")
	
	# Se a missão ainda não começou, inicia ela ao terminar a conversa
	if estado == "nao_iniciada":
		QuestManager.iniciar_missao("atender_chamados")
