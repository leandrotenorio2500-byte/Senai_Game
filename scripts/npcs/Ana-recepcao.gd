extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Ana"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Recepcao", false):
		Globals.desbloquear_setor("Recepcao")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Recepcao"})

		atualizar_dialogo()

func atualizar_dialogo() -> void:
	if Globals.setores_desbloqueados.get("Recepcao", false):
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
