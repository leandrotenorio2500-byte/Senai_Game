class_name Quest
extends RefCounted

signal iniciada(quest_id: String)
signal em_andamento(quest_id: String)
signal finalizada(quest_id: String)

var id: String = ""
var title: String = ""
var description: String = "" # <-- ADICIONE ESTA LINHA AQUI!
var estado_atual: String = "pendente"

func iniciar() -> void:
	if estado_atual != "pendente": return
	estado_atual = "iniciada"
	iniciada.emit(id)

func progredir(dados: Dictionary = {}) -> void:
	pass

func finalizar() -> void:
	if estado_atual == "finalizada": return
	estado_atual = "finalizada"
	finalizada.emit(id)
