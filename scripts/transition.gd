extends CanvasLayer

@onready var fill: ColorRect = $fill
@onready var anim: AnimationPlayer = $fill/anim

func mudar_cena(caminho_da_nova_cena: String) -> void:

	var hud = get_tree().current_scene.get_node_or_null("MissionProgress")
	if hud:
		hud.visible = false

	anim.play("transition_out")
	await anim.animation_finished

	get_tree().change_scene_to_file(caminho_da_nova_cena)

	anim.play("transition_in")
	await anim.animation_finished

	# Busca a HUD na nova cena recém-carregada
	hud = get_tree().current_scene.get_node_or_null("MissionProgress")
	
	if hud:
		var estado = QuestManager.obter_estado("identificar_riscos")
		if estado == "em_andamento":
			hud.visible = true
			if hud.has_method("atualizar"):
				hud.atualizar()

func transicao() -> void:
	anim.play("transition_out")
	await anim.animation_finished

func voltar() -> void:
	anim.play("transition_in")
