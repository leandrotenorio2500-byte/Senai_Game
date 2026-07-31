extends Area2D

# Z-Index padrão para quando a peça não estiver sendo arrastada
@export var z_index_padrao: int = 10

# Controle de Drag
var arrastando: bool = false
var offset_mouse: Vector2 = Vector2.ZERO

# Gerenciamento de Alvos (Slot ou Bandeja)
var slot_atual: Node2D = null
var slot_detectado: Area2D = null
var bandeja_detectada: Area2D = null


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
			get_viewport().set_input_as_handled()
		else:
			if arrastando:
				finalizar_arraste()
				get_viewport().set_input_as_handled()


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
	
	# Muda para a raiz da cena para mover livremente
	var cena_raiz = get_tree().current_scene
	reparent(cena_raiz)


func finalizar_arraste() -> void:
	arrastando = false
	z_index = z_index_padrao
	
	# PRIO 1: Se soltou em cima de um Slot correto do computador
	if slot_detectado != null:
		encaixar_no_slot(slot_detectado)
	# PRIO 2: Se soltou em cima da Bandeja
	elif bandeja_detectada != null:
		guardar_na_bandeja(bandeja_detectada)
	# PRIO 3: Se soltou na mesa/vazio
	else:
		slot_atual = null


# 3. ENCAIXE E ACOPLAMENTO
func encaixar_no_slot(novo_slot: Node2D) -> void:
	slot_atual = novo_slot
	reparent(novo_slot)
	global_position = novo_slot.global_position
	rotation = 0


func guardar_na_bandeja(bandeja: Node2D) -> void:
	slot_atual = null
	# Virar filho da bandeja faz a peça andar junto quando a bandeja for movida
	reparent(bandeja)


# 4. DETECÇÃO DE COLISÃO COM SLOTS E BANDEJA
func _on_area_entered(area: Area2D) -> void:
	# Identifica se é o Slot correto para esta peça
	if area.name == "Slot_" + self.name:
		slot_detectado = area
	# Identifica se a área é a Bandeja
	elif area.name == "Bandeja" or area.name.begins_with("Bandeja"):
		bandeja_detectada = area


func _on_area_exited(area: Area2D) -> void:
	if slot_detectado == area:
		slot_detectado = null
	if bandeja_detectada == area:
		bandeja_detectada = null
