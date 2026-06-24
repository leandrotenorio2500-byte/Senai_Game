extends Node2D

@export var spritesheet: Texture2D:
	set(value):
		spritesheet = value
		_apply_texture()

@export var hframes: int = 4:
	set(value):
		hframes = value
		_apply_frames()

@export var vframes: int = 1:
	set(value):
		vframes = value
		_apply_frames()

var _sprite: AnimatedSprite2D


func _ready() -> void:
	_sprite = $AnimatedSprite2D
	_apply_texture()


func _on_body_entered(body: Node2D) -> void:
	pass  # coloca aqui o que quiser quando algo entra no colisor


func _on_animated_sprite_2d_animation_finished() -> void:
	pass  # coloca aqui o que quiser quando a animação termina


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
			col * int(spritesheet.get_width() / hframes),
			0,
			int(spritesheet.get_width() / hframes),
			int(spritesheet.get_height() / vframes)
		)
		frames.add_frame("idle", atlas)

	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 4.0)

	_sprite.sprite_frames = frames
	_sprite.play("idle")


func _apply_frames() -> void:
	_apply_texture()
