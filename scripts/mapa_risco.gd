extends CanvasLayer

@onready var player_icon: TextureRect = $TextureRect2
@onready var anim: AnimationPlayer = $AnimationPlayer

var esta_animando: bool = false

var positions = {
	"recep": Vector2(130, 150),
	"corredor": Vector2(174, 150),
	"1andar": Vector2(174, 118),
	"almoxarifado": Vector2(130, 118),
	"banheiro": Vector2(192, 118),
	"refeitorio": Vector2(288, 118),
	"deposito": Vector2(192, 150),
	"producao": Vector2(268, 150),
	"vestiario": Vector2(240, 118),
	"andar_3": Vector2(174, 86)
}

func atualizar_posicao():
	if Globals.area_atual in positions:
		player_icon.position = positions[Globals.area_atual]

func _ready() -> void:
	visible = false
	
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
		if esta_animando:
			return
			
		if not visible:
			esta_animando = true
			visible = true
			atualizar_posicao()
			atualizar_setores()
			carregar_respostas()
			
			$AnimationPlayer.play("fade_in")
			
			await $AnimationPlayer.animation_finished
			esta_animando = false
		else:
			esta_animando = true
			$AnimationPlayer.play("fade_out")
			
			await $AnimationPlayer.animation_finished
			
			visible = false
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

		setor.get_node("Bloqueio").visible = !desbloqueado

		var pontos = setor.get_node("Pontos")

		for circulo in pontos.get_children():

			circulo.visible = desbloqueado
