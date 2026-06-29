extends CanvasLayer

@onready var player_icon: TextureRect = $TextureRect2
@onready var anim: AnimationPlayer = $AnimationPlayer

var esta_animando: bool = false

var positions = {
	"recep": Vector2(130, 150),
	"corredor": Vector2(174, 150),
	"1andar": Vector2(173, 118),
	"almoxarifado": Vector2(130, 118),
	"banheiro": Vector2(192, 118),
	"refeitorio": Vector2(288, 118),
	"deposito": Vector2(192, 150),
	"producao": Vector2(268, 150),
}

func atualizar_posicao():
	if Globals.area_atual in positions:
		player_icon.position = positions[Globals.area_atual]

func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("abrir_mapa"):
		# Se já estiver abrindo ou fechando, ignora o clique para não bugar
		if esta_animando:
			return
			
		if not visible:
			# --- ABRIR O MAPA ---
			esta_animando = true
			visible = true
			atualizar_posicao()
			
			$AnimationPlayer.play("fade_in")
			#get_tree().paused = true
			
			# Espera o fade_in acabar antes de permitir fechar
			await $AnimationPlayer.animation_finished
			esta_animando = false
		else:
			# --- FECHAR O MAPA ---
			esta_animando = true
			$AnimationPlayer.play("fade_out")
			
			# Espera o fade_out acabar antes de sumir e despausar
			await $AnimationPlayer.animation_finished
			
			visible = false
			#get_tree().paused = false
			esta_animando = false
