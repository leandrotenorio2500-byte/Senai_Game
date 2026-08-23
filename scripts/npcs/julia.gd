extends "res://scripts/npc.gd"


# ============================================================
# CONFIGURAÇÕES
# ============================================================

var dialogo_empresa: Array[Dictionary]
var dialogo_mapa_risco_explicacao: Array[Dictionary]

const QUEST_ID := "identificar_riscos"

@export var follow_speed: float = 100.0
@export var stopping_distance: float = 32.0

var offset_y: float = -2.0
var _player_ref: Node2D = null
var _olhando_para_esquerda := false


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	npc_name = "Michele"
	npc_faceset_path = "res://sprites/Mini UI/heads/Michele.png"

	idle_spritesheet = load("res://sprites/npcs/coroa3.png")


	run_spritesheet = load("res://sprites/npcs/coroa-run.png")

	hframes = 8

	# --------------------------------------------------------
	# CONECTA AOS SINAIS DA MISSÃO
	# --------------------------------------------------------

	var quest_riscos = QuestManager.obter_missao(QUEST_ID)

	if quest_riscos:

		if not quest_riscos.iniciada.is_connected(_on_quest_state_changed):
			quest_riscos.iniciada.connect(_on_quest_state_changed)

		if not quest_riscos.em_andamento.is_connected(_on_quest_state_changed):
			quest_riscos.em_andamento.connect(_on_quest_state_changed)

		if not quest_riscos.finalizada.is_connected(_on_quest_state_changed):
			quest_riscos.finalizada.connect(_on_quest_state_changed)

	atualizar_dialogo()

	super._ready()

	call_deferred("_init_follow")



# ============================================================
# INICIALIZAÇÃO DA MICHELE
# ============================================================

func iniciar_michele() -> void:

	npc_name = "Michele"

	npc_faceset_path = "res://sprites/Mini UI/heads/Michele.png"

	idle_spritesheet = load("res://sprites/npcs/coroa3.png")
	run_spritesheet = load("res://sprites/npcs/coroa-run.png")
	hframes = 8

	_apply_animations()
# ============================================================
# ATUALIZAÇÃO DOS DIÁLOGOS
# ============================================================

func atualizar_dialogo() -> void:

	var quest = QuestManager.obter_missao(QUEST_ID)


	# --------------------------------------------------------
	# MAPA PRONTO PARA ENTREGA
	# --------------------------------------------------------

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


	# --------------------------------------------------------
	# ESTADO GERAL DA MISSÃO
	# --------------------------------------------------------

	var estado = QuestManager.obter_estado(QUEST_ID)


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


# ============================================================
# OPÇÕES DE DIÁLOGO
# ============================================================

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


# ============================================================
# OPÇÃO SELECIONADA
# ============================================================

func on_dialog_option_selected(option: Dictionary) -> void:

	match option.id:

		# ----------------------------------------------------
		# SOBRE O MAPA
		# ----------------------------------------------------

		"mapa":

			DialogManager.show_dialog(
				get_dialogo_mapa()
			)


		# ----------------------------------------------------
		# SOBRE A EMPRESA
		# ----------------------------------------------------

		"empresa":

			DialogManager.show_dialog(
				get_dialogo_empresa()
			)


		# ----------------------------------------------------
		# INICIAR MISSÃO
		# ----------------------------------------------------

		"missao":

			if QuestManager.obter_estado(QUEST_ID) == "nao_iniciada":

				# Primeiro inicia a missão
				QuestManager.iniciar_missao(QUEST_ID)


				# Michele deixa de ser uma NPC interativa
				_interact_label.hide()

				# Já posiciona Michele próxima ao jogador
				#_aparecer_perto_do_player()


			DialogManager.end_conversation()

			await get_tree().create_timer(1.5).timeout

			Transicao.mudar_cena(
				"res://scene/tutorials/tutorial_mapa.tscn"
			)


		# ----------------------------------------------------
		# ENCERRAR
		# ----------------------------------------------------

		"exit":

			DialogManager.end_conversation()


# ============================================================
# DIÁLOGOS EXTRAS
# ============================================================

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


# ============================================================
# FINALIZAÇÃO DO DIÁLOGO
# ============================================================

func _on_dialog_completed() -> void:

	super._on_dialog_completed()

	var quest = QuestManager.obter_missao(QUEST_ID)

	if quest == null:
		return


	# --------------------------------------------------------
	# MAPA TERMINADO
	# --------------------------------------------------------

	if quest.etapa_atual == QuestIdentificarRiscos.Etapa.AGUARDANDO_ENTREGA:

		print("Michele iniciou avaliação do mapa.")

		quest.entregar_mapa()

		await get_tree().create_timer(0.2).timeout

		atualizar_dialogo()


# ============================================================
# MUDANÇA DE ESTADO DA MISSÃO
# ============================================================

func _on_quest_state_changed(quest_id: String) -> void:

	if quest_id != QUEST_ID:
		return

	var quest = QuestManager.obter_missao(QUEST_ID)

	if quest == null:
		return


	# --------------------------------------------------------
	# TERMINOU O LEVANTAMENTO
	# --------------------------------------------------------



	# --------------------------------------------------------
	# ATUALIZA DIÁLOGO
	# --------------------------------------------------------

	atualizar_dialogo()


	# --------------------------------------------------------
	# SE AINDA ESTIVER ACOMPANHANDO,
	# GARANTE QUE FIQUE PERTO DO PLAYER
	# --------------------------------------------------------

	#if Globals.michele_seguindo:

		#_aparecer_perto_do_player()
