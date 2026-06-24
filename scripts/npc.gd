extends Node2D

var spritesheet: Texture2D:
	set(value):
		spritesheet = value
		_apply_texture()

var hframes: int = 8:
	set(value):
		hframes = value
		_apply_frames()

var vframes: int = 1:
	set(value):
		vframes = value
		_apply_frames()

var dialog_data: Array[Dictionary] = []

@onready var _area: Area2D = $Area2D
@onready var _interact_label: Control = $InteractiveLabel

var _sprite: AnimatedSprite2D
var _player_nearby: bool = false

func _ready() -> void:
	_sprite = $AnimatedSprite2D
	_apply_texture()
	_interact_label.visible = false
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)
	_animate_label()

func _animate_label() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(_interact_label, "position:y", _interact_label.position.y - 5, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_interact_label, "position:y", _interact_label.position.y, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(_delta: float) -> void:
	if not _player_nearby:
		return
	if Input.is_action_just_pressed("interect"):
		_interact_label.visible = false
		DialogManager.start_dialog(dialog_data)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = true
		_interact_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_nearby = false
		_interact_label.visible = false

func _on_animated_sprite_2d_animation_finished() -> void:
	pass

func _apply_texture() -> void:
	if not is_node_ready():
		return
	if _sprite == null:
		_sprite = $AnimatedSprite2D
	if spritesheet == null:
		return
	var frames := SpriteFrames.new()
	frames.add_animation("idle")
	for col in hframes:
		var atlas := AtlasTexture.new()
		atlas.atlas = spritesheet
		atlas.region = Rect2(
			col * (float(spritesheet.get_width()) / hframes),
			0,
			float(spritesheet.get_width()) / hframes,
			float(spritesheet.get_height()) / vframes
		)
		frames.add_frame("idle", atlas)
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 4.0)
	_sprite.sprite_frames = frames
	_sprite.play("idle")

func _apply_frames() -> void:
	_apply_texture()
