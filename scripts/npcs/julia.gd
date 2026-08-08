extends "res://scripts/npc.gd"

var dialogo_empresa: Array[Dictionary]

var dialogo_mapa_risco_explicacao: Array[Dictionary]


func _ready() -> void:

	npc_name = "Michele"
	npc_faceset_path = "res://sprites/Mini UI/heads/Michele.png"

	idle_spritesheet = load("res://sprites/npcs/coroa2.png")
	hframes = 8


	var quest_riscos = QuestManager.obter_missao("identificar_riscos")

	if quest_riscos:

		if not quest_riscos.iniciada.is_connected(_on_quest_state_changed):
			quest_riscos.iniciada.connect(_on_quest_state_changed)

		if not quest_riscos.em_andamento.is_connected(_on_quest_state_changed):
			quest_riscos.em_andamento.connect(_on_quest_state_changed)

		if not quest_riscos.finalizada.is_connected(_on_quest_state_changed):
			quest_riscos.finalizada.connect(_on_quest_state_changed)


	atualizar_dialogo()


	super._ready()



# --------------------------------------------------
# CONTROLE DOS DIÁLOGOS
# --------------------------------------------------

func atualizar_dialogo():

	var quest = QuestManager.obter_missao("identificar_riscos")


	# Caso o mapa esteja pronto para avaliação
	if quest:

		if quest.etapa_atual == QuestIdentificarRiscos.Etapa.AGUARDANDO_ENTREGA:

			dialog_data = [
				{
					"title": npc_name,
					"dialog": "Muito bem! Você terminou o levantamento dos setores. Vou analisar o mapa de riscos agora.",
					"faceset": npc_faceset_path
				}
			]

			return



	var estado = QuestManager.obter_estado("identificar_riscos")


	if estado == "finalizada":

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Excelente trabalho! O mapa de riscos foi aprovado. Agora podemos seguir para a próxima etapa do seu treinamento.",
				"faceset": npc_faceset_path
			}
		]


	elif estado == "em_andamento":

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Continue analisando os setores e preenchendo o mapa de risco. Quando terminar, volte para conversarmos.",
				"faceset": npc_faceset_path
			}
		]


	else:

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá! Seja muito bem-vindo à empresa.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Antes de começar suas atividades, você precisa conhecer melhor os riscos presentes nos setores.",
				"faceset": npc_faceset_path
			}
		]



# --------------------------------------------------
# OPÇÕES DE DIÁLOGO
# --------------------------------------------------

func get_dialog_options() -> Array:

	return [

		{
			"text": "Sobre o mapa de risco",
			"id": "mapa"
		},

		{
			"text": "Sobre a empresa",
			"id": "empresa"
		},

		{
			"text": "Iniciar missão",
			"id": "missao"
		},

		{
			"text": "Encerrar",
			"id": "exit"
		}

	]



func on_dialog_option_selected(option: Dictionary) -> void:


	match option.id:


		"mapa":

			DialogManager.show_dialog(get_dialogo_mapa())


		"empresa":

			DialogManager.show_dialog(get_dialogo_empresa())


		"missao":

			if QuestManager.obter_estado("identificar_riscos") == "nao_iniciada":

				QuestManager.iniciar_missao("identificar_riscos")


			DialogManager.end_conversation()


		"exit":

			DialogManager.end_conversation()



# --------------------------------------------------
# DIÁLOGOS EXTRAS
# --------------------------------------------------

func get_dialogo_mapa() -> Array[Dictionary]:

	return [

		{
			"title": npc_name,
			"dialog": "O mapa de risco é uma ferramenta utilizada para identificar perigos presentes nos ambientes de trabalho.",
			"faceset": npc_faceset_path
		},

		{
			"title": npc_name,
			"dialog": "Ele ajuda os funcionários a entenderem os riscos e adotarem medidas para evitar acidentes.",
			"faceset": npc_faceset_path
		}

	]



func get_dialogo_empresa() -> Array[Dictionary]:

	return [

		{
			"title": npc_name,
			"dialog": "Nossa empresa possui diversos setores, cada um com suas próprias atividades e responsabilidades.",
			"faceset": npc_faceset_path
		},

		{
			"title": npc_name,
			"dialog": "Durante seu treinamento, você conhecerá cada área e aprenderá como trabalhar com segurança.",
			"faceset": npc_faceset_path
		}

	]



# --------------------------------------------------
# FINALIZAÇÃO DO DIÁLOGO
# --------------------------------------------------

func _on_dialog_completed() -> void:

	super._on_dialog_completed()


	var quest = QuestManager.obter_missao("identificar_riscos")


	if quest == null:
		return


	# Se terminou o mapa, avalia automaticamente
	if quest.etapa_atual == QuestIdentificarRiscos.Etapa.AGUARDANDO_ENTREGA:

		print("Michele iniciou avaliação do mapa.")

		quest.entregar_mapa()


		await get_tree().create_timer(0.2).timeout


		atualizar_dialogo()



# --------------------------------------------------
# ATUALIZA QUANDO A MISSÃO MUDA
# --------------------------------------------------

func _on_quest_state_changed(quest_id: String) -> void:

	if quest_id == "identificar_riscos":

		atualizar_dialogo()
