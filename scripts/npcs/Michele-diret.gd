extends "res://scripts/npc.gd"



func _ready() -> void:
	npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
	npc_name = "Michele"

	idle_spritesheet = load("res://sprites/npcs/coroa2.png")
	hframes = 8
	super._ready()
	atualizar_dialogo()
	
func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Diretoria", false):
			Globals.desbloquear_setor("Diretoria")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Diretoria"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Diretoria", false):
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
			"dialog": "Olá. Vejo que você está analisando os setores da empresa e identificando os riscos presentes em cada ambiente.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Muitas pessoas acreditam que uma área administrativa não apresenta riscos, mas todo ambiente de trabalho precisa de atenção e cuidados.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Na Diretoria passamos muitas horas em reuniões, analisando informações e trabalhando em computadores. Por isso, postura inadequada e falta de pausas podem causar problemas ao longo do tempo.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Além disso, manter o espaço organizado é fundamental para garantir um ambiente seguro e eficiente para todos.",
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
			"dialog": "Olá. Seja bem-vindo à Diretoria. Este é o setor responsável por tomar decisões importantes e acompanhar o funcionamento da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Aqui analisamos projetos, planejamos melhorias e buscamos soluções para que todos os setores possam trabalhar da melhor forma possível.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Mesmo em uma área administrativa, é importante lembrar que segurança faz parte da rotina de todos dentro da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Espero que sua experiência conhecendo os setores ajude você a entender melhor como cada área contribui para o funcionamento da organização.",
			"faceset": npc_faceset_path
		}
	]
