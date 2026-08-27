class_name QuestIdentificarRiscos
extends Quest


signal setor_visitado
signal setor_analisado
signal mapa_pronto


# ============================================================
# CONFIGURAÇÕES
# ============================================================

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


# ============================================================
# GABARITO DOS RISCOS
# ============================================================

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


# ============================================================
# ESTADO DA MISSÃO
# ============================================================

enum Etapa {
	IDENTIFICANDO_RISCOS,
	AGUARDANDO_ENTREGA
}


var etapa_atual: Etapa = Etapa.IDENTIFICANDO_RISCOS


# ============================================================
# RESULTADO DA AVALIAÇÃO
# ============================================================

# Guarda os erros encontrados na última avaliação.
#
# Cada erro possui:
#
# {
#     "setor": "Producao",
#     "faltando": [...],
#     "sobrando": [...]
# }
#
var erros_mapa: Array[Dictionary] = []


# Indica se o último mapa avaliado estava correto.
var mapa_aprovado: bool = false



# ============================================================
# INICIALIZAÇÃO
# ============================================================

func _init() -> void:

	id = "identificar_riscos"

	title = "Identificando riscos do mapa"

	description = "Converse com os lideres dos setores e registre os riscos no mapa."



# ============================================================
# INICIALIZAÇÃO DA MISSÃO
# ============================================================

func iniciar() -> void:

	super.iniciar()

	Globals.missao_mapa_risco_ativa = true

	carregar_setores_pre_registrados()



# ============================================================
# FINALIZAÇÃO
# ============================================================

func finalizar() -> void:

	Globals.missao_mapa_risco_ativa = false

	super.finalizar()



# ============================================================
# SETORES PRÉ-REGISTRADOS
# ============================================================

func carregar_setores_pre_registrados() -> void:

	for setor in setores_pre_registrados:

		# ----------------------------------------------------
		# REGISTRA COMO VISITADO
		# ----------------------------------------------------

		if not setores_visitados.has(setor):

			setores_visitados.append(setor)

			setor_visitado.emit(setor)


		# ----------------------------------------------------
		# REGISTRA COMO ANALISADO
		# ----------------------------------------------------

		if not setores_analisados.has(setor):

			setores_analisados.append(setor)

			setor_analisado.emit(setor)


		# ----------------------------------------------------
		# PRÉ-PREENCHER MAPA COM OS RISCOS CORRETOS
		# ----------------------------------------------------

		if Globals.respostas_mapa.has(setor):

			Globals.respostas_mapa[setor] = gabarito_riscos[setor].duplicate()


		# ----------------------------------------------------
		# LIBERA O SETOR VISUALMENTE
		# ----------------------------------------------------

		if Globals.setores_desbloqueados.has(setor):

			Globals.desbloquear_setor(setor)



# ============================================================
# CHAMADO PELOS NPCS
# ============================================================

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



# ============================================================
# CHAMADO PELO MAPA
# ============================================================

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



# ============================================================
# VERIFICA SE O MAPA ESTÁ PRONTO
# ============================================================

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



# ============================================================
# ENTREGA DO MAPA
# ============================================================

func entregar_mapa() -> void:

	if etapa_atual != Etapa.AGUARDANDO_ENTREGA:

		return


	print("Michele está avaliando o mapa...")


	# --------------------------------------------------------
	# AVALIA O MAPA
	# --------------------------------------------------------

	mapa_aprovado = avaliar_mapa()


	# --------------------------------------------------------
	# MAPA CORRETO
	# --------------------------------------------------------

	if mapa_aprovado:

		print("Mapa aprovado!")

		finalizar()


	# --------------------------------------------------------
	# MAPA INCORRETO
	# --------------------------------------------------------

	else:

		print("Mapa reprovado.")

		description = "Existem riscos marcados incorretamente. Revise o mapa e volte para a avaliação."

		em_andamento.emit(id)



# ============================================================
# AVALIAÇÃO DO MAPA
# ============================================================

func avaliar_mapa() -> bool:

	# Limpa os erros da avaliação anterior
	erros_mapa.clear()


	# --------------------------------------------------------
	# VERIFICA TODOS OS SETORES
	# --------------------------------------------------------

	for setor in gabarito_riscos.keys():

		# ----------------------------------------------------
		# SETOR NÃO EXISTE NO MAPA
		# ----------------------------------------------------

		if not Globals.respostas_mapa.has(setor):

			erros_mapa.append({
				"setor": setor,
				"faltando": gabarito_riscos[setor].duplicate(),
				"sobrando": []
			})

			print("Setor não encontrado:", setor)

			continue


		# ----------------------------------------------------
		# COPIA AS RESPOSTAS
		# ----------------------------------------------------

		var resposta: Array = Globals.respostas_mapa[setor].duplicate()

		var correta: Array = gabarito_riscos[setor].duplicate()


		# ----------------------------------------------------
		# ORDENA AS LISTAS
		# ----------------------------------------------------

		resposta.sort()

		correta.sort()


		# ----------------------------------------------------
		# SETOR CORRETO
		# ----------------------------------------------------

		if resposta == correta:

			continue


		# ----------------------------------------------------
		# SETOR INCORRETO
		# ----------------------------------------------------

		var faltando: Array = []

		var sobrando: Array = []


		# ----------------------------------------------------
		# ENCONTRA RISCOS FALTANDO
		# ----------------------------------------------------

		for risco in correta:

			if not resposta.has(risco):

				faltando.append(risco)


		# ----------------------------------------------------
		# ENCONTRA RISCOS INDEVIDOS
		# ----------------------------------------------------

		for risco in resposta:

			if not correta.has(risco):

				sobrando.append(risco)


		# ----------------------------------------------------
		# REGISTRA O ERRO
		# ----------------------------------------------------

		erros_mapa.append({
			"setor": setor,
			"faltando": faltando,
			"sobrando": sobrando
		})


		print("Erro encontrado no setor:", setor)

		print("Resposta do jogador (ordenada):", resposta)

		print("Gabarito (ordenado):", correta)

		print("Riscos faltando:", faltando)

		print("Riscos indevidos:", sobrando)


	# --------------------------------------------------------
	# RESULTADO FINAL
	# --------------------------------------------------------

	return erros_mapa.is_empty()



# ============================================================
# VERIFICA SE O SETOR FOI VISITADO
# ============================================================

func verificar_setor_visitado(setor: String) -> bool:

	return setores_visitados.has(setor)



# ============================================================
# VERIFICA SE O SETOR FOI ANALISADO
# ============================================================

func verificar_setor_analisado(setor: String) -> bool:

	return setores_analisados.has(setor)



# ============================================================
# CONTA OS RISCOS DE UMA LISTA
# ============================================================

func contar_riscos(lista: Array) -> Dictionary:

	var contagem := {}


	for risco in lista:

		if not contagem.has(risco):

			contagem[risco] = 0


		contagem[risco] += 1


	return contagem



# ============================================================
# FORCE COMPLETE
# ============================================================

func force_complete() -> void:

	if estado_atual == "finalizada":

		return


	# --------------------------------------------------------
	# PREENCHE E EMITE SINAIS PARA TODOS OS SETORES
	# --------------------------------------------------------

	for setor in gabarito_riscos.keys():

		# ----------------------------------------------------
		# VISITADO
		# ----------------------------------------------------

		if not setores_visitados.has(setor):

			setores_visitados.append(setor)

			setor_visitado.emit(setor)


		# ----------------------------------------------------
		# ANALISADO
		# ----------------------------------------------------

		if not setores_analisados.has(setor):

			setores_analisados.append(setor)

			setor_analisado.emit(setor)


		# ----------------------------------------------------
		# FORÇA RESPOSTA CORRETA
		# ----------------------------------------------------

		Globals.respostas_mapa[setor] = gabarito_riscos[setor].duplicate()


		# ----------------------------------------------------
		# DESBLOQUEIA O SETOR
		# ----------------------------------------------------

		if Globals.setores_desbloqueados.has(setor):

			Globals.desbloquear_setor(setor)


	# --------------------------------------------------------
	# AVANÇA PARA A ÚLTIMA ETAPA
	# --------------------------------------------------------

	etapa_atual = Etapa.AGUARDANDO_ENTREGA

	mapa_pronto.emit()


	print(
		"[QUEST] Riscos identificados e mapa preenchido via Force Complete."
	)


	# --------------------------------------------------------
	# FINALIZA A MISSÃO DIRETAMENTE
	# --------------------------------------------------------

	finalizar()
