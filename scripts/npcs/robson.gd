extends "res://scripts/npc.gd"

func _ready() -> void:
	var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
	var npc_name = "Robson"
	spritesheet = load("res://sprites/npcs/npc3.png")
	hframes = 8
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Opa, tudo bem? Rapaz, deixa eu te perguntar uma coisa...", 
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name, 
			"dialog": "Você por acaso é o novo Jovem Aprendiz que estava para chegar hoje?", 
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name, 
			"dialog": "Ah, que massa! Cara, fico feliz demais da vida quando ver a garotada tendo oportunidades assim logo cedo.", 
			"faceset": npc_faceset_path
		},
		#{
			#"title": npc_name, 
			#"dialog": "O mercado de trabalho precisa muito disso, e começar com o pé direito num lugar legal faz toda a diferença.", 
			#"faceset": npc_faceset_path
		#},
		#{
			#"title": npc_name, 
			#"dialog": "Seja muito bem-vindo, viu? Aproveite bastante. Se precisar de qualquer ajuda para se situar por aqui, é só me gritar!", 
			#"faceset": npc_faceset_path
		#},
	]
	super._ready()

func _on_dialog_completed() -> void:
	# Chama o comportamento padrão do script pai (emitir o sinal)
	super._on_dialog_completed()
