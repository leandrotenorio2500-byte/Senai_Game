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
# INICIALIZAÇÃO DO SEGUIMENTO
# ============================================================

func _init_follow() -> void:

	await get_tree().process_frame
	await get_tree().process_frame

	_player_ref = get_tree().get_first_node_in_group("Player")

	if Globals.michele_seguindo:

		_interact_label.hide()

		_aparecer_perto_do_player()


func _aparecer_perto_do_player() -> void:

	if _player_ref == null:
		_player_ref = get_tree().get_first_node_in_group("Player")

	if _player_ref == null:
		return

	global_position = _player_ref.global_position + Vector2(-32, offset_y)

	play_idle()


# ============================================================
# PHYSICS
# ============================================================

func _physics_process(delta: float) -> void:

	if not Globals.michele_seguindo:
		return

	if _player_ref == null:
		_player_ref = get_tree().get_first_node_in_group("Player")

		if _player_ref == null:
			return

	_seguir_jogador(delta)


# ============================================================
# VERIFICAÇÃO DO ESTADO DO PLAYER
# ============================================================

func _player_esta_agachado_ou_deslizando() -> bool:

	if _player_ref == null:
		return false

	if "status" not in _player_ref:
		return false

	var p_status = _player_ref.status

	if p_status == _player_ref.PlayerState.duck \
	or p_status == _player_ref.PlayerState.slide:

		return true

	return false


# ============================================================
# SEGUIR JOGADOR
# ============================================================

func _seguir_jogador(delta: float) -> void:

	if _player_ref == null:
		return


	# --------------------------------------------------------
	# ALTURA
	# --------------------------------------------------------

	if _player_ref.is_on_floor() \
	and not _player_esta_agachado_ou_deslizando():

		global_position.y = lerp(
			global_position.y,
			_player_ref.global_position.y + offset_y,
			12.0 * delta
		)


	# --------------------------------------------------------
	# POSIÇÃO HORIZONTAL
	# --------------------------------------------------------

	var alvo_x := global_position.x


	# Só troca de lado quando o jogador estiver andando
	if abs(_player_ref.velocity.x) > 5:

		if _player_ref.anim.flip_h:

			alvo_x = _player_ref.global_position.x + stopping_distance

		else:

			alvo_x = _player_ref.global_position.x - stopping_distance


	# --------------------------------------------------------
	# MOVIMENTO
	# --------------------------------------------------------

	var posicao_antiga := global_position.x

	global_position.x = move_toward(
		global_position.x,
		alvo_x,
		follow_speed * delta
	)


	# --------------------------------------------------------
	# ANIMAÇÃO
	# --------------------------------------------------------

	var velocidade := global_position.x - posicao_antiga


	if abs(velocidade) > 0.05:

		# ----------------------------------------------------
		# MICHELE ESTÁ ANDANDO
		# ----------------------------------------------------

		if velocidade < 0:

			_olhando_para_esquerda = true

		else:

			_olhando_para_esquerda = false


		play_run()


	else:

		# ----------------------------------------------------
		# MICHELE ESTÁ PARADA
		# ----------------------------------------------------

		play_idle()


	# --------------------------------------------------------
	# CORRIGE A ORIENTAÇÃO DE CADA SPRITESHEET
	# --------------------------------------------------------

	if _sprite.animation == "idle":

		# Idle original olha para a esquerda
		if _olhando_para_esquerda:
			_sprite.flip_h = false
		else:
			_sprite.flip_h = true


	elif _sprite.animation == "run":

		# Run original olha para a direita
		if _olhando_para_esquerda:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false


		# --------------------------------------------------------
		# MANTÉM A DIREÇÃO ATUAL
		# --------------------------------------------------------

		if _olhando_para_esquerda:
			look_left()
		else:
			look_right()

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

				# Depois ativa o acompanhamento
				Globals.michele_seguindo = true

				# Michele deixa de ser uma NPC interativa
				_interact_label.hide()

				# Já posiciona Michele próxima ao jogador
				_aparecer_perto_do_player()


			DialogManager.end_conversation()

			await get_tree().create_timer(1.5).timeout

			Transicao.mudar_cena(
				"res://scene/fase mapa/tutorial/tutorial_mapa.tscn"
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

	if quest.etapa_atual == QuestIdentificarRiscos.Etapa.AGUARDANDO_ENTREGA:

		# Michele deixa de acompanhar o jogador.
		# Agora ele precisa voltar até ela.
		Globals.michele_seguindo = false


	# --------------------------------------------------------
	# ATUALIZA DIÁLOGO
	# --------------------------------------------------------

	atualizar_dialogo()


	# --------------------------------------------------------
	# SE AINDA ESTIVER ACOMPANHANDO,
	# GARANTE QUE FIQUE PERTO DO PLAYER
	# --------------------------------------------------------

	if Globals.michele_seguindo:

		_aparecer_perto_do_player()
