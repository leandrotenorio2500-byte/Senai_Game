extends Node2D

@export_file("*.tscn")
var proxima_cena: String

func _ready() -> void:
	$gameover.visible = false
	$AnimationPlayer.play("game_over")
	

func game_over():
	$buttonManager.visible = false
	$gameover.visible = true

func carregar_proxima_fase():
	Transicao.mudar_cena(proxima_cena)

func _on_eletrico_pressed() -> void:
	$buttonManager/Container/container.visible = false
	$Player.play_run()
	$AnimationPlayer.play("saida")
	
func _on_solda_pressed() -> void:
	game_over()

func _on_quimico_pressed() -> void:
	game_over()
	
func _on_construcao_pressed() -> void:
	game_over()
	
func _on_tentarnovamente_pressed() -> void:
	Transicao.mudar_cena("res://scene/fase quiz/estacao_3.tscn")
