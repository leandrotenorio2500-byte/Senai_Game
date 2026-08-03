extends Node


signal activity_finished(activity_id: String, result: Dictionary)

var _hud: CanvasLayer = null
var atividade_atual: Node = null
var contexto_atual: Dictionary = {}

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud
	
func iniciar_atividade(
	activity_scene: PackedScene,
	activity_id: String,
	contexto: Dictionary = {}
) -> void:

	print("=== ActivityManager chamado ===")
	print("Cena recebida: ", activity_scene)

	if atividade_atual:
		print("Já existe uma atividade aberta.")
		return


	contexto_atual = contexto


	print("Instanciando atividade...")

	atividade_atual = activity_scene.instantiate()

	print("Instância criada: ", atividade_atual)


	get_tree().root.add_child(atividade_atual)

	print("Adicionado ao root")


	if atividade_atual.has_signal("atividade_finalizada"):

		atividade_atual.atividade_finalizada.connect(
			_finalizar_atividade.bind(activity_id)


		)

	if atividade_atual.has_signal("equipamento_selecionado"):

		atividade_atual.equipamento_selecionado.connect(
			_on_equipamento_selecionado
		)

func _on_equipamento_selecionado(item: String) -> void:

	print("Equipamento analisado:", item)

	var npc = contexto_atual.get("npc")

	if npc and npc.has_method("avaliar_equipamento"):
		npc.avaliar_equipamento(item)

func _finalizar_atividade(
	resultado: Dictionary,
	activity_id: String
) -> void:


	print("Atividade finalizada:", activity_id)
	print("Resultado:", resultado)


	emit_signal(
		"activity_finished",
		activity_id,
		resultado
	)


	if atividade_atual:

		atividade_atual.queue_free()


	atividade_atual = null
	contexto_atual.clear()



func obter_contexto() -> Dictionary:

	return contexto_atual
	
