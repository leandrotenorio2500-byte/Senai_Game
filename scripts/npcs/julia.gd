extends "res://scripts/npc.gd"

var dialogo_empresa: Array[Dictionary]
var dialogo_mapa_risco_explicacao: Array[Dictionary]

# --- Configurações do Comportamento de Seguir ---
@export var follow_speed: float = 100.0   # Velocidade de movimento do NPC
@export var stopping_distance: float = 32.0 # Distância mínima do jogador (para não encavalar)
var offset_y: float = -2.0  # Mantém 2 pixels acima do chão do jogador

var _player_ref: Node2D = null
const QUEST_ID = "identificar_riscos"

func _ready() -> void:
	npc_name = "Michele"
	npc_faceset_path = "res://sprites/Mini UI/heads/Michele.png"

	idle_spritesheet = load("res://sprites/npcs/coroa2.png")
	# Atribua a animação de corrida adequada caso possua a spritesheet:
	# run_spritesheet = load("res://sprites/npcs/michele-run.png")
	hframes = 8

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

func _init_follow():
	await get_tree().process_frame
	await get_tree().process_frame

	_player_ref = get_tree().get_first_node_in_group("Player")

	if Globals.michele_seguindo:
		_interact_label.hide()
		_aparecer_perto_do_player()

func _aparecer_perto_do_player():
	if _player_ref == null:
		_player_ref = get_tree().get_first_node_in_group("Player")

	if _player_ref == null:
		return

	global_position = _player_ref.global_position + Vector2(-32, offset_y)
	play_idle()

func _physics_process(delta: float) -> void:
	if Globals.michele_seguindo:
		if _player_ref == null:
			_player_ref = get_tree().get_first_node_in_group("Player")
			return

		_seguir_jogador(delta)

# --------------------------------------------------
# LÓGICA DE ACOMPANHAR O JOGADOR
# --------------------------------------------------

func _player_esta_agachado_ou_deslizando() -> bool:
	if _player_ref != null and "status" in _player_ref:
		var p_status = _player_ref.status
		if p_status == _player_ref.PlayerState.duck or p_status == _player_ref.PlayerState.slide:
			return true
	return false

func _seguir_jogador(delta: float) -> void:
	if _player_ref == null:
		return

	# Mantém Michele na mesma altura do jogador
	if _player_ref.is_on_floor() and not _player_esta_agachado_ou_deslizando():
		global_position.y = lerp(
			global_position.y,
			_player_ref.global_position.y + offset_y,
			12.0 * delta
		)

	# Por padrão, mantém o lado atual
	var alvo_x = global_position.x

	# Só muda de lado se o jogador realmente estiver andando
	if abs(_player_ref.velocity.x) > 5:
		if _player_ref.anim.flip_h:
			alvo_x = _player_ref.global_position.x + stopping_distance
		else:
			alvo_x = _player_ref.global_position.x - stopping_distance

	# Aproxima suavemente
	var posicao_antiga = global_position.x

	global_position.x = move_toward(
		global_position.x,
		alvo_x,
		90.0 * delta
	)

	var velocidade = global_position.x - posicao_antiga

	if abs(velocidade) > 0.05:
		play_run()

		if velocidade < 0:
			look_left()
		else:
			look_right()
	else:
		play_idle()

func iniciar_michele():

	npc_faceset_path = "res://sprites/Mini UI/heads/Michele.png"
	idle_spritesheet = load("res://sprites/npcs/coroa2.png")
# --------------------------------------------------
# CONTROLE DOS DIÁLOGOS
# --------------------------------------------------

func atualizar_dialogo():
	var quest = QuestManager.obter_missao(QUEST_ID)

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
			if QuestManager.obter_estado(QUEST_ID) == "nao_iniciada":
				Globals.michele_seguindo = true
				QuestManager.iniciar_missao(QUEST_ID)
				_interact_label.hide()
				_aparecer_perto_do_player()

			DialogManager.end_conversation()
			
			await get_tree().create_timer(1.5).timeout
			
			Transicao.mudar_cena("res://scene/fase mapa/tutorial/tutorial_mapa.tscn")

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

	var quest = QuestManager.obter_missao(QUEST_ID)

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
	if quest_id == QUEST_ID:
		atualizar_dialogo()

		if Globals.michele_seguindo:
			_aparecer_perto_do_player()
