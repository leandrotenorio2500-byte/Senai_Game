extends Control
class_name TreinamentoSST

signal atividade_finalizada(resultado: Dictionary)


# ============================================================
# CONFIGURAÇÕES
# ============================================================

const TOTAL_SITUACOES := 13


# ============================================================
# NÓS DA INTERFACE
# ============================================================

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
			"Pedir para outro funcionário testar."
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
			"Guardar os EPIs exatamente como estão.",
			"Lavar todos os EPIs com qualquer produto disponível.",
			"Realizar a higienização adequada e guardar os equipamentos corretamente.",
			"Deixar os EPIs expostos para secarem naturalmente."
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

	{
		"situacao": "Um trabalhador precisa realizar uma atividade que exige proteção específica para os olhos. Ele encontra um óculos de proteção de outro funcionário, mas o equipamento está com a lente riscada e não se ajusta corretamente ao seu rosto.",

		"pergunta": "O que deve ser feito?",

		"opcoes": [
			"Utilizar o óculos mesmo assim, pois ele ainda protege parcialmente.",
			"Usar o equipamento apenas durante os momentos mais perigosos.",
			"Solicitar um EPI adequado e em boas condições.",
			"Utilizar óculos comuns no lugar do EPI."
		],

		"resposta": 2,

		"explicacao": "O EPI precisa ser adequado ao risco, estar em boas condições e ser utilizado corretamente. Um equipamento danificado ou inadequado pode não oferecer a proteção necessária.",
		
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 04 — TRABALHO EM ALTURA
	# ============================================================

	{
		"situacao": "Um funcionário precisa alcançar um ponto elevado durante uma manutenção. Um colega sugere subir em uma cadeira para terminar o serviço rapidamente.",

		"pergunta": "Qual é a atitude mais segura?",

		"opcoes": [
			"Subir na cadeira, tomando cuidado para não cair.",
			"Subir na cadeira apenas se alguém estiver segurando.",
			"Utilizar o meio adequado para trabalho em altura e seguir os procedimentos de segurança.",
			"Subir rapidamente para reduzir o tempo de exposição ao risco."
		],

		"resposta": 2,

		"explicacao": "Cadeiras e outros objetos improvisados não devem ser utilizados como meios de acesso para atividades em altura. O trabalho deve ser realizado com os equipamentos, procedimentos e medidas de proteção adequados.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/4.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 05 — TRABALHO EM ALTURA / PRESSA
	# ============================================================

	{
		"situacao": "Durante uma atividade em altura, o funcionário percebe que seu equipamento de proteção apresenta um problema. O serviço está quase terminando e ele acredita que seria desperdício interromper a atividade.",

		"pergunta": "O que ele deve fazer?",

		"opcoes": [
			"Continuar, pois falta pouco para terminar.",
			"Continuar apenas se estiver se sentindo seguro.",
			"Interromper a atividade e comunicar o problema.",
			"Pedir para um colega observar enquanto termina."
		],

		"resposta": 2,

		"explicacao": "A proximidade do fim da atividade não elimina o risco. Quando um equipamento ou condição de segurança apresenta problema, a atividade deve ser interrompida e a situação comunicada.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/5.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 06 — ELETRICIDADE
	# ============================================================

	{
		"situacao": "Um funcionário percebe que uma máquina elétrica apresenta uma falha. Ele pensa em abrir o equipamento para descobrir o que aconteceu, embora não seja responsável pela manutenção elétrica.",

		"pergunta": "Qual seria a atitude correta?",

		"opcoes": [
			"Abrir a máquina e tentar identificar o problema.",
			"Desligar a máquina e realizar o reparo por conta própria.",
			"Comunicar a falha e deixar a intervenção para profissional autorizado.",
			"Pedir ajuda a qualquer colega que tenha experiência com máquinas."
		],

		"resposta": 2,

		"explicacao": "Intervenções em instalações e equipamentos elétricos exigem procedimentos e competências específicas. O funcionário não deve improvisar reparos. A falha deve ser comunicada ao responsável.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/6.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 07 — ELETRICIDADE / ÁGUA
	# ============================================================

	{
		"situacao": "Durante o trabalho, um funcionário percebe que há água próxima a uma extensão elétrica utilizada no setor. O equipamento continua funcionando normalmente.",

		"pergunta": "O que deve ser feito?",

		"opcoes": [
			"Continuar trabalhando, desde que ninguém toque na água.",
			"Retirar a extensão rapidamente com as mãos.",
			"Comunicar o risco e seguir o procedimento adequado para eliminar a condição perigosa.",
			"Colocar um pano sobre a água e continuar."
		],

		"resposta": 2,

		"explicacao": "Água e eletricidade podem criar uma situação de grave risco de choque elétrico. Não se deve improvisar nem tocar no equipamento de forma insegura. A condição deve ser comunicada e tratada conforme os procedimentos.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 08 — PRINCÍPIOS DE INCÊNDIO
	# ============================================================

	{
		"situacao": "Um funcionário percebe um pequeno princípio de incêndio em um equipamento. O ambiente começa a ficar com fumaça e algumas pessoas ainda estão próximas ao local.",

		"pergunta": "Qual deve ser a prioridade?",

		"opcoes": [
			"Tentar apagar o incêndio imediatamente, independentemente da situação.",
			"Filmar o incêndio para registrar o ocorrido.",
			"Alertar as pessoas, acionar o procedimento de emergência e evacuar quando necessário.",
			"Esperar alguns minutos para verificar se o fogo aumenta."
		],

		"resposta": 2,

		"explicacao": "A prioridade em uma emergência é preservar vidas. O alarme e os procedimentos de emergência devem ser acionados, e a evacuação deve ocorrer conforme as orientações estabelecidas.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 09 — EXTINTOR
	# ============================================================

	{
		"situacao": "Um funcionário treinado percebe um pequeno princípio de incêndio e identifica que há um extintor apropriado disponível. O fogo ainda está em uma proporção controlável.",

		"pergunta": "Qual atitude é mais adequada?",

		"opcoes": [
			"Utilizar qualquer extintor disponível.",
			"Utilizar o extintor adequado, seguindo o treinamento e mantendo uma rota segura de saída.",
			"Entrar no meio da fumaça para alcançar o fogo mais rapidamente.",
			"Jogar água no fogo independentemente do material que está queimando."
		],

		"resposta": 1,

		"explicacao": "O extintor deve ser compatível com o tipo de incêndio e utilizado somente quando houver condições seguras e treinamento. Também é fundamental manter uma rota de fuga.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 12 — ASSÉDIO
	# ============================================================

	{
		"situacao": "Durante o expediente, um funcionário faz comentários constrangedores e repetitivos sobre um colega. Algumas pessoas riem, enquanto a pessoa alvo demonstra desconforto.",

		"pergunta": "Qual atitude está de acordo com uma cultura de segurança e respeito?",

		"opcoes": [
			"Participar das brincadeiras para evitar conflitos.",
			"Ignorar, pois é apenas uma brincadeira.",
			"Não compactuar com a situação e utilizar os canais adequados para comunicar o ocorrido.",
			"Esperar que a própria vítima resolva a situação."
		],

		"resposta": 2,

		"explicacao": "Um ambiente de trabalho seguro também precisa ser respeitoso. Situações de assédio ou comportamento inadequado não devem ser normalizadas. Elas devem ser tratadas pelos canais apropriados da organização.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 13 — COMUNICAÇÃO DE RISCO
	# ============================================================

	{
		"situacao": "Um trabalhador novo percebe uma condição que considera perigosa, mas fica com receio de comunicar o problema porque ainda está aprendendo como funciona o setor.",

		"pergunta": "O que seria mais adequado?",

		"opcoes": [
			"Ficar em silêncio para não parecer inexperiente.",
			"Esperar até conhecer melhor o setor.",
			"Comunicar a condição ao responsável e pedir orientação.",
			"Tentar corrigir sozinho sem avisar ninguém."
		],

		"resposta": 2,

		"explicacao": "Perceber e comunicar riscos é parte importante da prevenção. Ninguém deve deixar uma condição perigosa sem comunicação por medo de parecer inexperiente.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 14 — PROCEDIMENTO DE SEGURANÇA
	# ============================================================

	{
		"situacao": "Um funcionário experiente afirma que determinado procedimento de segurança é desnecessário porque ele realiza aquela atividade há anos sem sofrer nenhum acidente.",

		"pergunta": "Qual resposta representa uma atitude preventiva?",

		"opcoes": [
			"Concordar, pois experiência substitui os procedimentos.",
			"Seguir o procedimento somente quando houver supervisão.",
			"Seguir as medidas de segurança mesmo quando a atividade parece simples ou conhecida.",
			"Imitar a maneira como os funcionários mais antigos trabalham."
		],

		"resposta": 2,

		"explicacao": "A ausência de acidentes anteriores não significa ausência de risco. Procedimentos de segurança existem para reduzir a possibilidade de acidentes e devem ser respeitados.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	},


	# ============================================================
	# SITUAÇÃO 15 — PRESSA PARA TERMINAR
	# ============================================================

	{
		"situacao": "O turno está terminando e um funcionário percebe que ainda precisa concluir uma atividade. Para terminar mais rápido, ele pensa em ignorar algumas medidas de segurança que normalmente utiliza.",

		"pergunta": "O que ele deve fazer?",

		"opcoes": [
			"Fazer a atividade rapidamente e compensar o risco.",
			"Ignorar apenas os procedimentos que parecem menos importantes.",
			"Manter os procedimentos de segurança mesmo que a atividade demore mais.",
			"Continuar somente se outro funcionário estiver observando."
		],

		"resposta": 2,

		"explicacao": "A pressa nunca deve justificar a retirada de medidas de segurança. Uma atividade segura pode levar mais tempo, mas reduzir riscos é mais importante do que terminar rapidamente.",
		"fundo": "res://sprites/BACKGROUND/Cenas SST/3.png",
		"animacao_personagem": "",
		"animacao_efeito": ""
	}

]

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
	var resultado := {
	"total": situacoes.size(),
	"acertos": respostas_corretas,
	"erros": respostas_erradas
	}
	
	atividade_finalizada.emit(resultado)
	Transicao.mudar_cena("res://scene/rh.tscn")


func _on_btn_continuar_introducao_pressed() -> void:
	introducao.visible = false
	tutorial.visible = true


func _on_btn_continuar_tutorial_pressed() -> void:
	tutorial.visible = false
	mostrar_situacao()
