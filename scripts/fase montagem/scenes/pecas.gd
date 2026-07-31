extends Area2D

# Z-Index padrão para quando a peça não estiver sendo arrastada
@export var z_index_padrao: int = 10

# Controle de Drag
var arrastando: bool = false
var offset_mouse: Vector2 = Vector2.ZERO

# Gerenciamento de Slots
var slot_atual: Node2D = null
var slot_detectado: Area2D = null


func _ready() -> void:
	# Conecta os sinais nativos da Area2D
	input_event.connect(_on_input_event)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	if arrastando:
		# Faz a peça seguir o movimento do cursor
		global_position = get_global_mouse_position() - offset_mouse


# 1. EVENTOS DE ENTRADA E CLIQUE DO MOUSE
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			iniciar_arraste()
			# Impede que peças atrás recebam o clique ao mesmo tempo
			get_viewport().set_input_as_handled()
		else:
			if arrastando:
				finalizar_arraste()
				get_viewport().set_input_as_handled()


# Garante que soltar o clique fora da colisão também encerre o arraste
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and arrastando:
			finalizar_arraste()


# 2. LÓGICA DE ARRASTAR E SOLTAR
func iniciar_arraste() -> void:
	arrastando = true
	offset_mouse = get_global_mouse_position() - global_position
	z_index = 100 # Fica por cima de tudo na tela enquanto arrasta
	
	slot_atual = null
	
	# Muda temporariamente para a raiz da cena para mover livremente
	var cena_raiz = get_tree().current_scene
	reparent(cena_raiz)


func finalizar_arraste() -> void:
	arrastando = false
	z_index = z_index_padrao
	
	# Se soltou em cima do slot correto: ENCAIXA
	if slot_detectado != null:
		encaixar_no_slot(slot_detectado)
	else:
		slot_atual = null


# 3. ENCAIXE NO SLOT
func encaixar_no_slot(novo_slot: Node2D) -> void:
	slot_atual = novo_slot
	
	# Muda o pai para o nó do Slot e alinha no centro dele
	reparent(novo_slot)
	global_position = novo_slot.global_position
	rotation = 0


# 4. DETECÇÃO RIGOROSA DE COLISÃO COM SLOTS
func _on_area_entered(area: Area2D) -> void:
	# Nome do slot esperado para esta peça específica (ex: se esta peça é "PlacaMae", o slot deve ser "Slot_PlacaMae")
	var slot_esperado: String = "Slot_" + self.name
	
	# Garante que a peça SÓ detecte o slot que foi feito para ela
	if area.name == slot_esperado:
		slot_detectado = area


func _on_area_exited(area: Area2D) -> void:
	if slot_detectado == area:
		slot_detectado = null
