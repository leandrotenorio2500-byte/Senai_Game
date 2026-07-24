extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "João"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/operario3.png")
	hframes = 8
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Banheiro", false):
		Globals.desbloquear_setor("Banheiro")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Banheiro"})

		atualizar_dialogo()

func atualizar_dialogo() -> void:
	if Globals.setores_desbloqueados.get("Banheiro", false):
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
				"dialog": "Pode parecer estranho, mas até um banheiro exige cuidados com a segurança.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Como muitas pessoas utilizam este ambiente ao longo do dia, manter a higiene é essencial para evitar problemas relacionados à saúde.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Além disso, utilizamos produtos químicos na limpeza dos equipamentos e há empilhadeiras circulando constantemente pelo setor.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Essas informações devem ajudar você a preencher o Mapa de Risco.",
				"faceset": npc_faceset_path
			}
		]
