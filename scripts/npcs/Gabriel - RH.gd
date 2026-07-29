extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png" # Ajuste o caminho se necessário
var npc_name = "Gabriel"
var setor_npc: String = "RH"
var item_necessario: String = "memoria_ram"

const QUEST_ID = "atender_chamados"

var cena_monitor: PackedScene = preload("res://scene/fase chamados/bancada_funcionario.tscn")

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/npc_ti.png") # Ajuste o caminho se necessário
	hframes = 8
	vframes = 1
	
	# Conecta com os sinais do QuestManager
	var quest = QuestManager.obter_missao(QUEST_ID)
	if quest:
		quest.iniciada.connect(_on_quest_state_changed)
		quest.em_andamento.connect(_on_quest_state_changed)
		quest.finalizada.connect(_on_quest_state_changed)
	
	atualizar_dialogo()
	super._ready()

func atualizar_dialogo() -> void:
	var estado = QuestManager.obter_estado(QUEST_ID)
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados

	# 1. SE A MISSÃO DE CHAMADOS ESTIVER EM ANDAMENTO:
	if estado == "em_andamento":
		if quest and quest.esta_resolvido(setor_npc):
			dialog_data = [
				{"title": npc_name, "dialog": "O computador do RH está voando agora! Muito obrigado pela ajuda.", "faceset": npc_faceset_path}
			]
		elif Globals.possui_item(item_necessario):
			dialog_data = [
				{"title": npc_name, "dialog": "Você trouxe o pente de memória RAM! Dê uma olhada na máquina para instalar no slot correto.", "faceset": npc_faceset_path}
			]
		elif quest and quest.problemas_npcs.get(setor_npc, {}).get("chamado_aberto", false):
			dialog_data = [
				{"title": npc_name, "dialog": "Meu sistema continua travando bastante. Conseguiu a memória RAM na bancada de TI?", "faceset": npc_faceset_path}
			]
		else:
			# Primeiro diálogo dentro da missão de chamados antes do diagnóstico
			dialog_data = [
				{"title": npc_name, "dialog": "Olá! Que bom que você veio. Meu computador está travando direto para abrir as planilhas do RH.", "faceset": npc_faceset_path},
				{"title": npc_name, "dialog": "Pode dar uma conferida no gabinete para ver o que está causando a lentidão?", "faceset": npc_faceset_path}
			]

	# 2. SE A MISSÃO JÁ FOI FINALIZADA:
	elif estado == "finalizada":
		dialog_data = [
			{"title": npc_name, "dialog": "A nova memória RAM resolveu todos os travamentos. O RH agradece!", "faceset": npc_faceset_path}
		]

	# 3. CASO PADRÃO (Sem missão ou antes de iniciar a missão de chamados):
	else:
		dialog_data = [
			{"title": npc_name, "dialog": "Bom dia! Tudo tranquilo na gestão de pessoas por aqui.", "faceset": npc_faceset_path},
			{"title": npc_name, "dialog": "Se precisar de algo do RH, é só chamar.", "faceset": npc_faceset_path}
		]

func _on_quest_state_changed(quest_id_sinal: String) -> void:
	if quest_id_sinal == QUEST_ID:
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	# Só abre a bancada do monitor se a missão de chamados estiver EM ANDAMENTO
	var estado = QuestManager.obter_estado(QUEST_ID)
	var quest = QuestManager.obter_missao(QUEST_ID) as QuestChamados
	if estado == "em_andamento" and quest and not quest.esta_resolvido(setor_npc):
		_abrir_tela_monitor()

func _abrir_tela_monitor() -> void:
	if cena_monitor:
		var tela = cena_monitor.instantiate()
		tela.item_correto = item_necessario
		tela.nome_npc = npc_name
		tela.faceset_npc = npc_faceset_path
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
