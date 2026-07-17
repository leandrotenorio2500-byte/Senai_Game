extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var tipo_risco = 0

@export var mapa: CanvasLayer

func _pressed():

	tipo_risco = mapa.risco_selecionado

	match tipo_risco:

		mapa.TipoRisco.NENHUM:
			modulate = Color.WHITE

		mapa.TipoRisco.QUIMICO:
			modulate = Color.RED

		mapa.TipoRisco.FISICO:
			modulate = Color.GREEN

		mapa.TipoRisco.BIOLOGICO:
			modulate = Color(0.55,0.27,0.07)

		mapa.TipoRisco.ERGONOMICO:
			modulate = Color.YELLOW

		mapa.TipoRisco.ACIDENTE:
			modulate = Color.BLUE
