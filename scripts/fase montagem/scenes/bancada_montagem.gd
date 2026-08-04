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
@onready var bandeja = $Bandeja

# Configurações do Diálogo
var nome_npc: String = "Diagnóstico de Hardware"
var faceset_npc: String = "res://sprites/npcs/npc3_dialog.png"
var _processando_clique: bool = false

# Controle de Arraste
var arrastando_gabinete: bool = false
var offset_mouse_gabinete: Vector2 = Vector2.ZERO
var arrastando_bandeja: bool = false
var offset_mouse_bandeja: Vector2 = Vector2.ZERO


func _ready() -> void:
	# Define a camada deste CanvasLayer para 1 (garante que a UI do DialogManager em camada superior apareça na frente)
	self.layer = 1
	
	montar_computador_inicial()
	conectar_botoes_inspecao()
	
	if gabinete is Area2D:
		gabinete.input_event.connect(_on_gabinete_input_event)
	
	if bandeja is Area2D:
		bandeja.input_event.connect(_on_bandeja_input_event)


func _process(_delta: float) -> void:
	if arrastando_gabinete:
		gabinete.global_position = gabinete.get_global_mouse_position() - offset_mouse_gabinete
	
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
	if not is_instance_valid(peca) or not is_instance_valid(slot):
		push_error("[ERRO MONTAGEM] Peça ou Slot inválido!")
		return
		
	peca.reparent(slot, false)
	peca.position = Vector2.ZERO
	peca.rotation = 0
	
	if peca.has_node("CollisionShape2D") and slot.has_node("CollisionShape2D"):
		var shape_peca = peca.get_node("CollisionShape2D").shape as RectangleShape2D
		var shape_slot = slot.get_node("CollisionShape2D").shape as RectangleShape2D
		
		if shape_peca and shape_slot:
			var escala_x = shape_slot.size.x / shape_peca.size.x
			var escala_y = shape_slot.size.y / shape_peca.size.y
			peca.scale = Vector2(escala_x, escala_y)
			
			if "escala_original" in peca:
				peca.escala_original = peca.scale


# --- SISTEMA DE INSPEÇÃO POR BOTÃO ---

func conectar_botoes_inspecao() -> void:
	var pecas = [placa_mae, fonte, hdd, cpu, ram_1]
	for peca in pecas:
		if is_instance_valid(peca):
			var btn = peca.get_node_or_null("BtnInspecionar") as Button
			if btn:
				btn.focus_mode = Control.FOCUS_NONE
				btn.mouse_filter = Control.MOUSE_FILTER_STOP
				
				# Desconecta para evitar conexões duplicadas
				if btn.pressed.is_connected(_on_botao_inspecionar_pressed):
					btn.pressed.disconnect(_on_botao_inspecionar_pressed)
					
				btn.pressed.connect(_on_botao_inspecionar_pressed.bind(peca))
				print("[OK] Botão de inspeção conectado na peça: ", peca.name)
			else:
				print("[AVISO] 'BtnInspecionar' não encontrado em: ", peca.name)


func _on_botao_inspecionar_pressed(peca_alvo: Node2D) -> void:
	print("[INSPEÇÃO] Botão pressionado para a peça: ", peca_alvo.name)
	
	if _processando_clique:
		return
	_processando_clique = true

	var texto_fala: String = ""
	var quest = QuestManager.obter_missao("manutencao_bancada") as QuestManutencao

	if not quest:
		print("[ALERTA] Nenhuma QuestManutencao 'manutencao_bancada' ativa!")
		texto_fala = "Você inspecionou " + peca_alvo.name + ". Tudo parece em ordem."
	else:
		var id_peca_clicada = peca_alvo.name.to_lower()
		var peca_defeito = quest.obter_peca_necessaria().to_lower()
		
		var eh_peca_com_defeito = false
		if ("fonte" in id_peca_clicada and "fonte" in peca_defeito) \
		or (("ram" in id_peca_clicada or "memoria" in id_peca_clicada) and "ram" in peca_defeito) \
		or (("sata" in id_peca_clicada or "hdd" in id_peca_clicada or "cabo" in id_peca_clicada) and ("hdd" in peca_defeito or "cabo" in peca_defeito)) \
		or ("cpu" in id_peca_clicada and "cpu" in peca_defeito) \
		or ("placa" in id_peca_clicada and "placa" in peca_defeito):
			eh_peca_com_defeito = true

		if eh_peca_com_defeito:
			quest.identificar_defeito()
			texto_fala = "Você inspecionou " + peca_alvo.name + " e confirmou: ESTÁ COM DEFEITO! Vá ao estoque buscar a peça nova."
		else:
			texto_fala = "Você inspecionou " + peca_alvo.name + ": Esta peça está funcionando perfeitamente."

	var dialog_data: Array[Dictionary] = [
		{
			"title": nome_npc,
			"dialog": texto_fala,
			"faceset": faceset_npc
		}
	]
	
	DialogManager.start_dialog(dialog_data)
	
	if DialogManager.has_signal("dialog_ended"):
		await DialogManager.dialog_ended
		
	_processando_clique = false


# --- ARRASTE DO GABINETE E BANDEJA ---

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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			arrastando_gabinete = false
			arrastando_bandeja = false
