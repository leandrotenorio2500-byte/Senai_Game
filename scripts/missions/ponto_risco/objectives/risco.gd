extends Node2D 

var ja_coletado = false

func _ready():
	# Busca a Area2D que está logo abaixo deste nó e conecta o sinal dela
	$Area2D.body_entered.connect(_on_body_entered)
	
	# Conecta ao sinal global do QuestManager para saber quando qualquer missão iniciar
	QuestManager.quest_started.connect(_on_quest_started)
	
	# Verifica o estado inicial ao carregar o mapa
	_verificar_visibilidade_inicial()

func _verificar_visibilidade_inicial() -> void:
	var missao = QuestManager.missao_atual
	
	# Se a missão já estiver ativa (iniciada ou em andamento), o ponto fica visível
	if missao and missao.id == "identificar_riscos" and (missao.estado_atual == "iniciada" or missao.estado_atual == "em_andamento"):
		_mostrar_ponto_de_risco(true)
	else:
		# Caso contrário (pendente ou outra missão), começa totalmente escondido
		_mostrar_ponto_de_risco(false)

# Função chamada automaticamente quando a Julia (ou qualquer gatilho) inicia uma missão
func _on_quest_started(quest_id: String) -> void:
	if quest_id == "identificar_riscos":
		_mostrar_ponto_de_risco(true)

# Controla tanto a parte visual quanto a colisão do objeto
func _mostrar_ponto_de_risco(mostrar: bool) -> void:
	visible = mostrar
	
	# Desativa a colisão para o player não esbarrar em algo invisível
	if has_node("Area2D/CollisionShape2D"):
		$Area2D/CollisionShape2D.disabled = not mostrar

func _on_body_entered(body):
	if body.is_in_group("Player") and not ja_coletado:
		var missao = QuestManager.missao_atual
		
		if missao and missao.id == "identificar_riscos":
			if missao.estado_atual == "iniciada" or missao.estado_atual == "em_andamento":
				ja_coletado = true
				
				# Envia a notificação de progresso usando a nova função unificada
				QuestManager.notificar_progresso_missao({"amount": 1})
				
				# Deleta o nó 'Risco' e todos os seus filhos
				queue_free()
