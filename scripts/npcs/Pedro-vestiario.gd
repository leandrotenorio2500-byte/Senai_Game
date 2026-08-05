extends "res://scripts/npc.gd"

func _ready() -> void:
	npc_faceset_path = "res://sprites/Mini UI/heads/Hugo.png"
	npc_name = "Hugo"

	idle_spritesheet = load("res://sprites/npcs/npc7.png")
	hframes = 8
	atualizar_dialogo()
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Vestiario", false):
			Globals.desbloquear_setor("Vestiario")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Vestiario"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Vestiario", false):
			dialogo_mapa_concluido()
		else:
			dialogo_mapa_risco()

		return

	dialogo_normal()

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
			"dialog": "Opa, tudo bem? Você é o novo Jovem Aprendiz?",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Aqui no vestiário o movimento costuma ser grande principalmente nos horários de entrada e saída dos funcionários.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "É importante manter mochilas, botas e outros objetos sempre organizados, porque materiais deixados pelo caminho podem causar tropeços e quedas.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também precisamos cuidar da limpeza dos armários e do ambiente. Como várias pessoas utilizam este espaço diariamente, a higiene ajuda a evitar problemas de saúde.",
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
			"dialog": "Olá! Seja bem-vindo ao vestiário da empresa. É aqui que os funcionários se preparam antes de iniciar suas atividades.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Meu trabalho é ajudar a manter este espaço organizado para que todos possam guardar seus pertences e se preparar com tranquilidade.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Mesmo sendo um ambiente de passagem, a organização faz toda a diferença para manter o local seguro e confortável.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de alguma informação sobre o funcionamento do vestiário, pode perguntar.",
			"faceset": npc_faceset_path
		}
	]
