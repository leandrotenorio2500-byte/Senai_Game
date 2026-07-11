extends Node2D

@export_file("*.tscn")
var proxima_cena: String

func _ready() -> void:
	$"Introducao/painel de introducao".visible = false


func mostrar_introducao():
	$"Introducao/painel de introducao".visible = true

func carregar_proxima_fase():
	Transicao.mudar_cena(proxima_cena)

func _on_construcao_pressed() -> void:
	$buttonManager.visible = false

	$Player.play_run()
	$AnimationPlayer.play("saida")


func _on_pronto_pressed() -> void:
	$"Introducao/painel de introducao".visible = false
	
	$AnimationPlayer.play("buttons")
