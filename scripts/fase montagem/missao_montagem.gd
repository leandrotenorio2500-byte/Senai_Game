class_name QuestManutencao
extends Quest

var target_count: int = 3
var current_count: int = 0

# Ordem fixa dos defeitos
var fila_defeitos: Array[String] = ["fonte_queimada", "ram_defeituosa", "cabo_desconectado"]
var defeito_atual_idx: int = 0

var defeito_identificado: bool = false

# Mapeamento exclusivo: Defeito -> Peça de Reposição
var tabela_reparos: Dictionary = {
	"fonte_queimada": "fonte_nova",
	"ram_defeituosa": "memoria_ram_nova",
	"cabo_desconectado": "cabo_sata_novo"
}

func _init() -> void:
	id = "manutencao_bancada"
	title = "Manutenção de Computadores"
	description = "Diagnostique a peça com defeito e faça a substituição na bancada."
	#estado_atual = "em_andamento"

func obter_defeito_atual() -> String:
	if defeito_atual_idx < fila_defeitos.size():
		return fila_defeitos[defeito_atual_idx]
	return ""

func identificar_defeito() -> void:
	defeito_identificado = true
	print("[QUEST MANUTENÇÃO] Defeito identificado: ", obter_defeito_atual())

func obter_peca_necessaria() -> String:
	return tabela_reparos.get(obter_defeito_atual(), "")

func concluir_substituicao() -> void:
	defeito_identificado = false
	current_count += 1
	defeito_atual_idx += 1
	
	em_andamento.emit(id)
	print("[QUEST MANUTENÇÃO] PC reparado! Progresso: ", current_count, "/", target_count)
	
	if current_count >= target_count:
		finalizar()

func finalizar() -> void:
	estado_atual = "finalizada"
	finalizada.emit(id)
