extends Control

@onready var coins_counter: Label = $MarginContainer/CoinsContainer/CoinsCounter
@onready var life_counter: Label = $MarginContainer/LifeContainer/LifeCounter


func _ready() -> void:
	# Atualiza a interface pela primeira vez
	_update_ui()


func _process(_delta: float) -> void:
	# É melhor atualizar a UI aqui apenas se as variáveis mudarem frequentemente,
	# mas mantive para seguir a estrutura do seu código.
	_update_ui()

# Função isolada para atualizar os textos da interface
func _update_ui() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	life_counter.text = str(Globals.player_life)
	
