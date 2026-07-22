class_name QuestChamados
extends Quest

var target_count: int = 3
var current_count: int = 0

# Guarda as chaves únicas de cada setor/risco registrado
var itens_coletados: Array[String] = []

func _init() -> void:
	id = "atender_chamados"
	title = "Atenda os chamados dos funcionários"
	description = "Auxilie os funcionários estão tendo com os computadores"
	
	# Estado inicial já como em andamento
	#estado_atual = "em_andamento"
	
	# Preenche previamente com os 2 atende já conhecidos/marcados
	#itens_coletados = [
		#"RH",
		#"Almoxarifado",
		
	#]
	#
	#current_count = itens_coletados.size()

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
