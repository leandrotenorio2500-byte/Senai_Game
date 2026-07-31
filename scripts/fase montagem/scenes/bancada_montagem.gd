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

# 3. Referências aos Slots da Placa-Mãe (que estão dentro da peça PlacaMae)
@onready var slot_cpu = $Pecas_Disponiveis/PlacaMae/Slots_PlacaMae/Slot_CPU
@onready var slot_ram_1 = $Pecas_Disponiveis/PlacaMae/Slots_PlacaMae/Slot_RAM_1


func _ready() -> void:
	montar_computador_inicial()


func montar_computador_inicial() -> void:
	# ETAPA A: Encaixar as peças principais no Gabinete
	encaixar_peca_no_slot(placa_mae, slot_placa_mae)
	encaixar_peca_no_slot(fonte, slot_fonte)
	encaixar_peca_no_slot(hdd, slot_hdd)
	
	# ETAPA B: Encaixar as peças menores na Placa-Mãe
	# (Como a Placa-Mãe já foi para o Gabinete, os slots dela vão junto!)
	encaixar_peca_no_slot(cpu, slot_cpu)
	encaixar_peca_no_slot(ram_1, slot_ram_1)


func encaixar_peca_no_slot(peca: Node2D, slot: Node2D) -> void:
	peca.reparent(slot)
	peca.position = Vector2.ZERO
	peca.rotation = 0
	
	# Pega o tamanho dos retângulos de colisão (CollisionShape2D) de ambos
	var shape_peca = peca.get_node("CollisionShape2D").shape as RectangleShape2D
	var shape_slot = slot.get_node("CollisionShape2D").shape as RectangleShape2D
	
	if shape_peca and shape_slot:
		# Calcula a proporção necessária para a peça preencher o slot
		var escala_x = shape_slot.size.x / shape_peca.size.x
		var escala_y = shape_slot.size.y / shape_peca.size.y
		
		# Aplica a nova escala calculada
		peca.scale = Vector2(escala_x, escala_y)
