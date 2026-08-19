extends "res://scripts/npc.gd"


func get_dialogo_setor() -> Array[Dictionary]:
	return [
		{
			"title": npc_name,
			"dialog": "O setor de TI é responsável por manter computadores, impressoras, rede e demais equipamentos funcionando corretamente.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Quando algum equipamento apresenta defeito, somos nós que fazemos o diagnóstico e realizamos a manutenção.",
			"faceset": npc_faceset_path
		}
	]


func get_dialogo_funcionarios() -> Array[Dictionary]:
	return [
		{
			"title": npc_name,
			"dialog": "Aqui trabalham técnicos responsáveis por manutenção, instalação de equipamentos e suporte aos demais setores.",
			"faceset": npc_faceset_path
		}
	]


func _on_dialog_completed():

	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Tecnico", false):
			Globals.desbloquear_setor("Tecnico")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Tecnico"}
			)

			Globals.abrir_mapa.emit()


# ============================================================
# CONFIGURAÇÕES DO COMPORTAMENTO DE SEGUIR
# ============================================================

@export var follow_speed: float = 100.0
@export var stopping_distance: float = 32.0

var offset_y: float = -2.0

var _player_ref: Node2D = null


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	npc_faceset_path = "res://sprites/Mini UI/heads/Daniel.png"
	npc_name = "Daniel - Líder do TI"

	idle_spritesheet = load("res://sprites/npcs/npc_ti.png")
	run_spritesheet = load("res://sprites/npcs/daniel-run.png")

	atualizar_dialogo()

	super._ready()

	call_deferred("_init_follow")


# ============================================================
# INICIALIZAÇÃO DO SEGUIMENTO
# ============================================================

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


# ============================================================
# PHYSICS
# ============================================================

func _physics_process(delta: float) -> void:

	if Globals.daniel_seguindo:

		if _player_ref == null:
			_player_ref = get_tree().get_first_node_in_group("Player")
			return

		_seguir_jogador(delta)


# ============================================================
# ATUALIZAÇÃO DO DIÁLOGO
# ============================================================

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":
		dialogo_mapa_risco()
		return

	dialogo_normal()


# ============================================================
# LÓGICA DE ACOMPANHAR O JOGADOR
# ============================================================

func _player_esta_agachado_ou_deslizando() -> bool:

	if _player_ref != null and "status" in _player_ref:

		var p_status = _player_ref.status

		if p_status == _player_ref.PlayerState.duck \
		or p_status == _player_ref.PlayerState.slide:
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


# ============================================================
# INICIALIZAÇÃO DO DANIEL
# ============================================================

func iniciar_daniel():

	idle_spritesheet = load("res://sprites/npcs/npc_ti.png")
	run_spritesheet = load("res://sprites/npcs/daniel-run.png")


# ============================================================
# DIÁLOGO — MAPA DE RISCO
# ============================================================

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


# ============================================================
# DIÁLOGO NORMAL
# ============================================================

func dialogo_normal():

	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Eu sou Daniel e sou responsável pelo setor de TI.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de alguma informação sobre o setor, pode falar comigo.",
			"faceset": npc_faceset_path
		}
	]


# ============================================================
# OPÇÕES DE DIÁLOGO
# ============================================================

func get_dialog_options() -> Array:

	return [
		{
			"text": "Sobre o setor",
			"id": "setor"
		},
		{
			"text": "Funcionários",
			"id": "funcionarios"
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

		"setor":
			DialogManager.show_dialog(
				get_dialogo_setor()
			)

		"funcionarios":
			DialogManager.show_dialog(
				get_dialogo_funcionarios()
			)
		"missao":
			DialogManager.end_conversation()
			
			await get_tree().create_timer(0.5).timeout

			Transicao.mudar_cena("res://scene/fase chamados/bancada_funcionario.tscn")

		"exit":
			DialogManager.end_conversation()
