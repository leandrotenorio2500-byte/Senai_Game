extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Daniel"

func _on_dialog_completed() -> void:

	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")
	var estado_chamados = QuestManager.obter_estado("atender_chamados")
	# ==================================
	# MISSÃO MAPA DE RISCO
	# ==================================
	if estado_mapa == "em_andamento":
		
		if not Globals.setores_desbloqueados.get("Tecnico", false):
			Globals.desbloquear_setor("Tecnico")
			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Tecnico"}
			)
			Globals.abrir_mapa.emit()
		return
	# ==================================
	# MISSÃO DO DANIEL
	# ==================================
	if estado_chamados == "nao_iniciada":

		if not _tem_outra_missao_ativa():
			Globals.daniel_seguindo = true
			QuestManager.iniciar_missao("atender_chamados")
			_interact_label.hide()
			_aparecer_perto_do_player()
			
# --- Configurações do Comportamento de Seguir ---
@export var follow_speed: float = 100.0   # Velocidade de movimento do NPC
@export var stopping_distance: float = 32.0 # Distância mínima do jogador (para não encavalar)
var offset_y: float = -2.0  # Mantém 2 pixels acima do chão do jogador

var _player_ref: Node2D = null
const QUEST_ID = "atender_chamados"

func _ready() -> void:
	idle_spritesheet = load("res://sprites/npcs/npc_ti.png")
	run_spritesheet = load("res://sprites/npcs/daniel-run.png")
	
	# Conecta aos sinais da missão de chamados
	var quest_chamados = QuestManager.obter_missao(QUEST_ID)
	if quest_chamados:
		if not quest_chamados.iniciada.is_connected(_on_quest_state_changed):
			quest_chamados.iniciada.connect(_on_quest_state_changed)
		if not quest_chamados.em_andamento.is_connected(_on_quest_state_changed):
			quest_chamados.em_andamento.connect(_on_quest_state_changed)
		if not quest_chamados.finalizada.is_connected(_on_quest_state_changed):
			quest_chamados.finalizada.connect(_on_quest_state_changed)
	
	atualizar_dialogo()

	super._ready()
	call_deferred("_init_follow")

func _init_follow():

	await get_tree().process_frame
	await get_tree().process_frame

	_player_ref = get_tree().get_first_node_in_group("Player")

	if Globals.daniel_seguindo:
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

	if Globals.daniel_seguindo:

		if _player_ref == null:
			_player_ref = get_tree().get_first_node_in_group("Player")
			return

		_seguir_jogador(delta)

func _tem_outra_missao_ativa() -> bool:
	for q_id in QuestManager.missoes.keys():
		if q_id != QUEST_ID:
			if QuestManager.obter_estado(q_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")
	var estado_chamados = QuestManager.obter_estado("atender_chamados")

	if estado_mapa == "em_andamento":
		dialogo_mapa_risco()
		return

	if estado_chamados == "nao_iniciada":
		dialogo_inicio_chamados()
		return

	if estado_chamados == "em_andamento":
		dialogo_chamados_andamento()
		return

	if estado_chamados == "finalizada":
		dialogo_chamados_finalizada()
		
func _on_quest_state_changed(quest_id_sinal: String) -> void:
	if quest_id_sinal == QUEST_ID:
		atualizar_dialogo()

		if Globals.daniel_seguindo:
			_aparecer_perto_do_player()

# --- LÓGICA DE ACOMPANHAR O JOGADOR ---

func _player_esta_agachado_ou_deslizando() -> bool:
	if _player_ref != null and "status" in _player_ref:
		var p_status = _player_ref.status
		if p_status == _player_ref.PlayerState.duck or p_status == _player_ref.PlayerState.slide:
			return true
	return false

func _seguir_jogador(delta: float) -> void:

	if _player_ref == null:
		return

	# Mantém Daniel na mesma altura do jogador
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
		
func iniciar_daniel():

	idle_spritesheet = load("res://sprites/npcs/npc_ti.png")
	run_spritesheet = load("res://sprites/npcs/daniel-run.png")

func dialogo_mapa_risco():
	
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Oi! Eu sou responsável pelo setor de TI. Sempre que algum computador ou equipamento apresenta problemas, é aqui que ele vem parar.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Além de trabalhar com equipamentos eletrônicos, precisamos ter atenção com energia elétrica, organização dos cabos e manutenção dos aparelhos.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Observe bem o setor e identifique os riscos encontrados por aqui.",
			"faceset": npc_faceset_path
		}
	]
	
func dialogo_inicio_chamados():
	if _tem_outra_missao_ativa():
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Percebi que você já está ocupado com outra tarefa no momento.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Termine o que está fazendo primeiro e depois volte aqui para falarmos sobre os chamados!",
				"faceset": npc_faceset_path
			}
		]
		return

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Como seu primeiro momento aqui no T.I iremos atender a alguns chamados nos setores.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Vamos nessa!",
			"faceset": npc_faceset_path
		}
	]
	
func dialogo_chamados_andamento():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Verifique com o pessoal nos setores quais máquinas estão com problema e busque as peças na bancada!",
			"faceset": npc_faceset_path
		}
	]
	
func dialogo_chamados_finalizada():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
			"faceset": npc_faceset_path
		}
	]
