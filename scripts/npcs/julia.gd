extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/julia_dialog.png"
var npc_name = "Julia"

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/julia.png")
	hframes = 8
	
	QuestManager.quest_started.connect(_on_quest_state_changed)
	QuestManager.quest_updated.connect(_on_quest_state_changed_alt)
	QuestManager.quest_completed.connect(_on_quest_state_changed)
	
	# Define o diálogo inicial com base no estado atual do jogo
	atualizar_dialogo()
	
	super._ready()
	
func atualizar_dialogo() -> void:
	if QuestManager.quests["identificar_riscos"]["completed"]:
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Parabéns, você completou a primeira missão!!!",
				"faceset": npc_faceset_path
			}
		]
	
	elif QuestManager.quests["identificar_riscos"]["started"]:
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Lembre-se, você precisa identificar os 3 pontos de riscos no ambiente.",
				"faceset": npc_faceset_path
			}
		]
	
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

# Funções que respondem aos sinais globais do QuestManager
func _on_quest_state_changed(quest_id: String) -> void:
	if quest_id == "identificar_riscos":
		atualizar_dialogo()

func _on_quest_state_changed_alt(quest_id: String, _step: int) -> void:
	if quest_id == "identificar_riscos":
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	# Chama o comportamento padrão do script pai (emitir o sinal)
	super._on_dialog_completed()
			
	# Executa a sua ação personalizada aqui!
	_identificar_riscos_marcar_conversado()

var identificar_riscos_ja_conversou = false

func _identificar_riscos_marcar_conversado():
	if not identificar_riscos_ja_conversou and not QuestManager.quests["identificar_riscos"]["started"]:
		QuestManager.start_quest("identificar_riscos")
	else:
		pass
