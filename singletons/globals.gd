extends Node

@warning_ignore("unused_signal")
signal abrir_mapa
@warning_ignore("unused_signal")
signal fechar_mapa

@warning_ignore("unused_signal")
signal mapa_aberto
@warning_ignore("unused_signal")
signal mapa_fechado

var coins := 0000
var player_life := 3

var acertos_rh = 0
var total_curriculos = 0
var pularintro_quiz = false

var resultado_quiz = {
	"acertos": 0,
	"total": 0
}

var next_player_position: Vector2 = Vector2.ZERO
var should_position: bool = false

var area_atual = ""

var som_ding = preload("res://sounds/SOM DE ELEVADOR.mp3")

var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = som_ding
	
	audio_player.volume_db = -15.0

func tocar_ding() -> void:
	if audio_player:
		audio_player.play()
		
func desbloquear_setor(nome:String):

	setores_desbloqueados[nome] = true

var respostas_mapa = {
	"producao": [],
	"deposito": [],
	"tecnico": [],
	"refeitorio": [],
	"banheiro": [],
	"vestiario": [],
	"recepcao": [],
	"rh": []
}

var setores_desbloqueados = {
	"Recepcao": false,
	"RH": false,
	"Producao": false,
	"Deposito": false,
	"Almoxarifado": false,
	"Banheiro": false,
	"Refeitorio": false,
	"Vestiario": false,
	"Diretoria": false
}
#
#var setores_desbloqueados = {
	#"Recepcao": false,
	#"RH": true,
	#"Producao": false,
	#"Deposito": true,
	#"Almoxarifado": true,
	#"Banheiro": true,
	#"Refeitorio": true,
	#"Vestiario": true,
	#"Diretoria": false 
#}

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
	
var itens_dos_setores: Dictionary = {
	"Recepcao": "mouse_novo",
	"RH": "memoria_ram",
	"Diretoria": "cabo_rede"
}
	
func coletar_peca_pendente() -> String:
	# 1. Pega a missão de chamados no QuestManager
	var quest = QuestManager.obter_missao("atender_chamados") as QuestChamados
	if not quest:
		return ""

	# 2. Varre os setores para encontrar qual chamado está ABERTO e AINDA NÃO FOI RESOLVIDO
	for setor in quest.problemas_npcs.keys():
		var dados = quest.problemas_npcs[setor]
		
		# Se o chamado do setor está aberto E ainda não foi resolvido
		if dados.get("chamado_aberto", false) and not dados.get("resolvido", false):
			var item_necessario = itens_dos_setores.get(setor, "")
			
			# Se o jogador já não estiver carregando a peça
			if item_necessario != "" and not possui_item(item_necessario):
				adicionar_item(item_necessario)
				return item_necessario

	return ""
	
func coletar_item() -> void:
	var item_coletado = Globals.coletar_peca_pendente()
	
	if item_coletado != "":
		# Formata nomes como "memoria_ram" para "Memória RAM", "cabo_rede" para "Cabo De Rede", etc.
		var nome_formatado = _formatar_nome_item(item_coletado)
		
		var dialog_sucesso: Array[Dictionary] = [
			{
				"title": "Bancada de TI",
				"dialog": "Você pegou a peça necessária: " + nome_formatado + ".",
				"faceset": "res://sprites/npcs/npc3_dialog.png"
			}
		]
		DialogManager.start_dialog(dialog_sucesso)
	else:
		var dialog_vazio: Array[Dictionary] = [
			{
				"title": "Bancada de TI",
				"dialog": "Você não precisa de nenhuma peça no momento (ou já está carregando a peça necessária).",
				"faceset": "res://sprites/npcs/npc3_dialog.png"
			}
		]
		DialogManager.start_dialog(dialog_vazio)

func _formatar_nome_item(id_item: String) -> String:
	match id_item:
		"mouse_novo": return "Mouse Novo"
		"memoria_ram": return "Pente de Memória RAM"
		"cabo_rede": return "Cabo de Rede"
		_: return id_item.replace("_", " ").capitalize()
		
# ----------------------------------------------------
# SISTEMA PRÓPRIO DA MISSÃO DE MANUTENÇÃO
# ----------------------------------------------------
func manutencao_formatar_nome_peca(id_peca: String) -> String:
	match id_peca:
		"fonte_queimada": return "Fonte ATX Queimada"
		"ram_defeituosa": return "Memória RAM Defeituosa"
		"cabo_desconectado": return "Cabo SATA Desconectado"
		"fonte_nova": return "Fonte ATX Nova"
		"memoria_ram_nova": return "Pente de Memória RAM Novo"
		"cabo_sata_novo": return "Cabo SATA Novo"
		_: return id_peca.replace("_", " ").capitalize()
