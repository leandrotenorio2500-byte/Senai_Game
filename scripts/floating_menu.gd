extends CanvasLayer

# Referências flexíveis para evitar o erro 'null instance'
@onready var floating_button: Button = find_child("Button", true, false)
@onready var menu_popup: Control = find_child("MenuPopup", true, false)

# Variáveis para a física da bolinha
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var was_dragged: bool = false
const DRAG_THRESHOLD: float = 10.0

func _ready() -> void:
	# Ajusta os filtros de mouse para não bloquear cliques do jogo
	$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if menu_popup:
		menu_popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
		menu_popup.visible = false
	else:
		print_rich("[color=red]Erro: Nó MenuPopup não foi encontrado![/color]")
		
	if floating_button:
		floating_button.gui_input.connect(_on_button_gui_input)
		
	_conectar_botoes_das_missoes()

# --- SISTEMA DA BOLINHA FLUTUANTE ---

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			was_dragged = false
			drag_offset = floating_button.global_position - event.global_position
		else:
			if dragging:
				dragging = false
				if was_dragged:
					_snap_to_nearest_edge()
				else:
					_toggle_menu()

	elif event is InputEventMouseMotion and dragging:
		var new_pos = event.global_position + drag_offset
		if floating_button.global_position.distance_to(new_pos) > DRAG_THRESHOLD or was_dragged:
			was_dragged = true
			_update_button_position(new_pos)

	elif event is InputEventScreenDrag and dragging:
		was_dragged = true
		_update_button_position(event.global_position + drag_offset)

func _update_button_position(target_pos: Vector2) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var button_size = floating_button.size
	
	target_pos.x = clamp(target_pos.x, 0, viewport_size.x - button_size.x)
	target_pos.y = clamp(target_pos.y, 0, viewport_size.y - button_size.y)
	
	floating_button.global_position = target_pos

func _snap_to_nearest_edge() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var button_size = floating_button.size
	var current_pos = floating_button.global_position
	
	var target_x: float
	if (current_pos.x + button_size.x / 2.0) < (viewport_size.x / 2.0):
		target_x = 0.0
	else:
		target_x = viewport_size.x - button_size.x
		
	var target_pos = Vector2(target_x, current_pos.y)
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(floating_button, "global_position", target_pos, 0.3)

func _toggle_menu() -> void:
	if menu_popup:
		menu_popup.visible = !menu_popup.visible

# --- CONEXÃO E LÓGICA DOS BOTÕES DE CADA MISSÃO ---

func _conectar_botoes_das_missoes() -> void:
	_conectar_coluna("Quiz", [_teleportar_quiz, _iniciar_quiz, _objetivo_quiz, _finalizar_quiz])
	_conectar_coluna("Chamados", [_teleportar_chamados, _iniciar_chamados, _objetivo_chamados, _finalizar_chamados])
	_conectar_coluna("Curriculos", [_teleportar_curriculos, _iniciar_curriculos, _objetivo_curriculos, _finalizar_curriculos])
	_conectar_coluna("Riscos", [_teleportar_riscos, _iniciar_riscos, _objetivo_riscos, _finalizar_riscos])

func _conectar_coluna(nome_coluna: String, funcoes: Array) -> void:
	if not menu_popup:
		return
		
	var container = menu_popup.find_child(nome_coluna, true, false)
	if container:
		# Busca todos os botões filhos, inclusive dentro da pasta 'Buttons'
		var botoes = container.find_children("*", "Button", true, false)
		
		if botoes.is_empty():
			print_rich("[color=yellow]Aviso: Container '" + nome_coluna + "' encontrado, mas sem botões![/color]")
		else:
			for i in range(min(botoes.size(), funcoes.size())):
				botoes[i].pressed.connect(funcoes[i])
				print("Conectado: Botão '", botoes[i].name, "' em '", nome_coluna, "'")
	else:
		print_rich("[color=red]Erro: Container '" + nome_coluna + "' não foi encontrado![/color]")

# --- FUNÇÕES DAS MISSÕES ---

# 1. QUIZ
func _teleportar_quiz() -> void:
	print("Debug: Teleportando para o Quiz...")
	menu_popup.visible = false
	get_tree().change_scene_to_file("res://scene/deposito.tscn")

func _iniciar_quiz() -> void:
	print("Debug: Iniciando Quiz...")

func _objetivo_quiz() -> void:
	print("Debug: Objetivo Quiz...")

func _finalizar_quiz() -> void:
	print("Debug: Finalizar Quiz...")

# 2. CHAMADOS
func _teleportar_chamados() -> void:
	print("Debug: Teleportando para Chamados...")
	menu_popup.visible = false
	get_tree().change_scene_to_file("res://scene/sala_tecnica.tscn")

func _iniciar_chamados() -> void:
	print("Debug: Iniciando Chamados...")

func _objetivo_chamados() -> void:
	print("Debug: Objetivo Chamados...")

func _finalizar_chamados() -> void:
	print("Debug: Finalizar Chamados...")

# 3. CURRÍCULOS
func _teleportar_curriculos() -> void:
	print("Debug: Teleportando para Currículos...")
	menu_popup.visible = false
	get_tree().change_scene_to_file("res://scene/rh.tscn")

func _iniciar_curriculos() -> void:
	print("Debug: Iniciando Currículos...")

func _objetivo_curriculos() -> void:
	print("Debug: Objetivo Currículos...")

func _finalizar_curriculos() -> void:
	print("Debug: Finalizar Currículos...")

# 4. RISCOS
func _teleportar_riscos() -> void:
	print("Debug: Teleportando para Riscos...")
	menu_popup.visible = false
	get_tree().change_scene_to_file("res://scene/recep.tscn")

func _iniciar_riscos() -> void:
	print("Debug: Iniciando Riscos...")

func _objetivo_riscos() -> void:
	print("Debug: Objetivo Riscos...")

func _finalizar_riscos() -> void:
	print("Debug: Finalizar Riscos...")
