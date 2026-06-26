extends CharacterBody2D

func _physics_process(delta: float) -> void:
	# 1. Calcula a gravidade (adiciona à velocidade)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. SEU NPC PRECISA DISSO PARA SE MOVER:
	move_and_slide()
