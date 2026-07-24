extends "res://scripts/npc.gd"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/operaria4.png")
	scale.x = -1
	hframes = 8
	super._ready()
var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Sarah"

func _on_dialog_completed() -> void:

	super._on_dialog_completed()

	if !Globals.setores_desbloqueados["Deposito"]:
		Globals.desbloquear_setor("Deposito")
		QuestManager.progress_quest("identificar_riscos")

		atualizar_dialogo()

func atualizar_dialogo():

	if Globals.setores_desbloqueados["Deposito"]:

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
				"faceset": npc_faceset_path
			}
		]

	else:

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
				"dialog": "Além disso, quase sempre trabalhamos com empilhadeiras e outros equipamentos em funcionamento. Dependendo do movimento e do barulho das operações, é preciso ficar atento ao ambiente e utilizar os equipamentos de proteção quando necessário.",
				"faceset": npc_faceset_path
			}
		]
