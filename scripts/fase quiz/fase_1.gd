extends Node2D

var acertos := 0
var indice_pergunta := 0
var tempo_leitura := 5
var tempo_resposta := 20
var tempo_restante := 5.0
var cronometro_ativo := false

enum EstadoQuiz {
	LEITURA,
	RESPOSTA,
	FEEDBACK
}

var estado = EstadoQuiz.LEITURA

var perguntas = [
	{
		"background": preload("res://sprites/BACKGROUND/estacao1.png"),

		"pergunta": "Você foi designado para atuar em uma área de construção civil. Qual conjunto de EPIs é mais adequado para essa atividade?",

		"alternativas": [
			{
				"normal": preload("res://Buttons/button1normal.png"),
				"hover": preload("res://Buttons/button1hover.png"),
				"pressed": preload("res://Buttons/button1pressed.png"),
				"nome": "Kit Construção",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			},
			{
				"normal": preload("res://Buttons/button2norma.png"),
				"hover": preload("res://Buttons/button2hover.png"),
				"pressed": preload("res://Buttons/button2pressed.png"),
				"nome": "Kit Quimico",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]				
			},
			{
				"normal": preload("res://Buttons/button3normal.png"),
				"hover": preload("res://Buttons/button3hoverl.png"),
				"pressed": preload("res://Buttons/button3pressed.png"),
				"nome": "Kit Eletrico",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			},
			{
				"normal": preload("res://Buttons/button4normal.png"),
				"hover": preload("res://Buttons/button4hoverl.png"),
				"pressed": preload("res://Buttons/button4pressed.png"),
				"nome": "Kit Soldagem",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			}
		],
		"correta": 0,
		"feedback_correto":
		"Muito bem! O kit de construção protege contra impactos e quedas de objetos.",

		"feedback_errado":
	    "O kit correto era o de Construção. Cada atividade exige EPIs específicos."
	},
	{
		"background": preload("res://sprites/BACKGROUND/estacao2.png"),

		"pergunta": "Você foi encaminhado para um setor onde são manipulados produtos químicos corrosivos. Qual conjunto de EPIs é mais adequado?",

		"alternativas": [
			{
				"normal": preload("res://Buttons/button1normal.png"),
				"hover": preload("res://Buttons/button1hover.png"),
				"pressed": preload("res://Buttons/button1pressed.png"),
				"nome": "Kit Construção",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			},
			{
				"normal": preload("res://Buttons/button2norma.png"),
				"hover": preload("res://Buttons/button2hover.png"),
				"pressed": preload("res://Buttons/button2pressed.png"),
				"nome": "Kit Quimico",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]				
			},
			{
				"normal": preload("res://Buttons/button3normal.png"),
				"hover": preload("res://Buttons/button3hoverl.png"),
				"pressed": preload("res://Buttons/button3pressed.png"),
				"nome": "Kit Eletrico",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			},
			{
				"normal": preload("res://Buttons/button4normal.png"),
				"hover": preload("res://Buttons/button4hoverl.png"),
				"pressed": preload("res://Buttons/button4pressed.png"),
				"nome": "Kit Soldagem",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			}
		],
		"correta": 1,
		"feedback_correto":
		"Muito bem! O kit de construção protege contra impactos e quedas de objetos.",

		"feedback_errado":
	    "O kit correto era o de Construção. Cada atividade exige EPIs específicos."
	},
		{
		"background": preload("res://sprites/BACKGROUND/estacao3.png"),

		"pergunta": "Você foi designado para realizar a manutenção de um painel elétrico industrial. Qual conjunto de EPIs é o mais adequado para essa atividade?",

		"alternativas": [
			{
				"normal": preload("res://Buttons/button1normal.png"),
				"hover": preload("res://Buttons/button1hover.png"),
				"pressed": preload("res://Buttons/button1pressed.png"),
				"nome": "Kit Construção",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			},
			{
				"normal": preload("res://Buttons/button2norma.png"),
				"hover": preload("res://Buttons/button2hover.png"),
				"pressed": preload("res://Buttons/button2pressed.png"),
				"nome": "Kit Quimico",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]				
			},
			{
				"normal": preload("res://Buttons/button3normal.png"),
				"hover": preload("res://Buttons/button3hoverl.png"),
				"pressed": preload("res://Buttons/button3pressed.png"),
				"nome": "Kit Eletrico",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			},
			{
				"normal": preload("res://Buttons/button4normal.png"),
				"hover": preload("res://Buttons/button4hoverl.png"),
				"pressed": preload("res://Buttons/button4pressed.png"),
				"nome": "Kit Soldagem",
				"descricao": [
					"Capacete",
					"Colete refletivo",
					"Botina",
			        "Óculos de proteção"
				]
			}
		],
		"correta": 3,
		"feedback_correto":
		"Muito bem! O kit de construção protege contra impactos e quedas de objetos.",

		"feedback_errado":
	    "O kit correto era o de Construção. Cada atividade exige EPIs específicos."
	},
]

@onready var botoes = [
	$PainelRespostas/opocoes/A,
	$PainelRespostas/opocoes/B,
	$PainelRespostas/opocoes/C,
	$PainelRespostas/opocoes/D
]

@onready var icone_feedback = $PainelFeedback/icon
var icone_correto = preload("res://Buttons/correto_icon.png")
var icone_errado = preload("res://Buttons/Incorreto_icon.png")

func _ready():
	$PainelRespostas.visible = false
	$PainelFeedback.visible = false
	$PainelFeedback/Proximo.visible = false
	$CanvasLayer/PainelDescricao.visible = false
	for i in range(botoes.size()):
		botoes[i].mouse_entered.connect(_on_botao_hover.bind(i))
		botoes[i].mouse_exited.connect(_on_botao_sai)
	iniciar_quiz()

func _process(delta):
	if !cronometro_ativo:
		return

	if estado == EstadoQuiz.FEEDBACK:
		return

	tempo_restante -= delta

	$PainelPerguntas/Tempo.text = str(int(ceil(tempo_restante)))

	if tempo_restante <= 0:
		cronometro_ativo = false

		match estado:
			EstadoQuiz.LEITURA:
				await esconder_pergunta()
				mostrar_respostas()

			EstadoQuiz.RESPOSTA:
				tempo_esgotado()

func iniciar_quiz():
	carregar_pergunta()

	$AnimationPlayer.play("PerguntaEntrando")

	await $AnimationPlayer.animation_finished

	iniciar_leitura()
	
func iniciar_leitura():
	estado = EstadoQuiz.LEITURA
	tempo_restante = tempo_leitura
	cronometro_ativo = true

func iniciar_tempo_resposta():
	estado = EstadoQuiz.RESPOSTA
	tempo_restante = tempo_resposta
	cronometro_ativo = true

func esconder_pergunta():
	$AnimationPlayer.play("PerguntaSaindo")

	await $AnimationPlayer.animation_finished
	
func mostrar_respostas():

	$PainelRespostas.visible = true

	estado = EstadoQuiz.RESPOSTA

	$AnimationPlayer.play("RespostasEntrando")

	await $AnimationPlayer.animation_finished

	iniciar_tempo_resposta()
	
func esconder_respostas():

	$AnimationPlayer.play("RespostasSaindo")

	await $AnimationPlayer.animation_finished
	
	$PainelRespostas.visible = false
	
func tempo_esgotado():

	cronometro_ativo = false

	for botao in botoes:
		botao.disabled = true

	await esconder_respostas()

	await mostrar_feedback(false)
	
func carregar_pergunta():

	var pergunta = perguntas[indice_pergunta]

	$Background.texture = pergunta["background"]
	$PainelPerguntas/Pergunta.text = pergunta["pergunta"]
	
	atualizar_progresso()

	for i in range(botoes.size()):

		var alternativa = pergunta["alternativas"][i]

		botoes[i].texture_normal = alternativa["normal"]
		botoes[i].texture_hover = alternativa["hover"]
		botoes[i].texture_pressed = alternativa["pressed"]

func atualizar_progresso():
	$PainelPerguntas/TextoProgresso.text = "%d/%d" % [indice_pergunta + 1, perguntas.size()]
	
func verificar_resposta(indice_escolhido):

	if estado != EstadoQuiz.RESPOSTA:
		return

	for botao in botoes:
		botao.disabled = true
		
	cronometro_ativo = false

	var pergunta = perguntas[indice_pergunta]


	var acertou = indice_escolhido == pergunta["correta"]

	if acertou:
		acertos += 1

	await esconder_respostas()

	await mostrar_feedback(acertou)

func proxima_pergunta():

	indice_pergunta += 1

	if indice_pergunta < perguntas.size():

		mostrar_pergunta_novamente()

	else:

		finalizar_quiz()
		
func mostrar_pergunta_novamente():
	for botao in botoes:
		botao.disabled = false
		
	carregar_pergunta()

	$PainelRespostas.visible = false

	$AnimationPlayer.play("PerguntaEntrando")

	await $AnimationPlayer.animation_finished

	iniciar_leitura()
	
func finalizar_quiz():

	cronometro_ativo = false

	Globals.resultado_quiz["acertos"] = acertos
	Globals.resultado_quiz["total"] = perguntas.size()

	get_tree().change_scene_to_file(
		"res://scene/fase quiz/resultatdo_quiz.tscn"
		
	)
	
func mostrar_feedback(acertou: bool):

	estado = EstadoQuiz.FEEDBACK

	var pergunta = perguntas[indice_pergunta]
	$PainelFeedback/Proximo.visible = true
	$PainelFeedback.visible = true
	
	if indice_pergunta == perguntas.size() - 1:
		$PainelFeedback/Proximo.text = "Ver resultado"
	else:
		$PainelFeedback/Proximo.text = "Proxima"
	
	if acertou:
		icone_feedback.texture = icone_correto
		$PainelFeedback/Resposta.text = "Correto!"
		$PainelFeedback/NinePatchRect/Label.text = pergunta["feedback_correto"]
	else:
		icone_feedback.texture = icone_errado
		$PainelFeedback/Resposta.text = "Incorreto!"
		$PainelFeedback/NinePatchRect/Label.text = pergunta["feedback_errado"]

	$AnimationPlayer.play("FeedbackEntrando")
	await $AnimationPlayer.animation_finished

func esconder_feedback():
	$PainelFeedback/Proximo.visible = false

	$AnimationPlayer.play("FeedbackSaindo")
	await $AnimationPlayer.animation_finished

	$PainelFeedback.visible = false

func _on_a_pressed() -> void:
	verificar_resposta(0)


func _on_b_pressed() -> void:
	verificar_resposta(1)


func _on_c_pressed() -> void:
	verificar_resposta(2)


func _on_d_pressed() -> void:
	verificar_resposta(3)


func _on_proximo_pressed() -> void:
	await esconder_feedback()

	proxima_pergunta()

func _on_botao_hover(indice):

	if estado != EstadoQuiz.RESPOSTA:
		return

	var alt = perguntas[indice_pergunta]["alternativas"][indice]

	$CanvasLayer/PainelDescricao/NinePatchRect/Label.text = ""

	for epi in alt["descricao"]:
		$CanvasLayer/PainelDescricao/NinePatchRect/Label.text += "• " + epi + "\n"

	$CanvasLayer/PainelDescricao.visible = true
	
func _on_botao_sai():
	$CanvasLayer/PainelDescricao.visible = false
