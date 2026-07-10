class_name QuestIdentificarRiscos
extends Quest

var target_count: int = 3
var current_count: int = 0

func _init() -> void:
	id = "identificar_riscos"
	title = "Identificando riscos do mapa"
	description = "Encontre os pontos de risco no mapa" # <-- ADICIONE ESTA LINHA AQUI!

func progredir(dados: Dictionary = {}) -> void:
	if estado_atual == "finalizada": return
	
	var quant = dados.get("amount", 1)
	current_count = clampi(current_count + quant, 0, target_count)
	
	estado_atual = "em_andamento"
	em_andamento.emit(id)
	
	print("Missão Riscos: ", current_count, "/", target_count)
	
	if current_count >= target_count:
		finalizar()
