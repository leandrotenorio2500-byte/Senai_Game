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
