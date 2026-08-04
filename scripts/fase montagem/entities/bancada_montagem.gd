extends Area2D

var cena_minigame_montagem: PackedScene = preload("res://scene/fase montagem/bancada_montagem.tscn")

@onready var _interact_label: Control = $InteractiveLabel
var _player_nearby: bool = false
var _abrinndo_minigame: bool = false # Trava contra múltiplos disparos do Enter


func _ready() -> void:
	if _interact_label:
		_interact_label.visible = false
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if _player_nearby and Input.is_action_just_pressed("interect"):
		abrir_minigame_montagem()


func abrir_minigame_montagem() -> void:
	# Evita abrir múltiplos minigames se pressionar Enter várias vezes
	if _abrinndo_minigame or get_tree().root.has_node("BancadaMontagem"):
		return
		
	_abrinndo_minigame = true

	var quest = QuestManager.obter_missao("manutencao_bancada") as QuestManutencao
	
	# Caso não haja missão ativa ou ela já tenha sido finalizada
	if not quest or quest.estado_atual == "finalizada":
		var dialog_concluido: Array[Dictionary] = [
			{
				"title": "Bancada de Manutenção",
				"dialog": "Não há nenhum computador pendente para reparo no momento.",
				"faceset": "res://sprites/npcs/npc3_dialog.png"
			}
		]
		DialogManager.start_dialog(dialog_concluido)
		_abrinndo_minigame = false
		return
	
	# Exibe o relatório do cliente/peça com defeito antes de abrir o minigame
	var peca_com_defeito = quest.obter_peca_necessaria()
	
	var dialog_inicio: Array[Dictionary] = [
		{
			"title": "Ordem de Serviço",
			"dialog": "Computador recebido na bancada.\nRelatório do cliente: Problema identificado na peça [" + peca_com_defeito.to_upper() + "]. Inspecione e troque-a!",
			"faceset": "res://sprites/npcs/npc3_dialog.png"
		}
	]
	
	DialogManager.start_dialog(dialog_inicio)
	
	# Aguarda o jogador fechar o diálogo
	if DialogManager.has_signal("dialog_ended"):
		await DialogManager.dialog_ended
	
	# Instancia e exibe a bancada apenas UMA vez
	if cena_minigame_montagem and not get_tree().root.has_node("BancadaMontagem"):
		var minigame_instancia = cena_minigame_montagem.instantiate()
		minigame_instancia.name = "BancadaMontagem" # Garante o nome correto no root
		get_tree().root.add_child(minigame_instancia)

	_abrinndo_minigame = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = true
		if _interact_label:
			_interact_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = false
		if _interact_label:
			_interact_label.visible = false
