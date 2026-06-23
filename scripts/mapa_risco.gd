extends CanvasLayer

@onready var player_icon: TextureRect = $TextureRect2


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
		visible = !visible
		
		if visible:
			atualizar_posicao()
			
		get_tree().paused = visible
