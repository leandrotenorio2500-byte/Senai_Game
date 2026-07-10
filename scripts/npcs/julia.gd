extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc6_dialog.png"
var npc_name = "Julia"

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/npc6.png")
	hframes = 8
	
	# Conecta aos novos sinais polimórficos do QuestManager
	QuestManager.quest_started.connect(_on_quest_state_changed)
	QuestManager.quest_updated.connect(_on_quest_state_changed)
	QuestManager.quest_completed.connect(_on_quest_state_changed)
	
	# Define o diálogo inicial com base no estado atual do jogo
	atualizar_dialogo()
	
	super._ready()
	
func atualizar_dialogo() -> void:
	var missao = QuestManager.missao_atual
	
	# CASO 1: Se não há missão ativa OU a missão atual já é OUTRA, significa que a de riscos foi concluída
	if missao == null or missao.id != "identificar_riscos":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Parabéns, você completou a primeira missão!!!",
				"faceset": npc_faceset_path
			}
		]
	
	# CASO 2: A missão de riscos está ativa e o jogador já está trabalhando nela
	elif missao.id == "identificar_riscos" and (missao.estado_atual == "iniciada" or missao.estado_atual == "em_andamento"):
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Lembre-se, você precisa identificar os 3 pontos de riscos no ambiente.",
				"faceset": npc_faceset_path
			}
		]
	
	# CASO 3: A missão ainda está pendente (estado inicial, antes de conversar com ela)
	else:
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Opa, tudo bem? Seja muito bem-vindo!",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Você está dando os seus primeiros passos na empresa e nós iremos te apresentar como tudo funciona por aqui.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Mas antes, eu vou precisar de um favor: que você identifique 3 pontos de risco no nosso ambiente.",
				"faceset": npc_faceset_path
			}
		]

# Unificamos as respostas de sinal, já que no novo QuestManager todos os sinais passam apenas o (quest_id)
func _on_quest_state_changed(quest_id: String) -> void:
	if quest_id == "identificar_riscos":
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()
	_identificar_riscos_marcar_conversado()

var identificar_riscos_ja_conversou = false

func _identificar_riscos_marcar_conversado():
	var missao = QuestManager.missao_atual
	
	# Se a missão de riscos for a atual e ainda estiver como "pendente", nós não precisamos forçar o início manual aqui! 
	# Lembra que no QuestManager novo, ao puxar a missão para a fila, ela já dá .iniciar() automaticamente?
	# Se você quiser que ela SÓ comece após o diálogo da Julia, basta tirar o `missao_atual.iniciar()` do 
	# método `_avancar_proxima_missao` do seu QuestManager e chamar ele aqui assim:
	
	if missao and missao.id == "identificar_riscos" and missao.estado_atual == "pendente":
		missao.iniciar()
