extends Area2D
@onready var painel: Control = $painel
@onready var label: Label = $label
@onready var fechar: Button = $painel/VBoxContainer/Fechar

var ref_player: Node2D = null
var jogador_on_area: bool = false
var float_tween: Tween


func _ready() -> void:
	painel.visible = false
	label.visible = false
	start_floating_animation()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":		
		jogador_on_area = true
		label.visible = true
		ref_player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		jogador_on_area = false
		label.visible = false
		ref_player = null
		
func _unhandled_input(event: InputEvent) -> void:
	if jogador_on_area and event.is_action_pressed("interect"):
		if not painel.visible:
			get_viewport().set_input_as_handled()
			painel.visible = true
			fechar.grab_focus()
			
			if ref_player:
				ref_player.set_physics_process(false) # Desliga o _physics_process

func start_floating_animation() -> void:
	var original_y = label.position.y
	
	var amplitude = 1.0 

	var duration = 0.3

	float_tween = create_tween().set_loops()
	
	float_tween.tween_property(label, "position:y", original_y - amplitude, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	float_tween.tween_property(label, "position:y", original_y, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)


func _on_fechar_pressed() -> void:
	painel.visible = false
	if jogador_on_area:
		label.visible = true
		
	# --- REATIVA OS COMANDOS/FÍSICA DO PLAYER ---
	if ref_player:
		ref_player.set_physics_process(true) # Devolve o controle ao jogador.
