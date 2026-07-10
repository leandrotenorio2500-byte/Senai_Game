extends Node2D 

var ja_coletado = false
var id_unica: String = ""

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	QuestManager.quest_started.connect(_on_quest_started)
	
	# get_path() gera um caminho único absoluto na árvore de nós (ex: "/root/Fase1/Risco_01")
	# Convertemos para String para salvar na lista da missão de forma segura
	id_unica = String(get_path())
		
	_verificar_visibilidade_inicial()

func _verificar_visibilidade_inicial() -> void:
	var missao = QuestManager.missao_atual
	
	if missao and missao.id == "identificar_riscos":
		
		# Pergunta para a missão se essa ID de caminho único já foi coletada
		if missao.has_method("verificar_item_coletado") and missao.verificar_item_coletado(id_unica):
			queue_free() # Se sim, o item se apaga na hora
			return
			
		if missao.estado_atual == "iniciada" or missao.estado_atual == "em_andamento":
			_mostrar_ponto_de_risco(true)
			return

	_mostrar_ponto_de_risco(false)

func _on_quest_started(quest_id: String) -> void:
	if quest_id == "identificar_riscos":
		_mostrar_ponto_de_risco(true)

func _mostrar_ponto_de_risco(mostrar: bool) -> void:
	visible = mostrar
	if has_node("Area2D/CollisionShape2D"):
		$Area2D/CollisionShape2D.disabled = not mostrar

func _on_body_entered(body):
	if body.is_in_group("Player") and not ja_coletado:
		var missao = QuestManager.missao_atual
		
		if missao and missao.id == "identificar_riscos":
			if missao.estado_atual == "iniciada" or missao.estado_atual == "em_andamento":
				ja_coletado = true
				
				# Envia exatamente a chave 'item_id' contendo o caminho único
				QuestManager.notificar_progresso_missao({
					"amount": 1,
					"item_id": id_unica
				})
				
				queue_free()
