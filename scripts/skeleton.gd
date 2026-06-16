extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_starting_position: Node2D = $BoneStartingPosition
const SPINNING_BONE = preload("uid://bl84iksmu7d7t")

enum SkeletonState {
	idle,
	attack,
	dead
}

@export var enemy_score = 100

const SPEED = 0.0
const JUMP_VELOCITY = -300.0

var direction = 1
var can_throw = true

var status: SkeletonState

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		SkeletonState.idle:
			walk_state(delta)
		SkeletonState.attack:
			attack_state(delta)
		SkeletonState.dead:
			dead_state(delta)

	move_and_slide()

func go_to_walk_state():
	status = SkeletonState.idle
	anim.play("idle")
	
func walk_state(_delta):
	if anim.frame == 3 or anim.frame == 4:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0 
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return
	
func go_to_attack_state():
	status = SkeletonState.attack
	anim.play("attack")
	velocity.x = 0
	can_throw = true
	
func attack_state(_delta):
	if anim.frame == 2 && can_throw:
		throw_bone()
		can_throw = false
		return
	
func go_to_dead_state():
	status = SkeletonState.dead
	anim.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	Globals.score += enemy_score
	
func dead_state(_delta):
	pass
	
func take_damage():
	go_to_dead_state()

func throw_bone():
	var new_bone = SPINNING_BONE.instantiate()
	add_sibling(new_bone)
	new_bone.position = bone_starting_position.global_position
	new_bone.set_direction(self.direction)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return
