extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Sarah"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/operaria4.png")
	scale.x = -1
	hframes = 8
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Deposito", false):
		Globals.desbloquear_setor("Deposito")
		
		# Novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Deposito"})

		atualizar_dialogo()

func atualizar_dialogo() -> void:
	if Globals.setores_desbloqueados.get("Deposito", false):
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
				"dialog": "Opa, tudo bem? Você é o novo Jovem Aprendiz?",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Aqui na Produção trabalhamos com diversas máquinas que fazem bastante barulho durante todo o expediente.",
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
