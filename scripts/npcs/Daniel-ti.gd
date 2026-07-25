extends "res://scripts/npc.gd"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/npc_ti.png")
	hframes = 8
	super._ready()
var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Daniel"

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	if not Globals.setores_desbloqueados.get("Tecnico", false):
		Globals.desbloquear_setor("Tecnico")
		
		# Chamada do novo método de progressão de missão
		QuestManager.progredir_missao("identificar_riscos", {"setor": "Tecnico"})
		Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	if Globals.setores_desbloqueados["Tecnico"]:

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
				"dialog": "Oi! Eu sou responsável pelo setor de TI. Sempre que algum computador ou equipamento apresenta problemas, é aqui que ele vem parar.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Além de trabalhar com computadores ligados à energia elétrica, às vezes precisamos abrir equipamentos, trocar componentes e organizar muitos cabos.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Cabos espalhados pelo chão podem provocar tropeços, então manter tudo organizado é uma questão de segurança.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Quem trabalha com manutenção também precisa ter bastante atenção antes de mexer em qualquer equipamento energizado.",
				"faceset": npc_faceset_path
			}
		]
