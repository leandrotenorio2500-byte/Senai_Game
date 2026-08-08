extends Node

@warning_ignore("unused_signal")
signal abrir_mapa

@warning_ignore("unused_signal")
signal fechar_mapa

@warning_ignore("unused_signal")
signal mapa_aberto

@warning_ignore("unused_signal")
signal mapa_fechado

@warning_ignore("unused_signal")
signal setor_desbloqueado(nome: String)

enum TipoRisco {
	NENHUM,
	QUIMICO,
	FISICO,
	BIOLOGICO,
	ERGONOMICO,
	ACIDENTE
}

# -----------------------------
# Dados gerais do jogo
# -----------------------------

var coins := 0
var player_life := 3

var acertos_rh := 0
var total_curriculos := 0
var pularintro_quiz := false

var resultado_quiz := {
	"acertos": 0,
	"total": 0
}

var next_player_position: Vector2 = Vector2.ZERO
var should_position := false

var area_atual := ""

# -----------------------------
# Controle de missões
# -----------------------------

var missao_mapa_risco_ativa := false

# -----------------------------
# Áudio
# -----------------------------

var som_ding := preload("res://sounds/SOM DE ELEVADOR.mp3")
var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

	audio_player.stream = som_ding
	audio_player.volume_db = -15.0

func tocar_ding() -> void:
	if audio_player:
		audio_player.play()

# -----------------------------
# Mapa de risco
# -----------------------------

var respostas_mapa := {
	"Recepcao": [],
	"Deposito": [],
	"Producao": [],
	"Tecnico": [],
	"Refeitorio": [],
	"Banheiro": [],
	"Vestiario": [],
	"RH": [],
	"Diretoria": []
}

var setores_desbloqueados := {
	"Recepcao": false,
	"Deposito": false,
	"Producao": false,
	"Tecnico": false,
	"Refeitorio": false,
	"Banheiro": false,
	"Vestiario": false,
	"RH": false,
	"Diretoria": false
}

var daniel_seguindo := false
var npc_base_scene = preload("res://entities/npc.tscn")

func desbloquear_setor(nome: String) -> void:
	if not setores_desbloqueados.has(nome):
		push_warning("Setor '%s' não encontrado." % nome)
		return

	if setores_desbloqueados[nome]:
		return

	setores_desbloqueados[nome] = true
	setor_desbloqueado.emit(nome)

	setores_desbloqueados[nome] = true

func bloquear_setor(nome: String) -> void:
	if not setores_desbloqueados.has(nome):
		push_warning("Setor '%s' não encontrado." % nome)
		return

	setores_desbloqueados[nome] = false

#func setor_desbloqueado(nome: String) -> bool:
	#return setores_desbloqueados.get(nome, false)

func limpar_respostas_mapa() -> void:
	for setor in respostas_mapa.keys():
		respostas_mapa[setor].clear()

func limpar_setores_desbloqueados() -> void:
	for setor in setores_desbloqueados.keys():
		setores_desbloqueados[setor] = false
		


# ----------------------------------------------------
# SISTEMA DE INVENTÁRIO (Adicionado para resolver o erro)
# ----------------------------------------------------
var inventario: Array[String] = []

func adicionar_item(item_id: String) -> void:
	if not inventario.has(item_id):
		inventario.append(item_id)
		print("Item adicionado ao inventário: ", item_id)

func remover_item(item_id: String) -> void:
	if inventario.has(item_id):
		inventario.erase(item_id)
		print("Item removido do inventário: ", item_id)

func possui_item(item_id: String) -> bool:
	return inventario.has(item_id)
	
func coletar_peca_pendente() -> String:
	var quest_estado = QuestManager.obter_estado("atender_chamados")
	
	if quest_estado == "em_andamento":
		var quest = QuestManager.obter_missao("atender_chamados") as QuestChamados
		if quest:
			var item_faltando = quest.obter_proximo_item_pendente()
			if item_faltando != "":
				adicionar_item(item_faltando)
				return item_faltando
	return ""
	
func spawn_daniel():

	if not daniel_seguindo:
		return

	var player = get_tree().get_first_node_in_group("Player")

	if player == null:
		return

	var daniel = npc_base_scene.instantiate()

	daniel.set_script(load("res://scripts/npcs/Daniel-ti.gd"))

	get_tree().current_scene.add_child(daniel)

	daniel.global_position = player.global_position + Vector2(-32, -2)
	daniel.iniciar_daniel()

func preparar_apresentacao_mapa_risco() -> void:

	# Setores que já aparecem liberados na demonstração
	var setores_iniciais = [
		"Recepcao",
		"Vestiario",
		"Diretoria",
		"Refeitorio",
		"Banheiro",
		"Tecnico",
		"RH"
	]

	for setor in setores_iniciais:
		if setores_desbloqueados.has(setor):
			setores_desbloqueados[setor] = true


	# Criar registros vazios para esses setores
	for setor in setores_iniciais:
		if respostas_mapa.has(setor):
			if respostas_mapa[setor].is_empty():

				var pontos = []

				# Quantidade de pontos de risco que aquele setor possui
				match setor:
					"Recepcao":
						pontos = [
							TipoRisco.NENHUM
						]

					"Diretoria":
						pontos = [
							TipoRisco.NENHUM,
						]

					"Refeitorio":
						pontos = [
							TipoRisco.NENHUM,
							TipoRisco.NENHUM,
						]
						
					"Vestiario":
						pontos = [
							TipoRisco.NENHUM,
							TipoRisco.NENHUM,
						]
					"RH":
						pontos = [
							TipoRisco.NENHUM,
						]
					"Banheiro":
						pontos = [
							TipoRisco.NENHUM,
							TipoRisco.NENHUM,
						]
					"Tecnico":
						pontos = [
							TipoRisco.NENHUM,
							TipoRisco.NENHUM,
						]


				respostas_mapa[setor] = pontos
