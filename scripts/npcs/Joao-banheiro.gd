extends "res://scripts/npc.gd"

func _ready() -> void:
	npc_faceset_path = "res://sprites/Mini UI/heads/Antonio.png"
	npc_name = "Antonio"
	
	idle_spritesheet = load("res://sprites/npcs/zelador.png")
	hframes = 8
	super._ready()
	atualizar_dialogo()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Banheiro", false):
			Globals.desbloquear_setor("Banheiro")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Banheiro"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Banheiro", false):
			dialogo_mapa_concluido()
		else:
			dialogo_mapa_risco()

		return

	dialogo_normal()

func dialogo_mapa_concluido():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_mapa_risco():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Eu sou responsável pela manutenção e organização deste espaço.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Mesmo parecendo um local simples, o banheiro também precisa de cuidados para garantir a segurança de todos que utilizam o ambiente.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Durante a limpeza usamos alguns produtos químicos que precisam ser manuseados corretamente para evitar acidentes.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também é importante ficar atento ao piso molhado e à organização do espaço, pois esses detalhes podem causar quedas e outros problemas.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Essas informações devem ajudar você a preencher o Mapa de Risco.",
			"faceset": npc_faceset_path
		}
	]

func dialogo_normal():
	dialog_data = [
		{
			"title": npc_name,
			"dialog": "Olá! Sou o responsável pela manutenção e limpeza dos banheiros da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Meu trabalho é garantir que este ambiente esteja sempre organizado, limpo e pronto para ser utilizado pelos funcionários.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Às vezes pequenos cuidados fazem uma grande diferença, como manter o espaço organizado e avisar quando algo precisa de manutenção.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de alguma informação sobre este local, pode falar comigo.",
			"faceset": npc_faceset_path
		}
	]
