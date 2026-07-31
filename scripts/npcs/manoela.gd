extends "res://scripts/npc.gd"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/npc-rh.png")
	hframes = 8
	super._ready()
var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Roberta"

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("RH", false):
		Globals.desbloquear_setor("RH")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "RH"})
		Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	if Globals.setores_desbloqueados["RH"]:

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
				"dialog": "Olá! Eu trabalho no Recursos Humanos. Nosso setor cuida das pessoas, desde a contratação até o desenvolvimento dos colaboradores.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Passamos boa parte do dia utilizando computadores e analisando documentos. Parece uma atividade tranquila, mas permanecer muito tempo sentado ou com a postura incorreta pode causar desconforto.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Também é importante manter a mesa organizada e ajustar corretamente a cadeira e o monitor. Pequenos detalhes fazem diferença ao longo do expediente.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Às vezes, os riscos mais difíceis de perceber são justamente aqueles que aparecem aos poucos.",
				"faceset": npc_faceset_path
			}
		]

func mudar_de_cena() -> void:
	Transicao.mudar_cena("res://scene/fase RH/triagem_curriculos.tscn")
