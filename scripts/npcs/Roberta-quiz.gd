extends "res://scripts/npc.gd"

const QUEST_ID := "analise_curriculos"

func _ready() -> void:
	print(QuestManager.obter_estado("analise_curriculos"))
	npc_name = "Roberta"
	npc_faceset_path = "res://sprites/Mini UI/heads/Vitoria.png"

	idle_spritesheet = load("res://sprites/npcs/Roberta.png")
	hframes = 2

	var quest = QuestManager.obter_missao(QUEST_ID)

	if quest:
		if not quest.iniciada.is_connected(_on_quest_state_changed):
			quest.iniciada.connect(_on_quest_state_changed)

		if not quest.em_andamento.is_connected(_on_quest_state_changed):
			quest.em_andamento.connect(_on_quest_state_changed)

		if not quest.finalizada.is_connected(_on_quest_state_changed):
			quest.finalizada.connect(_on_quest_state_changed)

	atualizar_dialogo()

	super._ready()


func atualizar_dialogo():

	dialogo_inicio()

func dialogo_inicio():

	if tem_outra_missao_ativa(QUEST_ID):

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Percebi que você já está ocupado com outra atividade no momento.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Quando terminar sua missão atual, volte para conversarmos.",
				"faceset": npc_faceset_path
			}
		]
		return

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Eu sou a Roberta, responsável pelo setor de Recursos Humanos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Estamos precisando analisar alguns currículos para selecionar os candidatos mais adequados para cada vaga.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_em_andamento():

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Continue analisando os currículos. Quando terminar, volte para conversarmos.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_finalizada():

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Excelente trabalho! Você fez uma ótima análise dos currículos.",
			"faceset": npc_faceset_path
		}
	]

func get_dialogo_setor() -> Array[Dictionary]:

	return [
		{
			"title": npc_name,
			"dialog": "O setor de Recursos Humanos é responsável pelo recrutamento, seleção, treinamento e desenvolvimento dos colaboradores.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também acompanhamos o desenvolvimento dos funcionários e ajudamos a manter um bom ambiente de trabalho.",
			"faceset": npc_faceset_path
		}
	]


func get_dialogo_funcionarios() -> Array[Dictionary]:

	return [
		{
			"title": npc_name,
			"dialog": "Nossa equipe é formada por profissionais responsáveis pelos processos de contratação, integração e desenvolvimento dos colaboradores.",
			"faceset": npc_faceset_path
		}
	]

func get_dialog_options() -> Array:

	return [
		{
			"text":"Sobre o RH",
			"id":"setor"
		},
		{
			"text":"Funcionários",
			"id":"funcionarios"
		},
		{
			"text":"Iniciar missão",
			"id":"missao"
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

		"funcionarios":
			DialogManager.show_dialog(get_dialogo_funcionarios())

		"missao":

			if tem_outra_missao_ativa(QUEST_ID):
				DialogManager.end_conversation()
				return

			if QuestManager.obter_estado(QUEST_ID) == "nao_iniciada":
				QuestManager.iniciar_missao(QUEST_ID)

			DialogManager.end_conversation()

			await get_tree().create_timer(0.5).timeout

			Transicao.mudar_cena("res://scene/fase RH/tutorial/tutorial_rh.tscn")

		"exit":
			DialogManager.end_conversation()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

func _on_quest_state_changed(quest_id: String) -> void:
	if quest_id == QUEST_ID:
		atualizar_dialogo()
