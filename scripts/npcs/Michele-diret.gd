extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Michele"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/coroa2.png")
	hframes = 8
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Diretoria", false):
		Globals.desbloquear_setor("Diretoria")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Diretoria"})
		Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo() -> void:
	if Globals.setores_desbloqueados.get("Diretoria", false):
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Espero que minhas informações tenham ajudado. Se precisar revisar o mapa, fique à vontade.",
				"faceset": npc_faceset_path
			}
		]
	else:
		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Olá. Vejo que você está conhecendo os setores da empresa e observando os riscos de cada ambiente. Essa é uma etapa muito importante para manter todos seguros.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Muitas pessoas imaginam que um escritório como este não apresenta grandes riscos, mas isso não é verdade. Passamos várias horas trabalhando em frente ao computador, participando de reuniões e analisando documentos.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Uma postura inadequada, uma cadeira mal ajustada ou muitas horas sem pausas podem causar desconfortos e problemas ao longo do tempo.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Segurança não depende apenas de quem trabalha em áreas de produção. Todos os setores têm sua responsabilidade.",
				"faceset": npc_faceset_path
			}
		]
