class_name QuestIdentificarRiscos
extends Quest

signal setor_visitado
signal setor_analisado
signal mapa_pronto


# Quantidade total de setores da missão
var total_setores: int:
	get:
		return gabarito_riscos.size()


# Setores onde o jogador conversou com o responsável
var setores_visitados: Array[String] = []


# Setores onde o jogador terminou de marcar os riscos corretamente
var setores_analisados: Array[String] = []


# Setores que já estarão concluídos na apresentação/demo
var setores_pre_registrados := [
	"Recepcao",
	"Vestiario",
	"Diretoria",
	"Refeitorio",
	"Banheiro",
	"Tecnico",
	"RH"
]


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


enum Etapa {
	IDENTIFICANDO_RISCOS,
	AGUARDANDO_ENTREGA
}


var etapa_atual: Etapa = Etapa.IDENTIFICANDO_RISCOS


func _init() -> void:

	id = "identificar_riscos"

	title = "Identificando riscos do mapa"

	description = "Converse com os lideres dos setores e registre os riscos no mapa."


# --------------------------------------------------
# INICIALIZAÇÃO DA MISSÃO
# --------------------------------------------------

func iniciar() -> void:

	super.iniciar()

	Globals.missao_mapa_risco_ativa = true

	carregar_setores_pre_registrados()
	
func finalizar() -> void:
	Globals.missao_mapa_risco_ativa = false
	super.finalizar()

func carregar_setores_pre_registrados() -> void:

	for setor in setores_pre_registrados:

		if not setores_visitados.has(setor):
			setores_visitados.append(setor)
			setor_visitado.emit(setor)


		if not setores_analisados.has(setor):
			setores_analisados.append(setor)
			setor_analisado.emit(setor)


		# Pré-preenche o mapa com os riscos corretos
		if Globals.respostas_mapa.has(setor):

			Globals.respostas_mapa[setor] = gabarito_riscos[setor].duplicate()


		# Libera o setor visualmente
		if Globals.setores_desbloqueados.has(setor):

			Globals.desbloquear_setor(setor)


# --------------------------------------------------
# CHAMADO PELOS NPCS
# --------------------------------------------------

func progredir(dados: Dictionary = {}) -> void:

	if estado_atual != "em_andamento":
		return


	var setor: String = dados.get("setor", "")


	if setor.is_empty():
		return


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



# --------------------------------------------------
# CHAMADO PELO MAPA
# --------------------------------------------------

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



# --------------------------------------------------
# ENTREGA DO MAPA
# --------------------------------------------------

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

		# Cria cópias para não alterar as listas originais
		var resposta: Array = Globals.respostas_mapa[setor].duplicate()
		var correta: Array = gabarito_riscos[setor].duplicate()

		# Ordena ambas as listas (agora a ordem dos elementos fica idêntica)
		resposta.sort()
		correta.sort()

		# Se o tamanho ou os elementos forem diferentes, reprova
		if resposta != correta:
			print("Erro encontrado no setor:", setor)
			print("Resposta do jogador (ordenada):", resposta)
			print("Gabarito (ordenado):", correta)
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
	
func force_complete() -> void:
	if estado_atual == "finalizada":
		return

	# 1. Preenche e emite sinais para todos os setores
	for setor in gabarito_riscos.keys():
		if not setores_visitados.has(setor):
			setores_visitados.append(setor)
			setor_visitado.emit(setor)
			
		if not setores_analisados.has(setor):
			setores_analisados.append(setor)
			setor_analisado.emit(setor)

		# Força a resposta correta no dicionário Global do jogo
		Globals.respostas_mapa[setor] = gabarito_riscos[setor].duplicate()

		# Desbloqueia a visualização caso ainda não esteja liberado
		if Globals.setores_desbloqueados.has(setor):
			Globals.desbloquear_setor(setor)

	# 2. Avanca para a última etapa
	etapa_atual = Etapa.AGUARDANDO_ENTREGA
	mapa_pronto.emit()

	print("[QUEST] Riscos identificados e mapa preenchido via Force Complete.")

	# 3. Finaliza a missão diretamente
	finalizar()
