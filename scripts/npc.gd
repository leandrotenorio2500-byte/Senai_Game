extends Node2D

signal dialog_finished

@export var idle_spritesheet: Texture2D:
	set(value):
		idle_spritesheet = value
		if is_node_ready():
			_apply_animations()

@export var run_spritesheet: Texture2D:
	set(value):
		run_spritesheet = value
		if is_node_ready():
			_apply_animations()

@export var hframes := 8:
	set(value):
		hframes = value
		if is_node_ready():
			_apply_animations()

@export var vframes := 1:
	set(value):
		vframes = value
		if is_node_ready():
			_apply_animations()

func _add_animation(
	frames: SpriteFrames,
	anim_name: String,
	texture: Texture2D,
	speed: float = 6.0
) -> void:

	if texture == null:
		return

	if not frames.has_animation(anim_name):
		frames.add_animation(anim_name)

	var frame_w = texture.get_width() / hframes
	var frame_h = texture.get_height() / vframes

	for row in vframes:
		for col in hframes:
			var atlas := AtlasTexture.new()
			atlas.atlas = texture
			atlas.region = Rect2(
				col * frame_w,
				row * frame_h,
				frame_w,
				frame_h
			)
			frames.add_frame(anim_name, atlas)

	frames.set_animation_speed(anim_name, speed)
	frames.set_animation_loop(anim_name, true)

var dialog_data: Array[Dictionary] = []

@onready var _area: Area2D = $Area2D
@onready var _interact_label: Control = $InteractiveLabel
@onready var _interact_text: Label = $InteractiveLabel/Background/MarginContainer/Label
@onready var _margin: MarginContainer = $InteractiveLabel/Background/MarginContainer
@onready var _panel: NinePatchRect = $InteractiveLabel/Background

var _sprite: AnimatedSprite2D
var _player_nearby: bool = false

func _ajustar_nome() -> void:
	await get_tree().process_frame

	var tamanho_antigo = _panel.size
	var novo_tamanho = _margin.get_combined_minimum_size()

	_panel.position.x -= (novo_tamanho.x - tamanho_antigo.x) / 2.0
	_panel.size.x = novo_tamanho.x

func _ready() -> void:
	_sprite = $AnimatedSprite2D
	_apply_animations()

	_interact_label.visible = true
	_interact_text.text = "..."
	await _ajustar_nome()

	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)

	_animate_label()

func _animate_label() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(_interact_label, "position:y", _interact_label.position.y - 1, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_interact_label, "position:y", _interact_label.position.y, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(_delta: float) -> void:
	if not _player_nearby:
		return

	if Input.is_action_just_pressed("interect"):
		_interact_text.text = "..."
		await _ajustar_nome()

		DialogManager.start_dialog(dialog_data)

		if DialogManager.has_signal("dialog_ended"):
			if not DialogManager.dialog_ended.is_connected(_on_dialog_manager_finished):
				DialogManager.dialog_ended.connect(_on_dialog_manager_finished)

func _on_dialog_manager_finished() -> void:
	if DialogManager.dialog_ended.is_connected(_on_dialog_manager_finished):
		DialogManager.dialog_ended.disconnect(_on_dialog_manager_finished)
	
	# Executa a lógica de sucesso do diálogo
	_on_dialog_completed()

func _on_dialog_completed() -> void:
	emit_signal("dialog_finished")
	#print("Conversa concluída com sucesso com o NPC base!")

func missao_mapa_risco_ativa() -> bool:
	return QuestManager.obter_estado("identificar_riscos") == "em_andamento"
	
func missao_mapa_risco_finalizada() -> bool:
	return QuestManager.obter_estado("identificar_riscos") == "finalizada"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = true
		_interact_text.text = "Falar"
		await _ajustar_nome()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = false
		_interact_text.text = "..."
		await _ajustar_nome()

func _on_animated_sprite_2d_animation_finished() -> void:
	pass

func _apply_animations() -> void:
	if _sprite == null or idle_spritesheet == null:
		return

	var frames := SpriteFrames.new()

	_add_animation(frames, "idle", idle_spritesheet, 5)

	if run_spritesheet != null:
		_add_animation(frames, "run", run_spritesheet, 10)

	_sprite.sprite_frames = frames
	_sprite.play("idle")
		
func play_idle() -> void:
	if _sprite == null:
		return

	if _sprite.sprite_frames.has_animation("idle"):
		if _sprite.animation != "idle":
			_sprite.play("idle")


func play_run() -> void:
	if _sprite == null:
		return

	if _sprite.sprite_frames.has_animation("run"):
		if _sprite.animation != "run":
			_sprite.play("run")
	else:
		play_idle()

func look_left():
	if _sprite:
		_sprite.flip_h = true


func look_right():
	if _sprite:
		_sprite.flip_h = false

func _apply_frames() -> void:
	_apply_animations()
