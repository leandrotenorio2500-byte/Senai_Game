extends CanvasLayer

# 1. Referências aos Slots do Gabinete
@onready var slot_placa_mae = $Gabinete/Slots_Gabinete/Slot_PlacaMae
@onready var slot_fonte = $Gabinete/Slots_Gabinete/Slot_Fonte
@onready var slot_hdd = $Gabinete/Slots_Gabinete/Slot_HDD

# 2. Referências às Peças
@onready var placa_mae = $Pecas_Disponiveis/PlacaMae
@onready var fonte = $Pecas_Disponiveis/Fonte
@onready var hdd = $Pecas_Disponiveis/HDD
@onready var cpu = $Pecas_Disponiveis/CPU
@onready var ram_1 = $Pecas_Disponiveis/RAM_1

# 3. Referências aos Slots da Placa-Mãe
@onready var slot_cpu = $Pecas_Disponiveis/PlacaMae/Slots_PlacaMae/Slot_CPU
@onready var slot_ram_1 = $Pecas_Disponiveis/PlacaMae/Slots_PlacaMae/Slot_RAM_1

# 4. Referência ao Gabinete e Bandeja
@onready var gabinete = $Gabinete
@onready var bandeja = $Bandeja # Certifique-se de que o nó se chama Bandeja na cena

# Controle de Arraste do Gabinete
var arrastando_gabinete: bool = false
var offset_mouse_gabinete: Vector2 = Vector2.ZERO

# Controle de Arraste da Bandeja
var arrastando_bandeja: bool = false
var offset_mouse_bandeja: Vector2 = Vector2.ZERO


func _ready() -> void:
	montar_computador_inicial()
	
	# Conecta os eventos de clique do Gabinete e da Bandeja
	if gabinete is Area2D:
		gabinete.input_event.connect(_on_gabinete_input_event)
	
	if bandeja is Area2D:
		bandeja.input_event.connect(_on_bandeja_input_event)


func _process(_delta: float) -> void:
	# Movimentação do Gabinete
	if arrastando_gabinete:
		gabinete.global_position = gabinete.get_global_mouse_position() - offset_mouse_gabinete
	
	# Movimentação da Bandeja (tudo que estiver solto dentro dela vai se mover junto)
	if arrastando_bandeja:
		bandeja.global_position = bandeja.get_global_mouse_position() - offset_mouse_bandeja


# --- MONTAGEM INICIAL ---

func montar_computador_inicial() -> void:
	encaixar_peca_no_slot(placa_mae, slot_placa_mae)
	encaixar_peca_no_slot(fonte, slot_fonte)
	encaixar_peca_no_slot(hdd, slot_hdd)
	
	encaixar_peca_no_slot(cpu, slot_cpu)
	encaixar_peca_no_slot(ram_1, slot_ram_1)


func encaixar_peca_no_slot(peca: Node2D, slot: Node2D) -> void:
	peca.reparent(slot)
	peca.position = Vector2.ZERO
	peca.rotation = 0
	
	if peca.has_node("CollisionShape2D") and slot.has_node("CollisionShape2D"):
		var shape_peca = peca.get_node("CollisionShape2D").shape as RectangleShape2D
		var shape_slot = slot.get_node("CollisionShape2D").shape as RectangleShape2D
		
		if shape_peca and shape_slot:
			var escala_x = shape_slot.size.x / shape_peca.size.x
			var escala_y = shape_slot.size.y / shape_peca.size.y
			peca.scale = Vector2(escala_x, escala_y)


# --- ARRASTE DO GABINETE ---

func _on_gabinete_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando_gabinete = true
			offset_mouse_gabinete = gabinete.get_global_mouse_position() - gabinete.global_position
			get_viewport().set_input_as_handled()
		else:
			if arrastando_gabinete:
				arrastando_gabinete = false
				get_viewport().set_input_as_handled()


# --- ARRASTE DA BANDEJA ---

func _on_bandeja_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando_bandeja = true
			offset_mouse_bandeja = bandeja.get_global_mouse_position() - bandeja.global_position
			get_viewport().set_input_as_handled()
		else:
			if arrastando_bandeja:
				arrastando_bandeja = false
				get_viewport().set_input_as_handled()


# Soltar o clique fora da colisão cancela os arrastes
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			arrastando_gabinete = false
			arrastando_bandeja = false
