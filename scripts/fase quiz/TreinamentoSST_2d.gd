extends Control
class_name TreinamentoSST

signal atividade_finalizada(resultado: Dictionary)



# ============================================================
# NÓS DA INTERFACE
# ============================================================
@onready var toque: AudioStreamPlayer = $toque

@onready var label_progresso: Label = $Header/LabelProgresso

@onready var label_situacao: Label = $AreaPergunta/FundoPergunta/LabelSituacao
@onready var label_pergunta: RichTextLabel = $AreaPergunta/FundoPergunta/LabelPergunta

@onready var cena_fundo: TextureRect = $AreaSituacao/Cena/TextureRect
@onready var personagem: AnimatedSprite2D = $AreaSituacao/Cena/Personagem
@onready var efeito: AnimatedSprite2D = $AreaSituacao/Cena/Efeito

@onready var resultado_final: Control = $ResultadoFinal
@onready var label_titulo: Label = $ResultadoFinal/LabelTitulo
@onready var label_desempenho: Label = $ResultadoFinal/LabelDesempenho
@onready var label_mensagem: RichTextLabel = $ResultadoFinal/NinePatchRect/LabelMensagem
@onready var btn_finalizar: Button = $ResultadoFinal/BtnFinalizar

@onready var btn_a: Button = $AreaPergunta/FundoPergunta/Opcoes/BtnA
@onready var btn_b: Button = $AreaPergunta/FundoPergunta/Opcoes/BtnB
@onready var btn_c: Button = $AreaPergunta/FundoPergunta/Opcoes/BtnC
@onready var btn_d: Button = $AreaPergunta/FundoPergunta/Opcoes/BtnD

@onready var feedback: Control = $Feedback
@onready var label_resultado: Label = $Feedback/TextureRect/LabelResultado

@onready var label_explicacao: RichTextLabel = $Feedback/TextureRect/NinePatchRect/LabelExplicacao

@onready var btn_continuar: Button = $Feedback/TextureRect/BtnContinuar

@onready var tutorial: Control = $Tutorial
@onready var introducao: Control = $Introducao



# ============================================================
# SITUAÇÕES
# ============================================================

var situacoes := [

	# ============================================================
	# SITUAÇÃO 01 — EPI DANIFICADO
	# ============================================================

	{
		"situacao": "Um funcionário percebe que o cabo de um equipamento está danificado. Mesmo assim, ele afirma que ainda consegue utilizar o equipamento normalmente.",

		"pergunta": "O que você faria?",

		"opcoes": [
			"Usar o equipamento por pouco tempo.",
			"Improvisar um reparo no cabo.",
			"Não utilizar e comunicar o problema.",
			"Pedir para um funcionário experiente testar."
		],

		"resposta": 2,

		"explicacao": "Um equipamento com cabo danificado não deve ser utilizado. O problema deve ser comunicado ao responsável para que seja corrigido de forma adequada.",
		
		"fundo": "res://sprites/SST/cenarios/situacao_01.png",
		"animacao_personagem": "idle",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 02 — EPI NÃO É DESCARTÁVEL SÓ POR ESTAR SUJO
	# ============================================================

	{
		"situacao": "Após terminar uma atividade, um funcionário retira seus equipamentos de proteção e os deixa sobre uma bancada suja. Ele pretende utilizá-los novamente no dia seguinte.",

		"pergunta": "Qual é a atitude mais adequada?",

		"opcoes": [
			"Guardar os EPIs em local seco e fechado.",
			"Lavar todos os EPIs com qualquer produto disponível.",
			"Realizar a higienização adequada e guardar os equipamentos corretamente.",
			"Descarta-los adequadamente ao final do turno"
		],

		"resposta": 2,

		"explicacao": "Os EPIs precisam ser higienizados, conservados e armazenados adequadamente, conforme as orientações do fabricante e os procedimentos da empresa. Guardá-los de qualquer maneira pode comprometer sua conservação.",
		
		"fundo": "res://sprites/BACKGROUND/Cenas SST/2.png",
		"animacao_personagem": "None",
		"animacao_efeito": ""
	},

	# ============================================================
	# SITUAÇÃO 03 — EPI INADEQUADO
	# ============================================================

	#{
		#"situacao": "Um trabalhador precisa realizar uma atividade que exige proteção específica para os olhos. Ele encontra um óculos de proteção de outro funcionário, mas o equipamento está com a lente riscada e não se ajusta corretamente ao seu rosto.",
#
		#"pergunta": "O que deve ser feito?",
#
		#"opcoes": [
			#"Utilizar o óculos mesmo assim, pois ele ainda protege parcialmente.",
			#"Usar o equipamento apenas durante os momentos mais perigosos.",
			#"Utilizar óculos comuns no lugar do EPI.",
			#"Solicitar um EPI adequado e em boas condições.",
		#],
#
		#"resposta": 3,
#
		#"explicacao": "O EPI precisa ser adequado ao risco, estar em boas condições e ser utilizado corretamente. Um equipamento danificado ou inadequado pode não oferecer a proteção necessária.",
		#
		#"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		#"animacao_personagem": "",
		#"animacao_efeito": ""
	#},


	# ============================================================
	# SITUAÇÃO 04 — TRABALHO EM ALTURA
	# ============================================================

	#{
		#"situacao": "Um funcionário precisa alcançar um ponto elevado durante uma manutenção. Um colega sugere subir em uma cadeira para terminar o serviço rapidamente.",
#
		#"pergunta": "Qual é a atitude mais segura?",
#
		#"opcoes": [
			#"Utilizar outro meio mais adequado para esse trabalho, seguindo os procedimentos de segurança.",
			#"Não subir na cadeira, mas sim em uma mesa, pois ela apresenta maior estabilidade.",
			#"Subir cuidadosamente apenas se alguém estiver segurando.",
			#"Subir rapidamente para reduzir o tempo de exposição ao risco."
		#],
#
		#"resposta": 0,
#
		#"explicacao": "Cadeiras e outros objetos improvisados não devem ser utilizados como meios de acesso para atividades em altura. O trabalho deve ser realizado com os equipamentos, procedimentos e medidas de proteção adequados.",
		#"fundo": "res://sprites/BACKGROUND/Cenas SST/4.png",
		#"animacao_personagem": "",
		#"animacao_efeito": ""
	#},


	# ============================================================
	# SITUAÇÃO 05 — TRABALHO EM ALTURA / PRESSA
	# ============================================================

	#{
		#"situacao": "Durante uma atividade em altura, o funcionário percebe que seu equipamento de proteção apresenta um problema. O serviço está quase terminando e ele acredita que seria desperdício interromper a atividade.",
#
		#"pergunta": "O que ele deve fazer?",
#
		#"opcoes": [
			#"Continuar, pois falta pouco para terminar.",
			#"Continuar apenas se estiver se sentindo seguro.",
			#"Interromper a atividade e comunicar o problema.",
			#"Pedir para um colega observar enquanto termina."
		#],
#
		#"resposta": 2,
#
		#"explicacao": "A proximidade do fim da atividade não elimina o risco. Quando um equipamento ou condição de segurança apresenta problema, a atividade deve ser interrompida e a situação comunicada.",
		#"fundo": "res://sprites/BACKGROUND/Cenas SST/5.png",
		#"animacao_personagem": "",
		#"animacao_efeito": ""
	#},

#{
		#"situacao": "Um funcionário precisa transportar uma caixa pesada até outro setor. Para terminar rapidamente, ele decide levantar a caixa sozinho, curvando bastante as costas e fazendo força de uma só vez.",
#
		#"pergunta": "Qual é a atitude mais segura?",
#
		#"opcoes": [
			#"Levantar rapidamente para reduzir o esforço.",
			#"Verificar o peso da carga, utilizar o meio adequado para transportá-la e pedir ajuda quando necessário.",
			#"Curvar as costas e manter os braços esticados durante o levantamento.",
			#"Segurar a caixa com apenas uma mão para facilitar o deslocamento."
		#],
#
		#"resposta": 1,
#
		#"explicacao": "A movimentação inadequada de cargas pode causar lesões. O trabalhador deve avaliar a carga, utilizar os equipamentos ou meios de transporte disponíveis e solicitar ajuda quando necessário.",
		#"fundo": "res://sprites/BACKGROUND/Cenas SST/7.png",
		#},


	# ============================================================
	# SITUAÇÃO 06 — ELETRICIDADE
	# ============================================================

	#{
		#"situacao": "Um funcionário percebe que uma máquina elétrica apresenta uma falha. Ele pensa em abrir o equipamento para descobrir o que aconteceu, embora não seja responsável pela manutenção elétrica.",
#
		#"pergunta": "Qual seria a atitude correta?",
#
		#"opcoes": [
			#"Abrir a máquina e tentar identificar o problema.",
			#"Comunicar a falha e deixar a intervenção para profissional autorizado.",
			#"Desligar a máquina antes de realizar o reparo por conta própria.",
			#"Pedir ajuda a um colega que tenha experiência com máquinas."
		#],
#
		#"resposta": 1,
#
		#"explicacao": "Intervenções em instalações e equipamentos elétricos exigem procedimentos e competências específicas. O funcionário não deve improvisar reparos. A falha deve ser comunicada ao responsável.",
		#"fundo": "res://sprites/BACKGROUND/Cenas SST/6.png",
		#"animacao_personagem": "",
		#"animacao_efeito": ""
	#},


	# ============================================================
	# SITUAÇÃO 07 — PRINCÍPIOS DE INCÊNDIO
	# ============================================================

	#{
		#"situacao": "Um funcionário percebe um pequeno princípio de incêndio em um equipamento. O ambiente começa a ficar com fumaça e algumas pessoas ainda estão próximas ao local.",
#
		#"pergunta": "Qual deve ser a prioridade?",
#
		#"opcoes": [
			#"Tentar apagar o incêndio imediatamente, independentemente da situação.",
			#"Filmar o incêndio para registrar o ocorrido.",
			#"Esperar alguns minutos para verificar se o fogo aumenta.",
			#"Alertar as pessoas, acionar o procedimento de emergência e evacuar quando necessário.",
		#],
#
		#"resposta": 3,
#
		#"explicacao": "A prioridade em uma emergência é preservar vidas. O alarme e os procedimentos de emergência devem ser acionados, e a evacuação deve ocorrer conforme as orientações estabelecidas.",
		#"fundo": "res://sprites/BACKGROUND/Cenas SST/9.png",
		#"animacao_personagem": "",
		#"animacao_efeito": ""
	#},


	# ============================================================
	# SITUAÇÃO 08 — ASSÉDIO
	# ============================================================

	{
		"situacao": "Durante o expediente, um funcionário faz comentários constrangedores e repetitivos sobre um colega. Algumas pessoas riem, enquanto a pessoa alvo demonstra desconforto.",

		"pergunta": "Qual atitude está de acordo com uma cultura de segurança e respeito?",

		"opcoes": [
			"Participar das brincadeiras para evitar conflitos.",
			"Ignorar, pois é apenas uma brincadeira.",
			"Não compactuar com a situação e buscar relatar o ocorrido.",
			"Esperar que a própria vítima resolva a situação."
		],

		"resposta": 2,

		"explicacao": "Um ambiente de trabalho seguro também precisa ser respeitoso. Situações de assédio ou comportamento inadequado não devem ser normalizadas. Elas devem ser tratadas pelos canais apropriados da organização.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/8.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},
	
	{
		"situacao": "Durante uma atividade, um funcionário percebe que uma etapa não está sendo realizada de forma segura. Seu colega diz para ele continuar mesmo assim, pois a equipe precisa terminar o serviço rapidamente.",


		"pergunta": "Qual é a atitude mais adequada?",

		"opcoes": [
			"Comunicar a condição insegura e seguir os procedimentos de segurança, mesmo que seja necessário interromper a atividade.",
			"Continuar para não atrasar a equipe.",
			"Fazer a atividade rapidamente para diminuir o risco, e, logo após, relatar a condição insegura.",
			"Ignorar o problema porque o responsável pela equipe deve tomar todas as decisões."
		],

		"resposta": 0,

		"explicacao": "A pressão por produtividade não deve levar os trabalhadores a ignorar condições inseguras. Todos devem poder comunicar riscos e interromper uma atividade quando houver uma condição que possa comprometer a segurança.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/10.png",
	}

]

# ============================================================
# CONFIGURAÇÕES
# ============================================================

var TOTAL_SITUACOES := situacoes.size()

# ============================================================
# VARIÁVEIS
# ============================================================

var situacao_atual := 0
var respostas_corretas := 0
var respostas_erradas := 0

var respondendo := true


# ============================================================
# READY
# ============================================================

func _ready() -> void:
	introducao.visible = true
	tutorial.visible =false
	feedback.visible = false
	
	btn_a.pressed.connect(_on_opcao_pressed.bind(0))
	btn_b.pressed.connect(_on_opcao_pressed.bind(1))
	btn_c.pressed.connect(_on_opcao_pressed.bind(2))
	btn_d.pressed.connect(_on_opcao_pressed.bind(3))
	
	btn_continuar.pressed.connect(_on_btn_continuar_pressed)
	
	resultado_final.visible = false

	btn_finalizar.pressed.connect(_on_btn_finalizar_pressed)


# ============================================================
# MOSTRAR SITUAÇÃO
# ============================================================

func mostrar_situacao() -> void:
	
	respondendo = true
	
	feedback.visible = false
	
	var dados: Dictionary = situacoes[situacao_atual]
	
	label_progresso.text = "%02d / %02d" % [
		situacao_atual + 1,
		TOTAL_SITUACOES
	]
	
	label_situacao.text = "SITUAÇÃO"
	label_pergunta.text = dados["situacao"] + "\n\n" + dados["pergunta"]
	
	btn_a.text = "A) " + dados["opcoes"][0]
	btn_b.text = "B) " + dados["opcoes"][1]
	btn_c.text = "C) " + dados["opcoes"][2]
	btn_d.text = "D) " + dados["opcoes"][3]
	
	# ========================================================
	# CENÁRIO
	# ========================================================
	
	if dados.has("fundo") and dados["fundo"] != "":
		var textura = load(dados["fundo"])
		
		if textura:
			cena_fundo.texture = textura
	
	
	# ========================================================
	# PERSONAGEM
	# ========================================================
	
	if dados.has("animacao_personagem"):
		
		var animacao_personagem: String = dados["animacao_personagem"]
		
		if personagem.sprite_frames and personagem.sprite_frames.has_animation(animacao_personagem):
			personagem.play(animacao_personagem)
			personagem.visible = true
	
	
	# ========================================================
	# EFEITO
	# ========================================================
	
	if dados.has("animacao_efeito"):
		
		var animacao_efeito: String = dados["animacao_efeito"]
		
		if animacao_efeito == "":
			efeito.stop()
			efeito.visible = false
			
		elif efeito.sprite_frames and efeito.sprite_frames.has_animation(animacao_efeito):
			efeito.visible = true
			efeito.play(animacao_efeito)
	
	
	ativar_botoes(true)


# ============================================================
# RESPOSTA DO JOGADOR
# ============================================================

func _on_opcao_pressed(indice: int) -> void:
	toque.play()
	if not respondendo:
		return
	
	respondendo = false
	
	var dados: Dictionary = situacoes[situacao_atual]
	var resposta_correta: int = dados["resposta"]
	
	var acertou := indice == resposta_correta
	
	if acertou:
		respostas_corretas += 1
		mostrar_feedback_correto(dados)
	else:
		respostas_erradas += 1
		mostrar_feedback_errado(dados, resposta_correta)
	
	ativar_botoes(false)


# ============================================================
# FEEDBACK - ACERTO
# ============================================================

func mostrar_feedback_correto(dados: Dictionary) -> void:
	
	label_resultado.text = "✓ BOA DECISÃO"
	label_explicacao.text = dados["explicacao"]
	
	feedback.visible = true
	
	btn_continuar.text = "CONTINUAR"


# ============================================================
# FEEDBACK - ERRO
# ============================================================

func mostrar_feedback_errado(
	dados: Dictionary,
	resposta_correta: int
) -> void:
	
	label_resultado.text = "⚠ ATENÇÃO"
	
	var letra := ""
	
	match resposta_correta:
		0:
			letra = "A"
		1:
			letra = "B"
		2:
			letra = "C"
		3:
			letra = "D"
	
	label_explicacao.text = (
		"A decisão mais segura seria a alternativa %s.\n\n%s"
		% [letra, dados["explicacao"]]
	)
	
	feedback.visible = true
	
	btn_continuar.text = "CONTINUAR"


# ============================================================
# CONTINUAR
# ============================================================

func _on_btn_continuar_pressed() -> void:
	toque.play()
	situacao_atual += 1
	
	if situacao_atual >= situacoes.size():
		await transicao_para_resultado()
	else:
		await trocar_situacao()

func trocar_situacao() -> void:

	await Transicao.transicao()

	mostrar_situacao()

	await Transicao.voltar()
# ============================================================
# ATIVAR / DESATIVAR BOTÕES
# ============================================================

func ativar_botoes(ativo: bool) -> void:
	
	btn_a.disabled = not ativo
	btn_b.disabled = not ativo
	btn_c.disabled = not ativo
	btn_d.disabled = not ativo


# ============================================================
# FINALIZAÇÃO
# ============================================================

func transicao_para_resultado() -> void:
	
	await Transicao.transicao()
	
	finalizar_treinamento()
	
	await Transicao.voltar()

func finalizar_treinamento() -> void:
	
	feedback.visible = false
	ativar_botoes(false)
	
	mostrar_resultado_final()
	
func mostrar_resultado_final() -> void:
	
	resultado_final.visible = true
	
	label_desempenho.text = "%d / %d\nDECISOES SEGURAS" % [
		respostas_corretas,
		situacoes.size()
	]
	
	if respostas_corretas >= 13:
		label_mensagem.text = "Excelente! Você demonstrou ótimo domínio dos procedimentos de segurança."
		
	elif respostas_corretas >= 10:
		label_mensagem.text = "Muito bom! Você demonstrou bons conhecimentos sobre segurança."
		
	elif respostas_corretas >= 7:
		label_mensagem.text = "Você está no caminho certo, mas alguns conceitos ainda precisam de atenção."
		
	else:
		label_mensagem.text = "Alguns conceitos importantes precisam ser revisados. Segurança exige atenção constante."



func _on_btn_finalizar_pressed() -> void:
	toque.play()
	var resultado := {
	"total": situacoes.size(),
	"acertos": respostas_corretas,
	"erros": respostas_erradas
	}
	
	atividade_finalizada.emit(resultado)
	Transicao.mudar_cena("res://scene/deposito.tscn")


func _on_btn_continuar_introducao_pressed() -> void:
	toque.play()
	introducao.visible = false
	tutorial.visible = true


func _on_btn_continuar_tutorial_pressed() -> void:
	toque.play()
	tutorial.visible = false
	mostrar_situacao()
