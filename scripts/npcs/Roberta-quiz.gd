extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Roberta"

func _ready() -> void:
	atualizar_dialogo()
	idle_spritesheet = load("res://sprites/npcs/Roberta.png")
	hframes = 2
	super._ready()


func _on_dialog_completed():

	super._on_dialog_completed()

	if missao_mapa_risco_ativa():

		Globals.desbloquear_setor("RH")
		QuestManager.progress_quest("identificar_riscos")

	elif missao_mapa_risco_finalizada():

		iniciar_analise_curriculos()


func iniciar_analise_curriculos():
	await get_tree().create_timer(0.5).timeout
	
	Transicao.mudar_cena("res://scene/fase RH/triagem_curriculos.tscn")


func atualizar_dialogo():

	if missao_mapa_risco_ativa():

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá! Eu sou responsável pelo setor de Recursos Humanos. Preciso da sua ajuda para identificar os riscos presentes neste ambiente.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Mesmo em um escritório existem riscos. Postura inadequada, iluminação insuficiente e longos períodos utilizando computador podem prejudicar a saúde.",
				"faceset": npc_faceset_path
			}
		]

	elif missao_mapa_risco_finalizada():

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá novamente! Agora que terminamos o levantamento dos riscos, posso precisar da sua ajuda em uma atividade do RH.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Precisamos analisar alguns currículos e identificar quais candidatos possuem o perfil adequado para cada vaga.",
				"faceset": npc_faceset_path
			}
		]

	else:

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá! Eu sou a Roberta, responsável pelo setor de Recursos Humanos.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Aqui cuidamos dos processos de contratação, treinamento e desenvolvimento dos colaboradores.",
				"faceset": npc_faceset_path
			}
		]
