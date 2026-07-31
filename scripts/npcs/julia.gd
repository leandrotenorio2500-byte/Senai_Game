extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/julia_dialog.png"
var npc_name = "Julia"

func _ready() -> void:
	idle_spritesheet = load("res://sprites/npcs/coroa2.png")
	hframes = 8
	
	# Se a missão existe no QuestManager, conectamos aos sinais próprios dela
	var quest_riscos = QuestManager.obter_missao("identificar_riscos")
	if quest_riscos:
		quest_riscos.iniciada.connect(_on_quest_state_changed)
		quest_riscos.em_andamento.connect(_on_quest_state_changed)
		quest_riscos.finalizada.connect(_on_quest_state_changed)
	
	# Define o diálogo inicial com base no estado atual da missão
	atualizar_dialogo()
	
	super._ready()

func atualizar_dialogo() -> void:

	var estado = QuestManager.obter_estado("identificar_riscos")
	var quest = QuestManager.obter_missao("identificar_riscos")


	if estado == "finalizada":

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Excelente trabalho! O mapa de riscos ficou muito bem elaborado. Agora podemos seguir para a próxima etapa do seu treinamento.",
				"faceset": npc_faceset_path
			}
		]

	elif estado == "em_andamento":

		if quest.etapa_atual == QuestIdentificarRiscos.Etapa.AGUARDANDO_ENTREGA:

			dialog_data = [
				{
					"title": npc_name,
					"dialog": "Vejo que você concluiu o mapa de riscos. Vamos analisar o resultado.",
					"faceset": npc_faceset_path
				}
			]

		else:

			dialog_data = [
				{
					"title": npc_name,
					"dialog": "Converse com todos os responsáveis pelos setores e registre os riscos encontrados no mapa. Quando terminar, volte para falar comigo.",
					"faceset": npc_faceset_path
				}
			]

	else:

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá, tudo bem? Seja muito bem-vindo!",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Você está dando os seus primeiros passos na empresa e nós iremos te apresentar como tudo funciona por aqui.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Mas antes, preciso que você faça um levantamento dos riscos nos setores da empresa. Converse com os responsáveis e preencha o mapa de risco.",
				"faceset": npc_faceset_path
			}
		]
		
# Função que reage aos sinais da missão
func _on_quest_state_changed(quest_id: String) -> void:
	if quest_id == "identificar_riscos":
		atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var quest = QuestManager.obter_missao("identificar_riscos")

	if quest == null:
		return

	# Primeira conversa
	if QuestManager.obter_estado("identificar_riscos") == "nao_iniciada":
		_identificar_riscos_marcar_conversado()
		return

	# Entrega do mapa
	if quest.etapa_atual == QuestIdentificarRiscos.Etapa.AGUARDANDO_ENTREGA:
		quest.entregar_mapa()

func _identificar_riscos_marcar_conversado() -> void:
	var estado = QuestManager.obter_estado("identificar_riscos")
	
	# Se a missão ainda não começou, inicia ela ao terminar a conversa
	if estado == "nao_iniciada":
		QuestManager.iniciar_missao("identificar_riscos")
