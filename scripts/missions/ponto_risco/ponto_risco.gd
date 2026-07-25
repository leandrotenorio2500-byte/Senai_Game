class_name QuestIdentificarRiscos
extends Quest

signal setor_visitado
signal setor_analisado
signal mapa_pronto

# Quantidade total de setores da missão
var total_setores: int = 9

# Setores onde o jogador conversou com o responsável
var setores_visitados: Array[String] = []

# Setores onde o jogador terminou de marcar os riscos corretamente
var setores_analisados: Array[String] = []

var gabarito_riscos := {
	"Recepcao": [
		Globals.TipoRisco.ERGONOMICO
	],
	"Deposito": [
		Globals.TipoRisco.ACIDENTE,
		Globals.TipoRisco.FISICO,
		Globals.TipoRisco.ERGONOMICO
	],
	"Producao": [
		Globals.TipoRisco.ACIDENTE,
		Globals.TipoRisco.FISICO,
		Globals.TipoRisco.ERGONOMICO,
		Globals.TipoRisco.QUIMICO
	],
	"Tecnico": [
		Globals.TipoRisco.ACIDENTE,
		Globals.TipoRisco.ERGONOMICO
	],
	"Refeitorio": [
		Globals.TipoRisco.BIOLOGICO,
		Globals.TipoRisco.ACIDENTE
	],
	"Banheiro": [
		Globals.TipoRisco.BIOLOGICO,
		Globals.TipoRisco.ACIDENTE
	],
	"Vestiario": [
		Globals.TipoRisco.BIOLOGICO,
		Globals.TipoRisco.ACIDENTE
	],
	"RH": [
		Globals.TipoRisco.ERGONOMICO
	],
	"Diretoria": [
		Globals.TipoRisco.ERGONOMICO
	]
}

# Estado da missão
enum Etapa {
	IDENTIFICANDO_RISCOS,
	AGUARDANDO_ENTREGA
}

var etapa_atual: Etapa = Etapa.IDENTIFICANDO_RISCOS

func _init() -> void:
	id = "identificar_riscos"
	title = "Identificando riscos do mapa"
	description = "Converse com os responsáveis pelos setores e registre os riscos encontrados no mapa."

# Chamado pelos NPCs
func progredir(dados: Dictionary = {}) -> void:

	if estado_atual != "em_andamento":
		return

	var setor: String = dados.get("setor", "")

	if setor.is_empty():
		return

	# Evita contar duas vezes o mesmo setor
	if setores_visitados.has(setor):
		return

	setores_visitados.append(setor)

	setor_visitado.emit(setor)

	print(
		"Setores visitados: ",
		setores_visitados.size(),
		"/",
		total_setores
	)

	em_andamento.emit(id)

# Chamado quando o jogador termina de preencher um setor no mapa
func registrar_setor_analisado(setor: String) -> void:

	if setores_analisados.has(setor):
		return

	setores_analisados.append(setor)

	setor_analisado.emit(setor)

	print(
		"Setores analisados: ",
		setores_analisados.size(),
		"/",
		total_setores
	)
	print("SETOR ANALISADO: ", setor)
	verificar_conclusao_mapa()

func verificar_conclusao_mapa() -> void:

	print("Visitados:", setores_visitados.size())
	print("Analisados:", setores_analisados.size())

	if setores_visitados.size() < total_setores:
		print("Ainda faltam setores visitados.")
		return

	if setores_analisados.size() < total_setores:
		print("Ainda faltam setores analisados.")
		return

	print("Mudando para AGUARDANDO_ENTREGA")

	etapa_atual = Etapa.AGUARDANDO_ENTREGA

	description = "Mapa concluído. Retorne ao responsável para avaliação."

	mapa_pronto.emit()
	em_andamento.emit(id)
	
func entregar_mapa() -> void:

	if etapa_atual != Etapa.AGUARDANDO_ENTREGA:
		return

	print("Julia está avaliando o mapa...")

	if avaliar_mapa():

		print("Mapa aprovado!")

		finalizar()

	else:

		print("Mapa reprovado.")
		description = "Existem riscos marcados incorretamente. Revise o mapa e volte para a avaliação."

		em_andamento.emit(id)

func avaliar_mapa() -> bool:

	for setor in gabarito_riscos.keys():

		if not Globals.respostas_mapa.has(setor):
			print("Setor não encontrado:", setor)
			return false

		var resposta = Globals.respostas_mapa[setor]
		var correta = gabarito_riscos[setor]

		var resposta_contada = contar_riscos(resposta)
		var correta_contada = contar_riscos(correta)

		if resposta_contada != correta_contada:

			print("Erro encontrado no setor:", setor)
			print("Resposta:", resposta_contada)
			print("Gabarito:", correta_contada)

			return false

	return true

func verificar_setor_visitado(setor: String) -> bool:
	return setores_visitados.has(setor)

func verificar_setor_analisado(setor: String) -> bool:
	return setores_analisados.has(setor)
	
func contar_riscos(lista: Array) -> Dictionary:

	var contagem := {}

	for risco in lista:

		if not contagem.has(risco):
			contagem[risco] = 0

		contagem[risco] += 1

	return contagem
