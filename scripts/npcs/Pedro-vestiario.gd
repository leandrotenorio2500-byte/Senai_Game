extends "res://scripts/npc.gd"

func _ready() -> void:
	atualizar_dialogo()
	spritesheet = load("res://sprites/npcs/npc7.png")
	hframes = 8
	super._ready()
var npc_faceset_path = "res://sprites/npcs/npc3_dialog.png"
var npc_name = "Pedro"

func _on_dialog_completed() -> void:

	super._on_dialog_completed()

	if !Globals.setores_desbloqueados["Vestiario"]:
		Globals.desbloquear_setor("Vestiario")
		QuestManager.progress_quest("identificar_riscos")

		atualizar_dialogo()

func atualizar_dialogo():

	if Globals.setores_desbloqueados["Vestiario"]:

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Antes de iniciar o trabalho, muitos funcionários passam por aqui para trocar de roupa e colocar os equipamentos de proteção.",
				"faceset": npc_faceset_path
			}
		]

	else:

		dialog_data = [
			{
				"title": npc_name,
				"dialog": "Opa, tudo bem? Você é o novo Jovem Aprendiz?",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Nos horários de entrada e saída o movimento é grande. Se alguém deixar mochila, botas ou outros objetos espalhados pelo chão, fica muito fácil alguém tropeçar ou escorregar.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Outra coisa importante é manter os armários e o ambiente sempre limpos. Como várias pessoas utilizam este espaço diariamente, a falta de higiene pode favorecer a contaminação por fungos e outros microrganismos.",
				"faceset": npc_faceset_path
			},
			{
				"title": npc_name,
				"dialog": "Pode parecer um ambiente simples, mas um vestiário organizado e limpo ajuda a evitar muitos problemas antes mesmo do trabalho começar.",
				"faceset": npc_faceset_path
			}
		]
