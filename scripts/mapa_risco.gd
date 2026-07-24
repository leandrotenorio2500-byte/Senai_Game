extends CanvasLayer

@onready var player_icon: TextureRect = $TextureRect2
@onready var anim: AnimationPlayer = $AnimationPlayer

var esta_animando: bool = false

var positions = {
	"recep": Vector2(130, 160),
	"corredor": Vector2(225, 174),
	"1andar": Vector2(224, 128),
	"tecnico": Vector2(121, 114),
	"banheiro": Vector2(192, 114),
	"refeitorio": Vector2(288, 114),
	"deposito": Vector2(192, 160),
	"producao": Vector2(268, 160),
	"vestiario": Vector2(240, 114),
	"andar_3": Vector2(177, 82),
	"rh": Vector2(130, 68),
	"diretoria": Vector2(192, 68)
}

func atualizar_posicao():
	if Globals.area_atual in positions:
		player_icon.position = positions[Globals.area_atual]

func _ready() -> void:
	visible = false
	Globals.abrir_mapa.connect(abrir_mapa)
	Globals.fechar_mapa.connect(fechar_mapa)
	
func carregar_respostas():

	for setor in $Areas.get_children():

		if Globals.respostas_mapa.has(setor.name):

			var respostas = Globals.respostas_mapa[setor.name]
			var pontos = setor.get_node("Pontos")

			for i in range(pontos.get_child_count()):

				var circulo = pontos.get_child(i)

				circulo.tipo_risco = respostas[i]
				circulo.atualizar_cor()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("abrir_mapa"):
		if visible:
			fechar_mapa()
		else:
			abrir_mapa()


func abrir_mapa() -> void:
	if esta_animando or visible:
		return

	esta_animando = true
	visible = true

	atualizar_posicao()
	atualizar_setores()
	carregar_respostas()

	Globals.mapa_aberto.emit()

	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished

	esta_animando = false


func fechar_mapa() -> void:
	if esta_animando or not visible:
		return

	esta_animando = true

	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished

	visible = false

	Globals.mapa_fechado.emit()

	esta_animando = false

var risco_selecionado = TipoRisco.NENHUM

func selecionar_vermelho():
	risco_selecionado = TipoRisco.QUIMICO

func selecionar_verde():
	risco_selecionado = TipoRisco.FISICO

func selecionar_azul():
	risco_selecionado = TipoRisco.ACIDENTE

func selecionar_amarelo():
	risco_selecionado = TipoRisco.ERGONOMICO

func selecionar_marrom():
	risco_selecionado = TipoRisco.BIOLOGICO
	
enum TipoRisco {
	NENHUM,
	QUIMICO,
	FISICO,
	BIOLOGICO,
	ERGONOMICO,
	ACIDENTE
}

func _on_mecanico_pressed() -> void:
	risco_selecionado = TipoRisco.ACIDENTE

func _on_fisico_pressed() -> void:
	risco_selecionado = TipoRisco.FISICO

func _on_quimico_pressed() -> void:
	risco_selecionado = TipoRisco.QUIMICO

func _on_biologico_pressed() -> void:
	risco_selecionado = TipoRisco.BIOLOGICO

func _on_ergonomico_pressed() -> void:
	risco_selecionado = TipoRisco.ERGONOMICO
	
func salvar_respostas():

	Globals.respostas_mapa.clear()

	for setor in $Areas.get_children():

		var respostas = []
		var pontos = setor.get_node("Pontos")

		for circulo in pontos.get_children():

			respostas.append(circulo.tipo_risco)

		Globals.respostas_mapa[setor.name] = respostas

func atualizar_setores():

	for setor in $Areas.get_children():

		var desbloqueado = Globals.setores_desbloqueados[setor.name]

		setor.get_node("Pontos").visible = desbloqueado
			



func _on_close_pressed() -> void:
	fechar_mapa()
