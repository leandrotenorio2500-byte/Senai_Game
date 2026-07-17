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

	hud = get_tree().current_scene.get_node_or_null("MissionProgress")
	if hud and QuestManager.quests["identificar_riscos"]["started"] \
	and !QuestManager.quests["identificar_riscos"]["completed"]:
		hud.visible = true
		hud.atualizar()

func transicao():

	anim.play("transition_out")

	await anim.animation_finished


func voltar():

	anim.play("transition_in")
	
