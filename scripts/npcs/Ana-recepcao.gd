extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Ana"
var setor_npc: String = "Recepcao"
var item_necessario: String = "mouse_novo"

const QUEST_ID = "atender_chamados"

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2
	
	# Conecta aos sinais da missão de chamados para atualizar diálogo dinamicamente
	var quest = QuestManager.obter_missao(QUEST_ID)
	if quest:
		quest.iniciada.connect(_on_quest_state_changed)
		quest.em_andamento.connect(_on_quest_state_changed)
		quest.finalizada.connect(_on_quest_state_changed)
	
	atualizar_dialogo()
	super._ready()

# Verifica se o jogador já está fazendo OUTRA missão
func _tem_outra_missao_ativa() -> bool:
	for q_id in QuestManager.missoes.keys():
		if q_id != QUEST_ID:
			if QuestManager.obter_estado(q_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo() -> void:
	var estado = QuestManager.obter_estado(QUEST_ID)
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	
	# 1. Se o jogador tem outra missão em andamento e ainda não iniciou esta
	if _tem_outra_missao_ativa() and estado == "nao_iniciada":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Vejo que você já tem uma tarefa em andamento.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Termine o que está fazendo antes de me ajudar com o computador, por favor!",
				"faceset": npc_faceset_path
			}
		]

	# 2. Se a missão de chamados já foi concluída
	elif estado == "finalizada":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "O mouse novo que você trouxe está funcionando perfeitamente! Muito obrigado.",
				"faceset": npc_faceset_path
			}
		]

	# 3. Se a missão está em andamento
	elif estado == "em_andamento":
		# Caso 3A: Este NPC específico já teve o chamado atendido
		if quest and quest.esta_resolvido(setor_npc):
			dialog_data = [
				{
					"title": npc_name,
					"dialog": "O meu problema já foi resolvido! Verifique com os outros funcionários se eles precisam de ajuda.",
					"faceset": npc_faceset_path
				}
			]
		# Caso 3B: O jogador está com o item necessário no inventário
		elif Globals.possui_item(item_necessario):
			dialog_data = [
				{
					"title": npc_name,
					"dialog": "Ah, você trouxe o mouse novo! Perfeito, muito obrigado!",
					"faceset": npc_faceset_path
				}
			]
		# Caso 3C: O chamado foi aberto, mas o jogador ainda não trouxe o item
		else:
			dialog_data = [
				{
					"title": npc_name,
					"dialog": "Meu mouse continua ruim. Conseguiu pegar um novo na bancada de TI?",
					"faceset": npc_faceset_path
				}
			]

	# 4. Missão não iniciada (e nenhuma outra missão ativa)
	else:
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Opa, tudo bem? Meu computador está péssimo para trabalhar hoje.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "O mouse parou de funcionar completamente.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Você poderia buscar um mouse novo na bancada de TI para mim?",
				"faceset": npc_faceset_path
			}
		]

func _on_quest_state_changed(quest_id_sinal: String) -> void:
	if quest_id_sinal == QUEST_ID:
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()
	
	var estado = QuestManager.obter_estado(QUEST_ID)
	
	# Tenta iniciar a missão caso ela não tenha sido iniciada e o jogador esteja livre
	if estado == "nao_iniciada" and not _tem_outra_missao_ativa():
		QuestManager.iniciar_missao(QUEST_ID)
		estado = QuestManager.obter_estado(QUEST_ID)

	# Lógica de progresso quando a missão já está em andamento
	if estado == "em_andamento":
		var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
		if quest and not quest.esta_resolvido(setor_npc):
			# Se possui o item, remove do inventário e avança a missão
			if Globals.possui_item(item_necessario):
				Globals.remover_item(item_necessario)
				QuestManager.progredir_missao(QUEST_ID, {"setor": setor_npc})
			else:
				# Registra que este NPC abriu o chamado
				quest.abrir_chamado(setor_npc)

	# Recarrega as falas de acordo com a nova situação
	atualizar_dialogo()
