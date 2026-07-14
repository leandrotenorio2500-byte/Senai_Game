extends Node

var coins := 0000
var player_life := 3

var acertos_rh = 0
var total_curriculos = 0

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
