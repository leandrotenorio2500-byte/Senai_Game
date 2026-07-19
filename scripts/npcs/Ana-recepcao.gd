extends "res://scripts/npc.gd"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/ana-recep.png")
	hframes = 2
	super._ready()
var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Ana"

func _on_dialog_completed() -> void:

	super._on_dialog_completed()

	if !Globals.setores_desbloqueados["Recepcao"]:
		Globals.desbloquear_setor("Recepcao")
		QuestManager.progress_quest("identificar_riscos")

		atualizar_dialogo()

func atualizar_dialogo():

	if Globals.setores_desbloqueados["Recepcao"]:

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
