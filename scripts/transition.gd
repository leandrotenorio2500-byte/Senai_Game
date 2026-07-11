extends CanvasLayer

@onready var fill: ColorRect = $fill
@onready var anim: AnimationPlayer = $fill/anim

func mudar_cena(caminho_da_nova_cena: String) -> void:
	anim.play("transition_out") 
	
	await anim.animation_finished
	
	get_tree().change_scene_to_file(caminho_da_nova_cena)
	
	anim.play("transition_in")
