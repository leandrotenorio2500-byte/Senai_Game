extends Area2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var coin_value := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	anim.play("collect")
	# Do not allow double collect
	await collision.call_deferred("queue_free")
	Globals.coins += coin_value

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
