extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/julia_dialog.png"
var npc_name = "Jacson"

# --- Configurações do Comportamento de Seguir ---
@export var follow_speed: float = 100.0   # Velocidade de movimento do NPC
@export var stopping_distance: float = 32.0 # Distância mínima do jogador (para não encavalar)

var _player_ref: Node2D = null

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/npc7.png")
	hframes = 8
	
	# Busca o Jogador na cena
	_player_ref = get_tree().get_first_node_in_group("Player") as Node2D
	
	# Conecta aos sinais da missão
	var quest_riscos = QuestManager.obter_missao("atender_chamados")
	if quest_riscos:
		if not quest_riscos.iniciada.is_connected(_on_quest_state_changed):
			quest_riscos.iniciada.connect(_on_quest_state_changed)
		if not quest_riscos.em_andamento.is_connected(_on_quest_state_changed):
			quest_riscos.em_andamento.connect(_on_quest_state_changed)
		if not quest_riscos.finalizada.is_connected(_on_quest_state_changed):
			quest_riscos.finalizada.connect(_on_quest_state_changed)
	
	# Define o diálogo inicial com base no estado atual
	atualizar_dialogo()
	
	# TELEPORTE INICIAL: Se entrou numa nova cena e a missão está ativa,
	# teleporta o NPC para próximo do jogador imediatamente.
	_verificar_posicionamento_inicial()
	
	super._ready()

func _physics_process(delta: float) -> void:
	# Executa o acompanhamento apenas se a missão estiver ativa
	var estado = QuestManager.obter_estado("atender_chamados")
	if estado == "em_andamento" and _player_ref != null:
		_seguir_jogador(delta)

# Função auxiliar para garantir tipo correto no cálculo
func float_to_vector(pos: Vector2) -> Vector2:
	return pos

# Função auxiliar para verificar se o jogador está ocupado
func _tem_outra_missao_ativa() -> bool:
	for quest_id in QuestManager.missoes.keys():
		if quest_id != "atender_chamados":
			if QuestManager.obter_estado(quest_id) == "em_andamento":
				return true
	return false

func atualizar_dialogo() -> void:
	var estado = QuestManager.obter_estado("atender_chamados")
	
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
				"dialog": "Parabéns, você completou a missão!",
				"faceset": npc_faceset_path
			}
		]
	elif estado == "em_andamento":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Lembre-se, você precisa identificar os 3 pontos de risco no ambiente.",
				"faceset": npc_faceset_path
			}
		]
	else: # "nao_iniciada"
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá, tudo bem? Seja muito bem-vindo!",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Como seu primeiro momento aqui no T.I iremos atender à alguns chamados.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Vamos nessa!",
				"faceset": npc_faceset_path
			}
		]

func _on_quest_state_changed(quest_id: String) -> void:
	if quest_id == "atender_chamados":
		atualizar_dialogo()
		_verificar_posicionamento_inicial()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()
	_atender_chamados_marcar_conversado()

func _atender_chamados_marcar_conversado() -> void:
	var estado = QuestManager.obter_estado("atender_chamados")
	if estado == "nao_iniciada":
		QuestManager.iniciar_missao("atender_chamados")
		


var offset_y: float = -2.0  # Mantém os 2 pixels acima do chão do jogador

# Verifica se o player está agachado ou deslizando
func _player_esta_agachado_ou_deslizando() -> bool:
	if _player_ref != null and "status" in _player_ref:
		var p_status = _player_ref.status
		if p_status == _player_ref.PlayerState.duck or p_status == _player_ref.PlayerState.slide:
			return true
	return false

func _verificar_posicionamento_inicial() -> void:
	var estado = QuestManager.obter_estado("atender_chamados")
	if estado == "em_andamento" and _player_ref != null:
		global_position.x = _player_ref.global_position.x - 32.0
		global_position.y = _player_ref.global_position.y + offset_y

func _seguir_jogador(delta: float) -> void:
	# REGRAS DO EIXO Y:
	# Só atualiza a altura Y se o jogador estiver PISANDO NO CHÃO (não pulando/caindo)
	# E NÃO estiver agachado ou deslizando.
	if _player_ref.is_on_floor() and not _player_esta_agachado_ou_deslizando():
		global_position.y = _player_ref.global_position.y + offset_y

	# Calcula a distância apenas no eixo X (esquerda / direita)
	var dist_x = _player_ref.global_position.x - global_position.x
	
	# Só se move horizontalmente se a distância for maior que a stopping_distance
	if abs(dist_x) > stopping_distance:
		var direction_x = sign(dist_x)
		
		# Move APENAS no eixo X
		global_position.x += direction_x * follow_speed * delta
		
		# Animação
		if _sprite and not _sprite.is_playing():
			_sprite.play("idle")
		
		# Virar o sprite para a esquerda ou direita
		if direction_x != 0 and _sprite:
			_sprite.flip_h = (direction_x < 0)
