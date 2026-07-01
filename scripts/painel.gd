extends Control
@onready var prim_andar: Button = $VBoxContainer/PrimAndar
@onready var seg_andar: Button = $VBoxContainer/SegAndar
@onready var terc_andar: Button = $VBoxContainer/TercAndar
@onready var painel: Control = $"."

func _ready() -> void:
	var cena_atual: String = get_tree().current_scene.scene_file_path
	
	# Desativa o botão se o jogador já estiver nessa cena
	if cena_atual == "res://scene/corredor.tscn":
		$VBoxContainer/PrimAndar.visible = false
		
	if cena_atual == "res://scene/1andar.tscn":
		$VBoxContainer/SegAndar.visible = false
		
	if cena_atual == "res://scene/andar_3.tscn" :
		$VBoxContainer/TercAndar.visible = false

func _on_prim_andar_pressed() -> void:
	Globals.next_player_position = Vector2(264.0, 147.0) 
	Globals.should_position = true
	
	get_tree().change_scene_to_file("res://scene/corredor.tscn")

func _on_seg_andar_pressed() -> void:
	Globals.next_player_position = Vector2(216.0, 147.0) 
	Globals.should_position = true
	
	get_tree().change_scene_to_file("res://scene/1andar.tscn")

func _on_terc_andar_pressed() -> void:
	Globals.next_player_position = Vector2(200.0, 147.0) 
	Globals.should_position = true
	
	get_tree().change_scene_to_file("res://scene/andar_3.tscn")

func _on_fechar_pressed() -> void:
	painel.visible = false
	
