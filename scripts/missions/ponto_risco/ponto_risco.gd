class_name QuestIdentificarRiscos
extends Quest

var target_count: int = 3
var current_count: int = 0

# Guarda as chaves únicas de cada risco coletado
var itens_coletados: Array[String] = []

func _init() -> void:
	id = "identificar_riscos"
	title = "Identificando riscos do mapa"
	description = "Encontre os pontos de risco no mapa"

func progredir(dados: Dictionary = {}) -> void:
	if estado_atual == "finalizada": return
	
	# CORREÇÃO: Buscando exatamente pela chave 'item_id' que o objeto envia
	if dados.has("item_id"):
		var id_do_item = dados["item_id"]
		if not itens_coletados.has(id_do_item):
			itens_coletados.append(id_do_item)
	
	var quant = dados.get("amount", 1)
	current_count = clampi(current_count + quant, 0, target_count)
	
	estado_atual = "em_andamento"
	em_andamento.emit(id)
	
	print("Missão Riscos: ", current_count, "/", target_count)
	
	if current_count >= target_count:
		finalizar()

# Função para o item checar se a ID única dele já está salva
func verificar_item_coletado(id_do_item: String) -> bool:
	return itens_coletados.has(id_do_item)
