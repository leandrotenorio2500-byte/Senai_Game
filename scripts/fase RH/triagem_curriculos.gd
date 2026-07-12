extends Control

@onready var reaction = $Feedback/Reaction

func _ready() -> void:
	mostrar_vaga()
	mostrar_curriculo()

var reaction_neutro = preload("res://sprites/Mini UI/neutro.png")
var reaction_errado = preload("res://sprites/Mini UI/errado.png")
var reaction_correto = preload("res://sprites/Mini UI/correto.png")

var indice = 0
var pontos = 0

func mostrar_curriculo():
	print(["nome"])
	var c = curriculos[indice]

	$PainelCurriculos/HBoxContainer/Nome.text = "Nome: " + c["nome"]
	$PainelCurriculos/HBoxContainer/Idade.text = "Idade: " + str(c["idade"])
	$PainelCurriculos/HBoxContainer/Curso.text = "Cursos: " + ", ".join(c["cursos"])
	$PainelCurriculos/HBoxContainer/Horario.text = "Disponibilidade: " + c["horario"]
	$PainelCurriculos/HBoxContainer/Escolaridade.text = "Escolaridade: " + c["escolaridade"]
	$PainelCurriculos/HBoxContainer/habilidades.text = "Habilidades: " + ", ".join(c["habilidades"])
	$PainelCurriculos/HBoxContainer/Experiencia.text = "Experiência: " + c["experiencia"]

func mostrar_vaga():
	reaction.texture = reaction_neutro
	var v = vagas[indice]

	$PainelRequisitos/VBoxContainer/Cargo.text = "Cargo: " + v["cargo"]
	$PainelRequisitos/VBoxContainer/escolaridade.text = "- Escolaridade: " + v["escolaridade"]
	$PainelRequisitos/VBoxContainer/curso.text = "- Cursos: " + ", ".join(v["cursos"])
	$PainelRequisitos/VBoxContainer/habilidades.text = "- Habilidades: " + ", ".join(v["habilidades"])
	$PainelRequisitos/VBoxContainer/horario.text = "- Horário: " + v["horario"]
	$PainelRequisitos/VBoxContainer/experiencia.text = "- Experiência: " + v["experiencia"]

func candidato_aprovado():

	var vaga = vagas[indice]
	var candidato = curriculos[indice]

	# Escolaridade
	if vaga["escolaridade"] != candidato["escolaridade"]:
		return false

	# Horário
	if candidato["horario"] != "Integral" and vaga["horario"] != candidato["horario"]:
		return false

	# Cursos
	for curso in vaga["cursos"]:
		if curso not in candidato["cursos"]:
			return false

	# Habilidades
	for habilidade in vaga["habilidades"]:
		if habilidade not in candidato["habilidades"]:
			return false

	return true

func verificar(resposta):

	var correto = candidato_aprovado()

	if resposta == correto:
		pontos += 100
		reaction.texture = reaction_correto
	else:
		reaction.texture = reaction_errado

	await get_tree().create_timer(2).timeout

	indice += 1

	if indice < curriculos.size():

		mostrar_vaga()
		mostrar_curriculo()

	else:

		finalizar()
	

func finalizar():

	$LabelFeedback.text = "Parabéns! Você concluiu a triagem."

var curriculos = [
{#1
	"nome":"Hugo Penhafiel",
	"idade":18,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Trabalho em equipe"
	],
	"horario":"Manhã",
	"experiencia":"Nenhuma"

},
{#2
	"nome":"Anthony Albuquerque",
	"idade":18,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Operador de Empilhadeira"
	],
	"habilidades":[
		"Organização",
		"Controle de estoque"
	],
	"horario":"Tarde",
	"experiencia":"Auxiliar de Depósito"
},
{#3
	"nome":"Eduardo Mário",
	"idade":16,
	"escolaridade":"2º ano do Ensino Médio",
	"cursos":[
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Facilidade para aprender",
		"Trabalho em equipe"
	],
	"horario":"Manhã",
	"experiencia":"Nenhuma"
},
{#4
	"nome":"Júlia Kamily",
	"idade":19,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"NR-10",
		"Eletricidade Básica",
	],
	"habilidades":[
		"Manutenção industrial",
		"Atenção aos detalhes"
	],
	"horario":"Integral",
	"experiencia":"Auxiliar de Manutenção"
},
{#5
	"nome":"Guilherme Souza",
	"idade":19,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Pacote Office",
		"Informática Básica",
		"Eletricidade Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Atendimento ao público"
	],
	"horario":"Manhã",
	"experiencia":"Nenhuma"
},
{#6
	"nome":"Wanda Fidelix",
	"idade":20,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Pacote Office",
		"Produção",
		"Informática Básica"
	],
	"habilidades":[
		"Trabalho em equipe",
		"Atendimento ao público",
		"Organização"
	],
	"horario":"Manhã",
	"experiencia":"Voluntária em eventos escolares"
},
{#7
	"nome":"Ranny Ketilyn",
	"idade":19,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Pacote Office",
		"Informática Básica",
		"Produção"
	],
	"habilidades":[
		"Boa comunicação",
		"Atendimento ao público",
		"Organização",
		"Trabalho em equipe"
	],
	"horario":"Manhã",
	"experiencia":"Auxiliar de produção"
},
{#8
	"nome":"Daniel Duarte",
	"idade":19,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Logística Básica",
		"Informática Básica"
	],
	"habilidades":[
		"Controle de estoque",
		"Organização",
		"Trabalho em equipe"
	],
	"horario":"Integral",
	"experiencia":"Auxiliar de Almoxarifado"
},
{#9
	"nome":"David Gabryel",
	"idade":20,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Logística Básica",
		"Informática Básica"
	],
	"habilidades":[
		"Controle de estoque",
		"Organização",
		"Trabalho em equipe"
	],
	"horario":"Tarde",
	"experiencia":"Auxiliar de Padaria"
},
{#10
	"nome":"Merielly Raiany",
	"idade":18,
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Pacote Office",
		"Logística Básica",
		"Informática Básica"
	],
	"habilidades":[
		"Atendimento ao público",
		"Boa comunicação",
		"Organização"
	],
	"horario":"Integral",
	"experiencia":"Assistente Administrativo"
}
]

var vagas = [
{#1
	"cargo":"Jovem Aprendiz Administrativo",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Trabalho em equipe"
	],
	"horario":"Manhã",
	"experiencia":"Nenhuma"
},
{#2
	"cargo":"Jovem Aprendiz Administrativo",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Trabalho em equipe"
	],
	"horario":"Manhã",
	"experiencia":"Nenhuma"
},
{#3
	"cargo":"Jovem Aprendiz Administrativo",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Trabalho em equipe"
	],
	"horario":"Manhã",
	"experiencia":"Nenhuma"
},
{#4
	"cargo":"Auxiliar de Manutenção",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Eletricidade Básica"
	],
	"habilidades":[
		"Manutenção industrial"
	],
	"horario":"Integral",
	"experiencia":"Desejável"
},
{#5
	"cargo":"Auxiliar de Manutenção",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Eletricidade Básica"
	],
	"habilidades":[
		"Manutenção industrial"
	],
	"horario":"Integral",
	"experiencia":"Desejável"
},
{#6
	"cargo":"Auxiliar de Produção",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Produção"
	],
	"habilidades":[
		"Trabalho em equipe",
		"Organização"
	],
	"horario":"Tarde",
	"experiencia":"Não necessário"
},
{#7
	"cargo":"Auxiliar de Produção",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Produção"
	],
	"habilidades":[
		"Trabalho em equipe",
		"Organização"
	],
	"horario":"Manhã",
	"experiencia":"Não necessário"
},
{#8
	"cargo":"Auxiliar de Almoxarifado",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Logística Básica",
		"Informática Básica"
	],
	"habilidades":[
		"Controle de estoque",
		"Organização"
	],
	"horario":"Manhã",
	"experiencia":"Desejável"
},
{#9
	"cargo":"Assistente de Recursos Humanos",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Pacote Office",
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Organização",
		"Atendimento ao público"
	],
	"horario":"Comercial",
	"experiencia":"Desejável"
},
{#10
	"cargo":"Assistente de Recursos Humanos",
	"escolaridade":"Ensino Médio Completo",
	"cursos":[
		"Pacote Office",
		"Informática Básica"
	],
	"habilidades":[
		"Boa comunicação",
		"Organização",
		"Atendimento ao público"
	],
	"horario":"Comercial",
	"experiencia":"Desejável"
}
]


func _on_aprovado_pressed() -> void:
	verificar(true)

func _on_reprovado_pressed() -> void:
	verificar(false)
