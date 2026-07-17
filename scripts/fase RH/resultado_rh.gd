extends Control

var acertos = 0
var total = 0

func _ready():
	$VBoxContainer2/acertos.text = str(acertos) + "/" + str(total)
	#process_mode = Node.PROCESS_MODE_WHEN_PAUSED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_concluir_pressed() -> void:
	Transicao.mudar_cena("res://scene/rh.tscn")


func _on_jogar_novamente_pressed() -> void:
	get_tree().reload_current_scene()
