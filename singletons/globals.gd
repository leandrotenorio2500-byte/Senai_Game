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
	"almoxarifado": [],
	"refeitorio": [],
	"banheiro": [],
	"vestiario": [],
	"recepcao": [],
	"rh": []
}

#var setores_desbloqueados = {
	#"Recepcao": false,
	#"RH": false,
	#"Producao": false,
	#"Deposito": false,
	#"Almoxarifado": false,
	#"Banheiro": false,
	#"Refeitorio": false,
	#"Vestiario": false,
	#"Diretoria": false
#}

var setores_desbloqueados = {
	"Recepcao": false,
	"RH": true,
	"Producao": false,
	"Deposito": true,
	"Almoxarifado": true,
	"Banheiro": true,
	"Refeitorio": true,
	"Vestiario": true,
	"Diretoria": false 
}
