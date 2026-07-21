extends "res://scripts/npc.gd"

# --- CONFIGURAÇÃO DO TELEPORTE DIRETO NO INSPETOR ---
@export_file("*.tscn") var next_level: String = "res://scene/fase quiz/estacao1.tscn"
@export var next_player_position: Vector2 = Vector2(0.0, 147.0)

var npc_faceset_path = "res://sprites/npcs/npc8_dialog.png"
var npc_name = "Manoela"
var quiz_epi_ja_conversou = false

func _ready() -> void:
	spritesheet = load("res://sprites/npcs/npc8.png")
	hframes = 8
	
	# Conecta aos sinais globais do QuestManager
	QuestManager.quest_started.connect(_on_quest_state_changed)
	QuestManager.quest_updated.connect(_on_quest_state_changed)
	QuestManager.quest_completed.connect(_on_quest_state_changed)
	
	# Garante a atualização assim que o NPC entra na árvore de cena
	tree_entered.connect(atualizar_dialogo)
	
	atualizar_dialogo()
	super._ready()

func atualizar_dialogo() -> void:
	var missao = QuestManager.missao_atual
	
	# SE A MISSÃO DO QUIZ ESTÁ ATIVA E EM ANDAMENTO
	if missao and missao.id == "quiz_epi" and (missao.estado_atual == "iniciada" or missao.estado_atual == "em_andamento"):
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Lembre-se, você precisa responder corretamente qual EPI é o correto.",
				"faceset": npc_faceset_path
			}
		]
	
	# SE A MISSÃO DO QUIZ É A ATUAL E ESTÁ PENDENTE (O jogador veio falar com ela na hora certa)
	elif missao and missao.id == "quiz_epi" and missao.estado_atual == "pendente":
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Opa, tudo bem? Seja muito bem-vindo ao almoxarifado!",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Agora irei te mostrar como funcionam os EPIs.",
				"faceset": npc_faceset_path
			},
		]
		
	# SE A MISSÃO DO QUIZ JÁ PASSOU OU ESTÁ CONCLUÍDA
	elif missao == null or quiz_epi_ja_conversou:
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Parabéns, você completou as missões!!!",
				"faceset": npc_faceset_path
			}
		]
	

func _on_quest_state_changed(_quest_id: String) -> void:
	atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()
	
	var missao = QuestManager.missao_atual
	
	# Só avança a missão e teleporta se ela REALMENTE estava pendente
	# E se o diálogo carregado na Manoela era o correto do Quiz (com as 2 falas)
	if missao and missao.id == "quiz_epi" and missao.estado_atual == "pendente" and not quiz_epi_ja_conversou:
		if dialog_data.size() > 1: 
			_quiz_epi_marcar_conversado()
			executar_teleporte()
		else:
			print("Teleporte evitado: O diálogo ativo ainda era o texto de bloqueio da Julia.")

func _quiz_epi_marcar_conversado():
	var missao = QuestManager.missao_atual
	if missao and missao.id == "quiz_epi" and missao.estado_atual == "pendente":
		quiz_epi_ja_conversou = true
		missao.iniciar()

func executar_teleporte() -> void:
	if next_level != "":
		Globals.next_player_position = next_player_position
		Globals.should_position = true
		call_deferred("mudar_de_cena")
	else:
		push_warning("Aviso: 'next_level' não foi definido no script da Manoela!")

func mudar_de_cena() -> void:
	Transicao.mudar_cena(next_level)
