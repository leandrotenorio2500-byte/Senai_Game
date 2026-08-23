extends Control
class_name QuestAnaliseCurriculos


@onready var painel: Control = $PainelCurriculos
@onready var reaction: TextureRect = $Feedback/Reaction
@onready var toque: AudioStreamPlayer = $toque

@onready var introducao: Control = $Introducao
@onready var tutorial: Control = $Tutorial
@onready var requisitos: Control = $PainelRequisitos


var indice := 0
var pontos := 0


var reaction_neutro = preload(
	"res://sprites/Mini UI/neutro.png"
)

var reaction_correto = preload(
	"res://sprites/Mini UI/correto.png"
)

var reaction_errado = preload(
	"res://sprites/Mini UI/errado.png"
)


func _ready():

	painel.decisao_finalizada.connect(
		_on_decisao
	)

	# Primeiro aparece a introdução
	introducao.visible = true
	tutorial.visible = false

	# A atividade fica bloqueada até terminar o tutorial
	painel.visible = false
	requisitos.visible = false
	$Feedback.visible = false

func _on_btn_continuar_tutorial_pressed():
	toque.play()
	tutorial.visible = false

	painel.visible = true
	requisitos.visible = true
	$Feedback.visible = true

	mostrar_vaga()
	mostrar_curriculo()


func mostrar_vaga():

	var vaga = DadosCurriculos.vagas[indice]

	$PainelRequisitos/VBoxContainer/Cargo.text = \
		"Cargo: " + vaga["cargo"]

	$PainelRequisitos/VBoxContainer/escolaridade.text = \
		"- Escolaridade: " + vaga["escolaridade"]

	$PainelRequisitos/VBoxContainer/curso.text = \
		"- Cursos: " + ", ".join(vaga["cursos"])

	$PainelRequisitos/VBoxContainer/habilidades.text = \
		"- Habilidades: " + ", ".join(vaga["habilidades"])

	$PainelRequisitos/VBoxContainer/horario.text = \
		"- Horário: " + vaga["horario"]

	$PainelRequisitos/VBoxContainer/experiencia.text = \
		"- Experiência: " + vaga["experiencia"]


func mostrar_curriculo():

	var candidato = DadosCurriculos.curriculos[indice]

	$PainelCurriculos/HBoxContainer/Nome.text = \
		"Nome: " + candidato["nome"]

	$PainelCurriculos/HBoxContainer/Idade.text = \
		"Idade: " + str(candidato["idade"])

	$PainelCurriculos/HBoxContainer/Curso.text = \
		"Cursos: " + ", ".join(candidato["cursos"])

	$PainelCurriculos/HBoxContainer/Horario.text = \
		"Disponibilidade: " + candidato["horario"]

	$PainelCurriculos/HBoxContainer/Escolaridade.text = \
		"Escolaridade: " + candidato["escolaridade"]

	$PainelCurriculos/HBoxContainer/habilidades.text = \
		"Habilidades: " + ", ".join(candidato["habilidades"])

	$PainelCurriculos/HBoxContainer/Experiencia.text = \
		"Experiência: " + candidato["experiencia"]


func _on_decisao(aprovado):

	var correto = avaliar_candidato()

	if aprovado == correto:
		pontos += 1
		reaction.texture = reaction_correto
	else:
		reaction.texture = reaction_errado

	await get_tree().create_timer(0.4).timeout
	proximo_curriculo()


func avaliar_candidato():

	var candidato = DadosCurriculos.curriculos[indice]
	var vaga = DadosCurriculos.vagas[indice]

	if candidato.escolaridade != vaga.escolaridade:
		return false

	for curso in vaga.cursos:
		if curso not in candidato.cursos:
			return false

	for habilidade in vaga.habilidades:
		if habilidade not in candidato.habilidades:
			return false

	for horario in vaga.horario:
		if horario not in candidato.horario:
			return false

	return true


func proximo_curriculo():

	indice += 1

	if indice >= DadosCurriculos.curriculos.size():
		finalizar()
		return

	painel.resetar()

	mostrar_vaga()
	mostrar_curriculo()


func finalizar():
	toque.play()
	await Transicao.transicao()

	var tela_resultado = preload(
		"res://scene/fase RH/resultado_rh.tscn"
	).instantiate()

	tela_resultado.acertos = pontos
	tela_resultado.total = DadosCurriculos.curriculos.size()

	get_tree().current_scene.add_child(
		tela_resultado
	)

	Transicao.voltar()

func _on_btn_continuar_pressed() -> void:
	toque.play()
	introducao.visible = false
	tutorial.visible = true
