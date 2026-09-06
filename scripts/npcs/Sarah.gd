extends "res://scripts/npc.gd"

func get_dialogo_setor() -> Array[Dictionary]:
	return [
		{
			"title": npc_name,
			"dialog": "O depósito é responsável por receber, armazenar e distribuir materiais para todos os setores da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Aqui organizamos o estoque, conferimos mercadorias e garantimos que cada setor receba os materiais necessários para o trabalho.",
			"faceset": npc_faceset_path
		}
	]

func _ready() -> void:

	npc_name = "Sarah - Líder do Depósito"
	npc_faceset_path = "res://sprites/Mini UI/heads/Sarah.png"

	atualizar_dialogo()

	idle_spritesheet = load("res://sprites/npcs/operaria4.png")
	hframes = 8

	super._ready()
	
func get_dialog_options() -> Array:
	return [
		{
			"text":"Sobre Deposito",
			"id":"setor"
		},
		{
			"text":"Encerrar",
			"id":"exit"
		}
	]

func on_dialog_option_selected(option: Dictionary) -> void:

	match option.id:

		"setor":
			DialogManager.show_dialog(get_dialogo_setor())

		"exit":
			DialogManager.end_conversation()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Deposito", false):
			Globals.desbloquear_setor("Deposito")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Deposito"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Deposito", false):
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
			"dialog": "Olá! Este é o depósito da empresa. É aqui que recebemos, armazenamos e distribuímos diversos materiais utilizados pelos outros setores.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Durante o dia movimentamos caixas, carrinhos e mercadorias o tempo todo. Por isso, manter os corredores livres e prestar atenção ao redor faz toda a diferença para evitar acidentes.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Algumas cargas são bem pesadas. Quando alguém tenta levantá-las sem a técnica correta, o esforço pode causar dores e até lesões com o passar do tempo.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Além disso, quase sempre trabalhamos com empilhadeiras e outros equipamentos em funcionamento.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Então, dependendo do movimento e do barulho das operações, é preciso ficar atento ao ambiente e utilizar os equipamentos de proteção quando necessário.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_normal():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Bem-vindo ao depósito. Trabalhamos organizando e distribuindo materiais para toda a empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de algum material, é só falar comigo!",
			"faceset": npc_faceset_path
		}
	]
