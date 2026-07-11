extends Node2D

@export_file("*.tscn")
var proxima_cena: String

func _ready() -> void:
	$gameover.visible = false


func game_over():
	$buttonManager.visible = false
	$gameover.visible = true
	$AnimationPlayer.play("game_over")

func carregar_proxima_fase():
	Transicao.mudar_cena(proxima_cena)

func _on_eletrico_pressed() -> void:
	game_over()
	
func _on_solda_pressed() -> void:
	game_over()

func _on_quimico_pressed() -> void:
	$buttonManager/Container/container.visible = false
	$Player.play_run()
	$AnimationPlayer.play("saida")
	
func _on_construcao_pressed() -> void:
	game_over()
	
func _on_tentarnovamente_pressed() -> void:
	get_tree().reload_current_scene()
