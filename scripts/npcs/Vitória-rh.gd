extends "res://scripts/npc.gd"

func _ready() -> void:
	npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
	npc_name = "Vitória"

	idle_spritesheet = load("res://sprites/npcs/npc-rh.png")
	hframes = 8
	atualizar_dialogo()
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("RH", false):
			Globals.desbloquear_setor("RH")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "RH"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("RH", false):
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
			"dialog": "Olá! Eu sou da equipe de Recursos Humanos. Nosso trabalho é cuidar das pessoas e apoiar os funcionários dentro da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Aqui passamos bastante tempo utilizando computadores, preenchendo documentos e realizando atividades administrativas.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Mesmo sendo um ambiente mais tranquilo, permanecer muito tempo sentado, com postura inadequada ou sem pausas pode causar desconfortos e problemas ergonômicos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também é importante ajustar corretamente cadeira, mesa e monitor, além de manter o ambiente organizado para facilitar a rotina de trabalho.",
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
			"dialog": "Olá! Eu sou a Vitória, do setor de Recursos Humanos. Nosso trabalho é cuidar das pessoas que fazem parte da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Nós acompanhamos processos como contratação, treinamentos e o desenvolvimento dos colaboradores ao longo da jornada profissional.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Apesar de ser um setor administrativo, também precisamos prestar atenção ao ambiente de trabalho e aos hábitos da nossa rotina.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de alguma informação sobre o RH ou sobre como funcionam nossos processos, pode perguntar.",
			"faceset": npc_faceset_path
		}
	]
