extends Control

@onready var coins_counter: Label = $MarginContainer/CoinsContainer/CoinsCounter
@onready var timer_counter: Label = $MarginContainer/TimerContainer/TimerCounter
@onready var life_counter: Label = $MarginContainer/LifeContainer/LifeCounter
@onready var score_counter: Label = $MarginContainer/ScoreContainer/ScoreCounter
@onready var clock_timer: Timer = $ClockTimer

var minutes: int = 0
var seconds: int = 0

func _ready() -> void:
	# Atualiza a interface pela primeira vez
	_update_ui()
	
	# Configura e inicia o Timer via código (caso não tenha feito no Inspetor)
	clock_timer.wait_time = 1.0
	clock_timer.one_shot = false
	clock_timer.start()
	
	# Conecta o sinal do Timer à função que conta o tempo
	clock_timer.timeout.connect(_on_clock_timer_timeout)

func _process(_delta: float) -> void:
	# É melhor atualizar a UI aqui apenas se as variáveis mudarem frequentemente,
	# mas mantive para seguir a estrutura do seu código.
	_update_ui()

# Função isolada para atualizar os textos da interface
func _update_ui() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str(Globals.player_life)
	
	# CORREÇÃO: Mudado de 'clock_timer.text' para 'timer_counter.text' (que é a sua Label)
	# E corrigido de 'minutes : minutes' para 'minutes : seconds'
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

# Esta função roda toda vez que 1 segundo acaba
func _on_clock_timer_timeout() -> void:
	seconds += 1
	if seconds >= 60:
		seconds = 0
		minutes += 1
