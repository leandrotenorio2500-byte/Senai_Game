extends Button

func _ready() -> void:
	pass # Replace with function body.

var tipo_risco = 0
@onready var toque: AudioStreamPlayer = $"../../../../../toque"

@export var setor : String
@export var mapa: CanvasLayer

func atualizar_cor():

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

func _pressed():
	toque.play()
	if !Globals.setores_desbloqueados[setor]:
		return
	tipo_risco = mapa.risco_selecionado

	atualizar_cor()

	mapa.salvar_respostas()

	mapa.verificar_setores_completos()
	
func atualizar_estado():

	disabled = !Globals.setores_desbloqueados[setor]

	if disabled:
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color.WHITE
