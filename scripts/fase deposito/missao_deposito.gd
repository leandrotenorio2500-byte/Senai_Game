extends Node2D

@export var tela_prateleira_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for prateleira in get_tree().get_nodes_in_group("prateleiras"):
		print("Conectando:", prateleira.name)
		prateleira.abrir_prateleira.connect(_abrir_prateleira)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _abrir_prateleira(prateleira):
	var tela = tela_prateleira_scene.instantiate()

	add_child(tela)

	tela.abrir(prateleira)
