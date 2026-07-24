class_name QuestIdentificarRiscos
extends Quest

var target_count: int = 8
var current_count: int = 0

# Guarda as chaves únicas de cada setor/risco registrado
var itens_coletados: Array[String] = []

func _init() -> void:
	id = "identificar_riscos"
	title = "Identificando riscos do mapa"
	description = "Encontre os pontos de risco no mapa"
	
	# Estado inicial já como em andamento
	estado_atual = "em_andamento"
	
	# Preenche previamente com os 6 setores já conhecidos/marcados
	itens_coletados = [
		"RH",
		"Deposito",
		"Almoxarifado",
		"Banheiro",
		"Refeitorio",
		"Vestiario"
	]
	
	current_count = itens_coletados.size()

func progredir(dados: Dictionary = {}) -> void:
	if estado_atual == "finalizada": 
		return
		
	# Identifica qual chave veio (pode ser 'item_id' do ponto ou 'setor' do NPC)
	var id_registrar: String = dados.get("item_id", dados.get("setor", ""))
	
	# Só incrementa se for um setor/item novo
	if id_registrar != "" and not itens_coletados.has(id_registrar):
		itens_coletados.append(id_registrar)
		current_count = clampi(itens_coletados.size(), 0, target_count)
		
		em_andamento.emit(id)
		print("Progresso da Missão: ", current_count, "/", target_count)
		
		# Chegou ao objetivo final (8/8)
		if current_count >= target_count:
			finalizar()

# Função que conclui a missão e emite o sinal para o QuestManager
func finalizar() -> void:
	estado_atual = "finalizada"
	finalizada.emit(id)

func verificar_item_coletado(id_do_item: String) -> bool:
	return itens_coletados.has(id_do_item)
