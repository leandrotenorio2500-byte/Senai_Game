extends "res://scripts/npc.gd"

var setor_npc: String = "Recepcao"
var item_necessario: String = "mouse_novo"

const QUEST_ID = "atender_chamados"
var atividade_bancada: PackedScene = preload("res://scene/fase chamados/bancada_funcionario.tscn")

func _ready() -> void:
	npc_faceset_path = "res://sprites/Mini UI/heads/Ana.png"
	npc_name = "Ana"
	idle_spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2

	ActivityManager.activity_finished.connect(_on_activity_finished)
	
	# Conecta com os sinais do QuestManager
	var quest = QuestManager.obter_missao(QUEST_ID)
	if quest:
		quest.iniciada.connect(_on_quest_state_changed)
		quest.em_andamento.connect(_on_quest_state_changed)
		quest.finalizada.connect(_on_quest_state_changed)
	
	atualizar_dialogo()
	super._ready()



	if not Globals.setores_desbloqueados.get("Recepcao", false):
		Globals.desbloquear_setor("Recepcao")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Recepcao"})
		Globals.abrir_mapa.emit()
		atualizar_dialogo()

func _tem_outra_missao_ativa() -> bool:
	for q_id in QuestManager.missoes.keys():
		if q_id != QUEST_ID:
			if QuestManager.obter_estado(q_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo() -> void:
	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	# Diálogos da missão Mapa de Risco
	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Recepcao", false):
			dialogo_mapa_concluido()
		else:
			dialogo_mapa_risco()

		return

	# A partir daqui permanece toda a lógica da missão Atender Chamados
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
		dialogo_normal()
		
func _on_dialog_completed() -> void:
	super._on_dialog_completed()


	# PASSO 1: Desbloqueia a Recepção no primeiro diálogo
	if not Globals.setores_desbloqueados.get("Recepcao", false):
		Globals.desbloquear_setor("Recepcao")
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Recepcao"})
		atualizar_dialogo()
		return


	# PASSO 2: Inicia a missão de chamados
	var estado = QuestManager.obter_estado(QUEST_ID)

	if estado == "nao_iniciada" and not _tem_outra_missao_ativa():
		QuestManager.iniciar_missao(QUEST_ID)
		estado = QuestManager.obter_estado(QUEST_ID)


	# PASSO 3: Abre a bancada TI

	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados

	if estado == "em_andamento" and quest and not quest.esta_resolvido(setor_npc):
		_abrir_bancada_ti()
		
func _on_quest_state_changed(quest_id_sinal: String) -> void:
	if quest_id_sinal == QUEST_ID:
		atualizar_dialogo()

func _abrir_bancada_ti() -> void:

	ActivityManager.iniciar_atividade(
		atividade_bancada,
		"bancada_ti",
		{
			"npc": self,
			"setor": setor_npc,
			"item_necessario": item_necessario
		}
	)
	
func _on_activity_finished(activity_id: String, resultado: Dictionary) -> void:

	if activity_id != "bancada_ti":
		return


	print("Resultado recebido pela Ana:")
	print(resultado)


	if resultado.get("cancelado", false):
		print("Jogador fechou a bancada.")
		return


	var equipamento = resultado.get("equipamento", "")


	if equipamento == item_necessario:
		print("Equipamento correto encontrado!")

		var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados

		if quest:
			quest.abrir_chamado(setor_npc)

	else:
		print("Equipamento errado.")

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

func _on_equipamento_selecionado(item:String):

	if item == item_necessario:

		DialogManager.start_dialog([
			{
				"title": npc_name,
				"dialog": "Isso mesmo! O defeito está no mouse. Vou precisar de uma peça nova.",
				"faceset": npc_faceset_path
			}
		])

	else:

		DialogManager.start_dialog([
			{
				"title": npc_name,
				"dialog": "Esse componente parece estar funcionando normalmente.",
				"faceset": npc_faceset_path
			}
		])

func avaliar_equipamento(item: String) -> void:

	if item == item_necessario:

		DialogManager.start_dialog(
			[
				{
					"title": npc_name,
					"dialog": "Isso mesmo! O defeito está nesse componente. Vou precisar de uma peça nova para substituir.",
					"faceset": npc_faceset_path
				}
			],
			self
		)

	else:

		var resposta := ""

		match item:

			"monitor_novo":
				resposta = "O monitor está funcionando normalmente. A imagem está perfeita."

			"teclado_novo":
				resposta = "O teclado responde bem. Não parece ser esse o problema."

			"memoria_ram":
				resposta = "As peças internas parecem estar funcionando corretamente."

			_:
				resposta = "Não encontrei nenhum problema nesse componente."


		DialogManager.start_dialog(
			[
				{
					"title": npc_name,
					"dialog": resposta,
					"faceset": npc_faceset_path
				}
			],
			self
		)

func dialogo_mapa_concluido():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_mapa_risco():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Seja bem-vindo à empresa. A recepção é o primeiro lugar por onde passam funcionários, visitantes e fornecedores.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Passamos boa parte do dia atendendo pessoas, utilizando o computador e organizando documentos. Mesmo sendo um ambiente administrativo, alguns riscos precisam de atenção.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Ficar muitas horas sentado, trabalhar com postura inadequada ou deixar cabos e objetos espalhados pelo chão pode causar acidentes e problemas de saúde ao longo do tempo.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Essas informações devem ajudar você a preencher o Mapa de Risco.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_normal():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Seja bem-vindo à recepção. Meu trabalho é receber os visitantes, orientar os funcionários e encaminhar cada pessoa ao setor correto.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também realizo atendimentos, organizo documentos e acompanho diversas solicitações ao longo do dia para que tudo funcione da melhor forma possível.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "A recepção é a porta de entrada da empresa, então procuramos oferecer um ambiente organizado e acolhedor para todos que chegam.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Aliás... estou com um probleminha no meu computador. Se tiver um tempinho depois, talvez você possa me dar uma ajuda.",
			"faceset": npc_faceset_path
		}
	]
