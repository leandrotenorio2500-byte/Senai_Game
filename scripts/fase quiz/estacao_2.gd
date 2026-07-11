extends Node2D

@export_file("*.tscn")
var proxima_cena: String

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func carregar_proxima_fase():
	Transicao.mudar_cena(proxima_cena)

func _on_quimico_pressed() -> void:
	$buttonManager/Container/container.visible = false
	
	$Player.play_run()
	$AnimationPlayer.play("saida")
