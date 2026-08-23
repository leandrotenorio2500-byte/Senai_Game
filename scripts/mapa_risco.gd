extends CanvasLayer

@onready var player_icon: TextureRect = $TextureRect/TextureRect2
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var painel_risco: NinePatchRect = $TextureRect/PainelRisco
@onready var label_titulo_risco: Label = $TextureRect/PainelRisco/VBoxContainer/Titulo
@onready var label_descricao_risco: Label = $TextureRect/PainelRisco/VBoxContainer/Descricao
@onready var label_exemplos_risco: Label = $TextureRect/PainelRisco/VBoxContainer/Exemplo

var esta_animando: bool = false

var positions = {
	"recep": Vector2(130, 168),
	"corredor": Vector2(225, 182),
	"1andar": Vector2(224, 136),
	"tecnico": Vector2(121, 122),
	"banheiro": Vector2(192, 122),
	"refeitorio": Vector2(288, 122),
	"deposito": Vector2(192, 168),
	"producao": Vector2(268, 168),
	"vestiario": Vector2(240, 114),
	"andar_3": Vector2(177, 90),
	"rh": Vector2(130, 76),
	"diretoria": Vector2(192, 76)
}

func atualizar_posicao():
	if Globals.area_atual in positions:
		player_icon.position = positions[Globals.area_atual]

func _ready() -> void:
	visible = false
	painel_risco.visible = false
	
	Globals.abrir_mapa.connect(abrir_mapa)
	Globals.fechar_mapa.connect(fechar_mapa)
	
	
func mostrar_informacao_risco(tipo: TipoRisco) -> void:
	
	match tipo:
		TipoRisco.QUIMICO:
			label_titulo_risco.text = "RISCO QUÍMICO"
			label_descricao_risco.text = "Está relacionado à exposição a substâncias químicas que podem causar danos à saúde do trabalhador."
			label_exemplos_risco.text = "Fique atento a:\n• Poeiras\n• Fumos\n• Gases e vapores\n• Produtos químicos"
			
		TipoRisco.FISICO:
			label_titulo_risco.text = "RISCO FÍSICO"
			label_descricao_risco.text = "Está relacionado à exposição a agentes físicos presentes no ambiente de trabalho."
			label_exemplos_risco.text = "Fique atento a:\n• Ruído\n• Calor\n• Vibração\n• Radiação"
			
		TipoRisco.BIOLOGICO:
			label_titulo_risco.text = "RISCO BIOLÓGICO"
			label_descricao_risco.text = "Está relacionado à exposição a microrganismos ou materiais biológicos que podem causar doenças."
			label_exemplos_risco.text = "Fique atento a:\n• Vírus\n• Bactérias\n• Fungos\n• Materiais contaminados"
			
		TipoRisco.ERGONOMICO:
			label_titulo_risco.text = "RISCO ERGONÔMICO"
			label_descricao_risco.text = "Está relacionado a condições de trabalho que podem causar desconforto, fadiga ou problemas de saúde."
			label_exemplos_risco.text = "Fique atento a:\n• Postura inadequada\n• Esforço excessivo\n• Movimentos repetitivos\n• Mobiliário inadequado"
			
		TipoRisco.ACIDENTE:
			label_titulo_risco.text = "RISCO DE ACIDENTES"
			label_descricao_risco.text = "Está relacionado a situações ou condições que podem provocar acidentes durante o trabalho."
			label_exemplos_risco.text = "Fique atento a:\n• Máquinas sem proteção\n• Ferramentas inadequadas\n• Risco de quedas\n• Instalações perigosas"
			
		TipoRisco.NENHUM:
			painel_risco.visible = false
			return
	
	painel_risco.visible = true

func carregar_respostas():

	for setor in $TextureRect/Areas.get_children():

		if not Globals.respostas_mapa.has(setor.name):
			continue

		var respostas = Globals.respostas_mapa[setor.name]
		var pontos = setor.get_node("Pontos")

		for i in range(min(respostas.size(), pontos.get_child_count())):

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

	carregar_respostas()
	atualizar_setores()

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
	mostrar_informacao_risco(risco_selecionado)

func _on_fisico_pressed() -> void:
	risco_selecionado = TipoRisco.FISICO
	mostrar_informacao_risco(risco_selecionado)

func _on_quimico_pressed() -> void:
	risco_selecionado = TipoRisco.QUIMICO
	mostrar_informacao_risco(risco_selecionado)

func _on_biologico_pressed() -> void:
	risco_selecionado = TipoRisco.BIOLOGICO
	mostrar_informacao_risco(risco_selecionado)

func _on_ergonomico_pressed() -> void:
	risco_selecionado = TipoRisco.ERGONOMICO
	mostrar_informacao_risco(risco_selecionado)
	
func salvar_respostas():

	for setor in $TextureRect/Areas.get_children():

		var respostas = []
		var pontos = setor.get_node("Pontos")

		for circulo in pontos.get_children():
			respostas.append(circulo.tipo_risco)

		Globals.respostas_mapa[setor.name] = respostas
		
func setor_completo(setor: Node) -> bool:

	var pontos = setor.get_node("Pontos")

	for circulo in pontos.get_children():

		if circulo.tipo_risco == TipoRisco.NENHUM:
			return false

	return true
	
func verificar_setores_completos():

	for setor in $TextureRect/Areas.get_children():

		if not Globals.setores_desbloqueados.get(setor.name, false):
			continue


		if setor_completo(setor):

			var quest = QuestManager.obter_missao("identificar_riscos")

			if quest and not quest.verificar_setor_analisado(setor.name):
				quest.registrar_setor_analisado(setor.name)

func atualizar_setores():

	for setor in $TextureRect/Areas.get_children():

		var pontos = setor.get_node("Pontos")

		if not Globals.missao_mapa_risco_ativa:
			pontos.visible = false
			continue

		var desbloqueado = Globals.setores_desbloqueados.get(setor.name, false)

		pontos.visible = desbloqueado



func _on_close_pressed() -> void:
	fechar_mapa()
