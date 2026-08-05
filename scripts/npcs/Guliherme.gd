extends "res://scripts/npc.gd"



func _ready() -> void:
	npc_faceset_path = "res://sprites/Mini UI/heads/Guilherme.png"
	npc_name = "Guilherme"
	
	idle_spritesheet = load("res://sprites/npcs/Guilherme.png")
	hframes = 8
	atualizar_dialogo()
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Refeitorio", false):
			Globals.desbloquear_setor("Refeitorio")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Refeitorio"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Refeitorio", false):
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
			"dialog": "Aqui no refeitório precisamos ter bastante cuidado com a organização e a limpeza, já que muitas pessoas utilizam este espaço durante os intervalos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Alimentos derramados, líquidos no chão ou objetos fora do lugar podem causar escorregões e quedas.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também é importante manter os alimentos armazenados corretamente e cuidar da higiene dos equipamentos e utensílios utilizados no ambiente.",
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
			"dialog": "Olá! Seja bem-vindo ao refeitório da empresa. Este é o espaço onde os funcionários fazem suas refeições e descansam durante os intervalos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Meu trabalho é ajudar a manter este ambiente organizado para que todos possam aproveitar o momento de pausa com conforto.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Um ambiente limpo e bem cuidado faz diferença não só para a segurança, mas também para o bem-estar de todos os funcionários.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de alguma informação sobre este setor, pode perguntar.",
			"faceset": npc_faceset_path
		}
	]
