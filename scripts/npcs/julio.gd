extends "res://scripts/npc.gd"

const QUEST_ID := "treinamento_epi"

func _ready() -> void:
	print(QuestManager.obter_estado(QUEST_ID))

	npc_name = "Júlio"
	npc_faceset_path = "res://sprites/Mini UI/heads/Daniel.png"

	idle_spritesheet = load("res://sprites/npcs/Julio.png")
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
				"dialog": "Quando terminar sua missão atual, volte para conversarmos sobre o treinamento de EPI.",
				"faceset": npc_faceset_path
			}
		]
		return

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Eu sou o Júlio, responsável pelo treinamento de segurança aqui no setor de Recursos Humanos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Estou preparando um treinamento sobre o uso correto dos Equipamentos de Proteção Individual, os EPIs.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "É importante saber não apenas qual equipamento utilizar, mas também quando e como utilizá-lo corretamente.",
			"faceset": npc_faceset_path
		}
	]


func dialogo_em_andamento():


	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Continue o treinamento sobre o uso correto dos EPIs. Quando terminar, volte para conversarmos.",
			"faceset": npc_faceset_path
		}
	]


func dialogo_finalizada():


	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Excelente trabalho! Agora você já conhece melhor os cuidados necessários para utilizar os EPIs corretamente.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Lembre-se: utilizar o equipamento correto é uma parte fundamental da prevenção de acidentes.",
			"faceset": npc_faceset_path
		}
	]


func get_dialogo_setor() -> Array[Dictionary]:


	return [
		{
			"title": npc_name,
			"dialog": "O Recursos Humanos também participa das ações de treinamento e orientação dos colaboradores.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Entre essas ações estão os treinamentos relacionados à segurança, prevenção de acidentes e uso adequado dos equipamentos de proteção.",
			"faceset": npc_faceset_path
		}
	]


func get_dialogo_funcionarios() -> Array[Dictionary]:


	return [
		{
			"title": npc_name,
			"dialog": "Todos os colaboradores precisam conhecer os riscos relacionados às suas atividades e saber quais medidas de proteção devem ser adotadas.",
			"faceset": npc_faceset_path
		}
	]


func get_dialog_options() -> Array:


	return [
		{
			"text": "Sobre o RH",
			"id": "setor"
		},
		{
			"text": "Funcionários",
			"id": "funcionarios"
		},
		{
			"text": "Iniciar treinamento",
			"id": "missao"
		},
		{
			"text": "Encerrar",
			"id": "exit"
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

			Transicao.mudar_cena("res://scene/fase quiz/quiz.tscn")

		"exit":
			DialogManager.end_conversation()


func _on_dialog_completed() -> void:
	super._on_dialog_completed()

func _on_quest_state_changed(quest_id: String) -> void:


	if quest_id == QUEST_ID:
		atualizar_dialogo()
