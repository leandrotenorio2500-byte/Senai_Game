extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Ana"
var setor_npc: String = "Recepcao"
var item_necessario: String = "mouse_novo"

const QUEST_ID = "atender_chamados"
var cena_monitor: PackedScene = preload("res://scene/fase chamados/bancada_funcionario.tscn")

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2
	
	var quest = QuestManager.obter_missao(QUEST_ID)
	if quest:
		quest.iniciada.connect(_on_quest_state_changed)
		quest.em_andamento.connect(_on_quest_state_changed)
		quest.finalizada.connect(_on_quest_state_changed)
	
	atualizar_dialogo()
	super._ready()

func _tem_outra_missao_ativa() -> bool:
	for q_id in QuestManager.missoes.keys():
		if q_id != QUEST_ID:
			if QuestManager.obter_estado(q_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo() -> void:
	var estado = QuestManager.obter_estado(QUEST_ID)
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	
	if _tem_outra_missao_ativa() and estado == "nao_iniciada":
		dialog_data = [
			{"title": npc_name, "dialog": "Vejo que você já tem uma tarefa em andamento.", "faceset": npc_faceset_path},
			{"title": npc_name, "dialog": "Termine o que está fazendo antes de me ajudar com o computador, por favor!", "faceset": npc_faceset_path}
		]

	elif estado == "finalizada":
		dialog_data = [
			{"title": npc_name, "dialog": "O mouse novo que você instalou está funcionando perfeitamente! Muito obrigado.", "faceset": npc_faceset_path}
		]

	elif estado == "em_andamento":
		if quest and quest.esta_resolvido(setor_npc):
			dialog_data = [
				{"title": npc_name, "dialog": "O meu problema já foi resolvido! Verifique com os outros funcionários se eles precisam de ajuda.", "faceset": npc_faceset_path}
			]
		elif Globals.possui_item(item_necessario):
			dialog_data = [
				{"title": npc_name, "dialog": "Que ótimo que você trouxe a peça! Dê uma olhada no computador para instalar no local correto.", "faceset": npc_faceset_path}
			]
		else:
			dialog_data = [
				{"title": npc_name, "dialog": "Meu mouse continua ruim. Conseguiu pegar um novo na bancada de TI?", "faceset": npc_faceset_path}
			]

	else:
		dialog_data = [
			{"title": npc_name, "dialog": "Opa, tudo bem? Meu computador está péssimo para trabalhar hoje.", "faceset": npc_faceset_path},
			{"title": npc_name, "dialog": "Você pode dar uma olhada na minha máquina e descobrir qual peça está com defeito?", "faceset": npc_faceset_path}
		]

func _on_quest_state_changed(quest_id_sinal: String) -> void:
	if quest_id_sinal == QUEST_ID:
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()
	
	var estado = QuestManager.obter_estado(QUEST_ID)
	
	if estado == "nao_iniciada" and not _tem_outra_missao_ativa():
		QuestManager.iniciar_missao(QUEST_ID)
		estado = QuestManager.obter_estado(QUEST_ID)

	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	
	if estado == "em_andamento" and quest and not quest.esta_resolvido(setor_npc):
		_abrir_tela_monitor()

func _abrir_tela_monitor() -> void:
	if cena_monitor:
		var tela = cena_monitor.instantiate()
		
		# Define os parâmetros para a tela do computador
		tela.item_correto = item_necessario
		tela.nome_npc = npc_name
		tela.faceset_npc = npc_faceset_path
		
		# Se já tem o item no inventário, define o modo como CONSERTO/INSTALAÇÃO
		tela.modo_instalacao = Globals.possui_item(item_necessario)
		
		get_tree().root.add_child(tela)
		tela.monitor_fechado.connect(_on_monitor_fechado)

func _on_monitor_fechado(acertou: bool) -> void:
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	if not quest:
		return

	# Se estava instalando o item e acertou o local da substituição
	if Globals.possui_item(item_necessario):
		if acertou:
			Globals.remover_item(item_necessario)
			QuestManager.progredir_missao(QUEST_ID, {"setor": setor_npc})
			print("[QUEST] Peça instalada e chamado RESOLVIDO no setor: ", setor_npc)
	else:
		# Se estava no diagnóstico inicial e descobriu o defeito
		if acertou:
			quest.abrir_chamado(setor_npc)

	atualizar_dialogo()
