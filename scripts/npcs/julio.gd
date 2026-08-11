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
				"dialog": "Quando terminar sua missão atual, volte aqui. Ainda precisamos conversar sobre o treinamento de segurança.",
				"faceset": npc_faceset_path
			}
		]
		return

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Eu sou o Júlio. Faço parte do setor de Saúde e Segurança no Trabalho, o SST.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Nosso trabalho é ajudar a prevenir acidentes e orientar os colaboradores sobre os riscos presentes nas atividades do dia a dia.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Uma parte importante disso é garantir que todos saibam utilizar corretamente os Equipamentos de Proteção Individual.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Por isso, preparei um treinamento para você. Vamos ver se está realmente preparado para trabalhar com segurança.",
			"faceset": npc_faceset_path
		}
	]


func dialogo_em_andamento():

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Ainda não terminou o treinamento de segurança?",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Continue prestando atenção. Saber identificar os riscos é tão importante quanto saber utilizar o EPI correto.",
			"faceset": npc_faceset_path
		}
	]


func dialogo_finalizada():

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Muito bem! Você concluiu o treinamento de uso correto dos EPIs.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Mas lembre-se: o EPI é apenas uma das medidas de proteção. A melhor forma de evitar acidentes é conhecer os riscos e agir de maneira segura.",
			"faceset": npc_faceset_path
		}
	]


func get_dialogo_setor() -> Array[Dictionary]:

	return [
		{
			"title": npc_name,
			"dialog": "O SST trabalha na prevenção de acidentes e doenças relacionadas ao trabalho, orientando os colaboradores e acompanhando as condições de segurança dos ambientes.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também participamos de treinamentos e ações de conscientização para que cada pessoa saiba reconhecer os riscos e trabalhar de forma mais segura.",
			"faceset": npc_faceset_path
		}
	]


func get_dialogo_funcionarios() -> Array[Dictionary]:

	return [
		{
			"title": npc_name,
			"dialog": "Todos os colaboradores têm um papel importante na segurança. Não basta a empresa oferecer os equipamentos: é preciso utilizá-los corretamente e seguir os procedimentos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se alguém perceber uma situação de risco, também deve comunicar o responsável. Prevenção é uma responsabilidade de todos.",
			"faceset": npc_faceset_path
		}
	]


func get_dialog_options() -> Array:

	return [
		{
			"text": "Sobre o SST",
			"id": "setor"
		},
		{
			"text": "Segurança dos funcionários",
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

			Transicao.mudar_cena("res://scene/fase quiz/TreinamentoSST.tscn")

		"exit":
			DialogManager.end_conversation()


func _on_dialog_completed() -> void:
	super._on_dialog_completed()

func _on_quest_state_changed(quest_id: String) -> void:


	if quest_id == QUEST_ID:
		atualizar_dialogo()
