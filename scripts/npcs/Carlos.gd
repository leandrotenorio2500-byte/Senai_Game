extends "res://scripts/npc.gd"

func get_dialogo_setor() -> Array[Dictionary]:
	return [
		{
			"title": npc_name,
			"dialog": "O depósito é responsável por receber, armazenar e distribuir materiais para todos os setores da empresa.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Aqui organizamos o estoque, conferimos mercadorias e garantimos que cada setor receba os materiais necessários para o trabalho.",
			"faceset": npc_faceset_path
		}
	]

func _ready() -> void:
	npc_faceset_path = "res://sprites/Mini UI/heads/Jobson.png"
	npc_name = "Jobson - Líder da Produção"
	idle_spritesheet = load("res://sprites/npcs/operario3.png")
	hframes = 8
	super._ready()
	atualizar_dialogo()
	
func get_dialog_options() -> Array:
	return [
		{
			"text":"Setor de Produção",
			"id":"setor"
		},
		{
			"text":"Encerrar",
			"id":"exit"
		}
	]
	
func on_dialog_option_selected(option: Dictionary) -> void:

	match option.id:

		"setor":
			DialogManager.show_dialog(get_dialogo_setor())

		"exit":
			DialogManager.end_conversation()
	
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
			"dialog": "Aqui na Produção temos bastante movimentação. As máquinas ficam funcionando durante boa parte do expediente e o barulho é constante.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Também utilizamos alguns produtos químicos para a limpeza e manutenção dos equipamentos, então é importante tomar cuidado com esses materiais.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "O trabalho também envolve atividades repetitivas, esforço físico e, dependendo da tarefa, precisamos manter certas posições por bastante tempo.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Além disso, temos máquinas, equipamentos e empilhadeiras circulando pelo setor. É importante ficar atento para evitar acidentes.",
			"faceset": npc_faceset_path
		},
		{
			"title": npc_name,
			"dialog": "Acho que essas informações podem ajudar você a identificar os riscos da Produção no Mapa de Risco.",
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
