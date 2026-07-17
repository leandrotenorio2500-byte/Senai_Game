extends Node2D

func _ready() -> void:
	pass
	
func carregar_proxima_fase():
	Transicao.mudar_cena("")

func _on_default_skin_button_pressed() -> void:
	SkinManager.set_skin("default")
	atualizar_sprite_do_player()
	
func _on_npc_6_skin_button_pressed() -> void:
	SkinManager.set_skin("npc_6")
	atualizar_sprite_do_player()

func mostrar_botoes() -> void:
	$AnimationPlayer.play("buttons")
	
func _on_button_pressed() -> void:
	$buttonManager.visible = false

	$Player.play_run()
	$AnimationPlayer.play("saida")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://prefabs/title_screen.tscn")
	
func atualizar_sprite_do_player() -> void:
	# Verifique se o nó do Player existe nesta cena
	if has_node("Player"):
		# Se o seu nó $Player for o CharacterBody2D, precisamos pegar o nó de animação dele
		var anim_node = $Player.get_node("AnimatedSprite2D") as AnimatedSprite2D
		if anim_node:
			anim_node.sprite_frames = SkinManager.get_current_sprite_frames()
			anim_node.play("idle") # Toca o idle da nova skin imediatamente
