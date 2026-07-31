extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Daniel"

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Tecnico", false):
		Globals.desbloquear_setor("Tecnico")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Tecnico"})
		Globals.abrir_mapa.emit()
# --- Configurações do Comportamento de Seguir ---
@export var follow_speed: float = 100.0   # Velocidade de movimento do NPC
@export var stopping_distance: float = 32.0 # Distância mínima do jogador (para não encavalar)
var offset_y: float = -2.0  # Mantém 2 pixels acima do chão do jogador

var _player_ref: Node2D = null
const QUEST_ID = "atender_chamados"

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/npc_ti.png")
	hframes = 8
	
	# Busca o Jogador na cena
	_player_ref = get_tree().get_first_node_in_group("Player") as Node2D
	
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
	_verificar_posicionamento_inicial()
	super._ready()

func _physics_process(delta: float) -> void:
	# Executa o acompanhamento apenas se a missão estiver ativa e o setor Técnico liberado
	var estado = QuestManager.obter_estado(QUEST_ID)
	if estado == "em_andamento" and _player_ref != null and Globals.setores_desbloqueados.get("Tecnico", false):
		_seguir_jogador(delta)

func _tem_outra_missao_ativa() -> bool:
	for q_id in QuestManager.missoes.keys():
		if q_id != QUEST_ID:
			if QuestManager.obter_estado(q_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo() -> void:
	# PASSO 1: Fala de introdução e riscos do setor de TI
	if not Globals.setores_desbloqueados.get("Tecnico", false):
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Oi! Eu sou responsável pelo setor de TI. Sempre que algum computador ou equipamento apresenta problemas, é aqui que ele vem parar.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Além de trabalhar com computadores ligados à energia elétrica, às vezes precisamos abrir equipamentos, trocar componentes e organizar muitos cabos.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Cabos espalhados pelo chão podem provocar tropeços, então manter tudo organizado é uma questão de segurança.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Quem trabalha com manutenção também precisa ter bastante atenção antes de mexer em qualquer equipamento energizado.",
				"faceset": npc_faceset_path
			}
		]
		return

	# PASSO 2: Diálogos da missão "atender_chamados" após o setor liberado
	var estado = QuestManager.obter_estado(QUEST_ID)

	if _tem_outra_missao_ativa() and estado == "nao_iniciada":
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
	elif estado == "finalizada":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
				"faceset": npc_faceset_path
			}
		]
	elif estado == "em_andamento":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Verifique com o pessoal nos setores quais máquinas estão com problema e busque as peças na bancada!",
				"faceset": npc_faceset_path
			}
		]
	else: # "nao_iniciada"
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

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	# 1. Liberação inicial do setor Técnico (Missão: identificar_riscos)
	if not Globals.setores_desbloqueados.get("Tecnico", false):
		Globals.desbloquear_setor("Tecnico")
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Tecnico"})
		atualizar_dialogo()
		return

	# 2. Inicia a missão de atendimentos de chamados se estiver liberada
	var estado = QuestManager.obter_estado(QUEST_ID)
	if estado == "nao_iniciada" and not _tem_outra_missao_ativa():
		QuestManager.iniciar_missao(QUEST_ID)
		_verificar_posicionamento_inicial()

func _on_quest_state_changed(quest_id_sinal: String) -> void:
	if quest_id_sinal == QUEST_ID:
		atualizar_dialogo()
		_verificar_posicionamento_inicial()

# --- LÓGICA DE ACOMPANHAR O JOGADOR ---

func _player_esta_agachado_ou_deslizando() -> bool:
	if _player_ref != null and "status" in _player_ref:
		var p_status = _player_ref.status
		if p_status == _player_ref.PlayerState.duck or p_status == _player_ref.PlayerState.slide:
			return true
	return false

func _verificar_posicionamento_inicial() -> void:
	var estado = QuestManager.obter_estado(QUEST_ID)
	if estado == "em_andamento" and _player_ref != null:
		global_position.x = _player_ref.global_position.x - 32.0
		global_position.y = _player_ref.global_position.y + offset_y

func _seguir_jogador(delta: float) -> void:
	if _player_ref.is_on_floor() and not _player_esta_agachado_ou_deslizando():
		global_position.y = _player_ref.global_position.y + offset_y

	var dist_x = _player_ref.global_position.x - global_position.x
	
	if abs(dist_x) > stopping_distance:
		var direction_x = sign(dist_x)
		global_position.x += direction_x * follow_speed * delta
		
		if _sprite and not _sprite.is_playing():
			_sprite.play("idle")
		
		if direction_x != 0 and _sprite:
			_sprite.flip_h = (direction_x < 0)
