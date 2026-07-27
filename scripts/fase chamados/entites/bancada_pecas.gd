extends Area2D

@onready var _interact_label: Control = $InteractiveLabel

var _player_nearby: bool = false

func _ready() -> void:
	if _interact_label:
		_interact_label.visible = false
		_animate_label()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _animate_label() -> void:
	if _interact_label:
		var tween = create_tween().set_loops()
		tween.tween_property(_interact_label, "position:y", _interact_label.position.y - 5, 0.6)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(_interact_label, "position:y", _interact_label.position.y, 0.6)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(_delta: float) -> void:
	if not _player_nearby:
		return
		
	if Input.is_action_just_pressed("interect"):
		coletar_item()

func coletar_item() -> void:
	# Chama a checagem dinâmica no Autoload Globals

	var item_coletado = Globals.coletar_peca_pendente()
	
	if item_coletado != "":
		print("Você pegou a peça na bancada: ", item_coletado)
		# Opcional: Chamar uma caixa de diálogo avisando o que pegou
		# DialogManager.start_dialog([{"title": "Sistema", "dialog": "Você pegou: " + item_coletado}])
	else:
		print("Você não precisa de nenhuma peça no momento (ou já está carregando o necessário).")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = true
		if _interact_label:
			_interact_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = false
		if _interact_label:
			_interact_label.visible = false
