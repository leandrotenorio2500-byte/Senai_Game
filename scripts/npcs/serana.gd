extends "res://scripts/npc.gd"

func _ready() -> void:
	var npc_faceset_path = "res://sprites/npcs/npc6_dialog.png"
	var npc_name = "Serana"
	var player_faceset_path = "res://sprites/npcs/main_character_dialog.png"
	spritesheet = load("res://sprites/npcs/npc6.png")
	hframes = 8
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Opa, tudo bem? Você por acaso é o novo Jovem Aprendiz?",
			"faceset": npc_faceset_path
		},
		{
			"title": "Jogador",
			"dialog": "Sim, sou eu! Cheguei agora.",
			"faceset": player_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Que massa! Seja muito bem-vindo, viu?",
			"faceset": npc_faceset_path
		},
	]
	super._ready()
