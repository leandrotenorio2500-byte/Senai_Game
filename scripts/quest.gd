class_name Quest
extends RefCounted

signal iniciada(quest_id: String)
signal em_andamento(quest_id: String)
signal finalizada(quest_id: String)

var id: String = ""
var title: String = ""
var description: String = ""

# Estados possíveis: "nao_iniciada", "em_andamento", "finalizada"
var estado_atual: String = "nao_iniciada"

func iniciar() -> void:
	if estado_atual == "nao_iniciada":
		estado_atual = "em_andamento"
		iniciada.emit(id)

func progredir(dados: Dictionary = {}) -> void:
	# Cada missão filha sobrescreve esta função com sua própria lógica!
	pass

func finalizar() -> void:
	if estado_atual != "finalizada":
		estado_atual = "finalizada"
		finalizada.emit(id)
