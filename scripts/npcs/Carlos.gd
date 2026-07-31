extends "res://scripts/npc.gd"

var npc_faceset_path = "res://sprites/Mini UI/heads/Jobson.png"
var npc_name = "Jobson"

func _ready() -> void:
	atualizar_dialogo()
	idle_spritesheet = load("res://sprites/npcs/operario3.png")
	hframes = 8
	super._ready()

func _on_dialog_completed() -> void:
	super._on_dialog_completed()

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if not Globals.setores_desbloqueados.get("Producao", false):
			Globals.desbloquear_setor("Producao")

			QuestManager.progredir_missao(
				"identificar_riscos",
				{"setor": "Producao"}
			)

			Globals.abrir_mapa.emit()

		atualizar_dialogo()

func atualizar_dialogo():

	var estado_mapa = QuestManager.obter_estado("identificar_riscos")

	if estado_mapa == "em_andamento":

		if Globals.setores_desbloqueados.get("Producao", false):
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
				"dialog": "Opa, tudo bem? Você é o novo Jovem Aprendiz?",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Aqui na Produção trabalhamos com diversas máquinas que fazem bastante barulho durante todo o expediente.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Além disso, utilizamos produtos químicos na limpeza dos equipamentos e há empilhadeiras circulando constantemente pelo setor.",
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
			"dialog": "Olá! Seja bem-vindo ao setor de Produção. É aqui que transformamos materiais e componentes em produtos que serão enviados para nossos clientes.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "No nosso dia a dia trabalhamos seguindo uma sequência de etapas, sempre buscando manter a qualidade e a organização durante todo o processo.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Cada pessoa da equipe tem uma função importante. Por isso, é essencial prestar atenção às orientações, respeitar os procedimentos e trabalhar em conjunto.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Se precisar de alguma informação sobre como as coisas funcionam por aqui, pode perguntar. É sempre bom conhecer melhor o ambiente onde trabalhamos.",
			"faceset": npc_faceset_path
		}
	]
