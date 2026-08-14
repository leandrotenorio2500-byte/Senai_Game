extends "res://scripts/npc.gd"


func _ready() -> void:
	npc_faceset_path = "res://sprites/Mini UI/heads/Ana.png"
	npc_name = "Ana"
	idle_spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2

	atualizar_dialogo()
	super._ready()

	# Desbloqueia a Recepção no primeiro contato
	if not Globals.setores_desbloqueados.get("Recepcao", false):
		Globals.desbloquear_setor("Recepcao")

		QuestManager.progredir_missao(
			"identificar_riscos",
			{"setor": "Recepcao"}
		)

		Globals.abrir_mapa.emit()

		atualizar_dialogo()


# ============================================================
# ATUALIZAÇÃO DOS DIÁLOGOS
# ============================================================

func atualizar_dialogo() -> void:

	var estado_mapa := QuestManager.obter_estado("identificar_riscos")


	# --------------------------------------------------------
	# MISSÃO MAPA DE RISCO
	# --------------------------------------------------------

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Recepcao", false):
			dialogo_mapa_concluido()
		else:
			dialogo_mapa_risco()

		return


	# --------------------------------------------------------
	# DIÁLOGO NORMAL
	# --------------------------------------------------------

	dialogo_normal()


# ============================================================
# FINALIZAÇÃO DO DIÁLOGO
# ============================================================

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	# Caso a Recepção ainda não esteja desbloqueada,
	# garante a progressão da missão Mapa de Risco.
	if not Globals.setores_desbloqueados.get("Recepcao", false):

		Globals.desbloquear_setor("Recepcao")

		QuestManager.progredir_missao(
			"identificar_riscos",
			{"setor": "Recepcao"}
		)

		Globals.abrir_mapa.emit()

		atualizar_dialogo()


# ============================================================
# DIÁLOGO — MAPA DE RISCO CONCLUÍDO
# ============================================================

func dialogo_mapa_concluido() -> void:

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
			"faceset": npc_faceset_path
		}
	]


# ============================================================
# DIÁLOGO — MAPA DE RISCO
# ============================================================

func dialogo_mapa_risco() -> void:

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


# ============================================================
# DIÁLOGO NORMAL
# ============================================================

func dialogo_normal() -> void:

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
		}
	]
