extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Ana"
var setor_npc: String = "Recepcao"
var item_necessario: String = "mouse_novo"

const QUEST_ID = "atender_chamados"
var cena_monitor: PackedScene = preload("res://scene/fase chamados/bancada_funcionario.tscn") # Ajuste o caminho se necessário

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2
	
	# Conecta com os sinais do QuestManager
	var quest = QuestManager.obter_missao(QUEST_ID)
	if quest:
		quest.iniciada.connect(_on_quest_state_changed)
		quest.em_andamento.connect(_on_quest_state_changed)
		quest.finalizada.connect(_on_quest_state_changed)
	
	atualizar_dialogo()
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Recepcao", false):
		Globals.desbloquear_setor("Recepcao")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Recepcao"})
		Globals.abrir_mapa.emit()
		atualizar_dialogo()

func atualizar_dialogo() -> void:
	# 1. Checagem inicial de desbloqueio da Recepção (Lógica trazida pelo seu amigo)
	if not Globals.setores_desbloqueados.get("Recepcao", false):
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá! Seja bem-vindo à nossa empresa. Antes de começar suas atividades, é importante conhecer bem cada setor e os riscos que existem neles.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Muita gente acha que a recepção é um lugar completamente seguro, mas não é bem assim. Aqui também precisamos ficar atentos.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Passamos muitas horas sentados atendendo o público e usando o computador. Se a cadeira ou a postura não forem adequadas, isso pode causar dores e lesões com o tempo.",
				"faceset": npc_faceset_path
			}
		]
		return

	# 2. Lógica de Missões de Chamados (Após o setor estar liberado)
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

	# PASSO 1: Desbloqueia a Recepção no primeiro diálogo (caso ainda não esteja)
	if not Globals.setores_desbloqueados.get("Recepcao", false):
		Globals.desbloquear_setor("Recepcao")
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Recepcao"})
		atualizar_dialogo()
		return

	# PASSO 2: Inicia a quest de chamados se estiver liberada
	var estado = QuestManager.obter_estado(QUEST_ID)
	if estado == "nao_iniciada" and not _tem_outra_missao_ativa():
		QuestManager.iniciar_missao(QUEST_ID)
		estado = QuestManager.obter_estado(QUEST_ID)

	# PASSO 3: Abre a tela de monitor interativa (Diagnóstico ou Instalação)
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	if estado == "em_andamento" and quest and not quest.esta_resolvido(setor_npc):
		_abrir_tela_monitor()

func _abrir_tela_monitor() -> void:
	if cena_monitor:
		var tela = cena_monitor.instantiate()
		tela.item_correto = item_necessario
		tela.nome_npc = npc_name
		tela.faceset_npc = npc_faceset_path
		
		# Define se é modo de instalação (se já tem o item) ou diagnóstico (se não tem)
		tela.modo_instalacao = Globals.possui_item(item_necessario)
		
		get_tree().root.add_child(tela)
		tela.monitor_fechado.connect(_on_monitor_fechado)

func _on_monitor_fechado(acertou: bool) -> void:
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	if not quest:
		return

	if Globals.possui_item(item_necessario):
		if acertou:
			Globals.remover_item(item_necessario)
			QuestManager.progredir_missao(QUEST_ID, {"setor": setor_npc})
			print("[QUEST] Peça instalada e chamado RESOLVIDO no setor: ", setor_npc)
	else:
		if acertou:
			quest.abrir_chamado(setor_npc)

	atualizar_dialogo()
