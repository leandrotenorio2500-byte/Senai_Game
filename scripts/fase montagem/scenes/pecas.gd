extends Area2D

@export var id_peca: String = ""
@export var z_index_padrao: int = 10

var arrastando: bool = false
var offset_mouse: Vector2 = Vector2.ZERO
var escala_original: Vector2 = Vector2.ONE

var slot_atual: Node2D = null
var slot_detectado: Area2D = null
var bandeja_detectada: Area2D = null

@onready var btn_inspecionar: Button = $BtnInspecionar if has_node("BtnInspecionar") else null


func _ready() -> void:
	if id_peca == "":
		id_peca = name
		
	escala_original = scale
	
	input_event.connect(_on_input_event)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	if arrastando:
		# Usa a posição do mouse na TELA (Viewport) para evitar bugs com a Câmera do Player
		global_position = get_viewport().get_mouse_position() - offset_mouse


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if _clicou_no_botao_inspecionar():
			return

		if event.pressed:
			iniciar_arraste()
			get_viewport().set_input_as_handled()
		elif arrastando:
			finalizar_arraste()
			get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and arrastando:
			finalizar_arraste()


func _clicou_no_botao_inspecionar() -> bool:
	if is_instance_valid(btn_inspecionar) and btn_inspecionar.visible:
		return btn_inspecionar.get_global_rect().has_point(get_viewport().get_mouse_position())
	return false


func iniciar_arraste() -> void:
	arrastando = true
	offset_mouse = get_viewport().get_mouse_position() - global_position
	
	z_as_relative = false
	z_index = 100


func finalizar_arraste() -> void:
	arrastando = false
	z_as_relative = true
	z_index = z_index_padrao
	
	if is_instance_valid(slot_detectado):
		encaixar_no_slot(slot_detectado)
	elif is_instance_valid(bandeja_detectada):
		guardar_na_bandeja(bandeja_detectada)


func encaixar_no_slot(novo_slot: Node2D) -> void:
	if not is_instance_valid(novo_slot):
		return

	slot_atual = novo_slot
	reparent(novo_slot, false)
	
	position = Vector2.ZERO
	rotation = 0
	scale = escala_original
	
	var cena_principal = get_tree().root.get_node_or_null("BancadaMontagem")
	if not cena_principal:
		cena_principal = get_tree().current_scene
		
	if is_instance_valid(cena_principal) and cena_principal.has_method("verificar_conclusao_reparo"):
		cena_principal.verificar_conclusao_reparo(id_peca)


func guardar_na_bandeja(bandeja: Node2D) -> void:
	if not is_instance_valid(bandeja):
		return

	slot_atual = null
	reparent(bandeja, false)
	scale = escala_original


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Slot_" + self.name or area.name == "Slot_" + id_peca:
		slot_detectado = area
	elif area.name.begins_with("Bandeja"):
		bandeja_detectada = area


func _on_area_exited(area: Area2D) -> void:
	if slot_detectado == area:
		slot_detectado = null
	if bandeja_detectada == area:
		bandeja_detectada = null
