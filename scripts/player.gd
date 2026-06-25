extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var left_wall_detector: RayCast2D = $LeftWallDetector
@onready var right_wall_detector: RayCast2D = $RightWallDetector
@onready var one_way_block_detector: RayCast2D = $OneWayBlockDetector
@onready var left_danger_detector: RayCast2D = $LeftDangerDetector
@onready var right_danger_detector: RayCast2D = $RightDangerDetector

enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	duck,
	slide,
	wall,
	dead
}

@export var max_speed = 120.0
const JUMP_VELOCITY = -300.0

@export var acceleration = 350
@export var decceleration = 350
@export var slide_decceleration = 100
@export var wall_acceleration = 350
@export var wall_jump_velocity = 200

var knockback_vector := Vector2.ZERO
var blocked: bool = false

var direction = 0

var jump_count = 0
@export var max_jump_count = 2

var status: PlayerState

func _ready() -> void:
	
	Globals.player_life = 3
	go_to_idle_state()
	
	# Checa se o player veio de um teleporte
	if Globals.should_position:
		global_position = Globals.next_player_position
		
		# Reseta a variável para não teleportar de novo por engano depois
		Globals.should_position = false
	

func _physics_process(delta: float) -> void:	
	if blocked:
		velocity.x = 0
		move_and_slide()
		return	
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.duck:
			duck_state(delta)
		PlayerState.slide:
			slide_state(delta)
		PlayerState.wall:
			wall_state(delta)
		PlayerState.dead:
			dead_state(delta)
			
	if knockback_vector != Vector2.ZERO:
		velocity += knockback_vector
	
	move_and_slide()
	drop_plataform()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func idle_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return		
		
	if Input.is_action_pressed("duck"):
		if can_fall_one_way_terrain():
			fall_one_way_terrain()
			return
		else:
			go_to_duck_state()
			return		
	
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
func walk_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return 
	
	if Input.is_action_just_pressed("duck"):
		go_to_slide_state()
		return 
	
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return	

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	
func jump_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return 
		
	if velocity.y > 0:
		go_to_fall_state()
		return
			
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")

func fall_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return 
		
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
			return
		else: 
			go_to_walk_state()
			return
		
	if (left_wall_detector.is_colliding() or right_wall_detector.is_colliding()) && is_on_wall():
		go_to_wall_state()
		return
			
func go_to_duck_state():
	status = PlayerState.duck
	anim.play("duck")
	set_small_collider()
	
func duck_state(delta):
	apply_gravity(delta)
	update_direction()
	
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return
		
func exit_from_duck_state():
	set_large_collider()
	
func go_to_slide_state():
	status = PlayerState.slide
	anim.play("slide")
	set_small_collider()
	
func slide_state(delta):
	apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0, slide_decceleration * delta)
	
	if Input.is_action_just_released("duck"):
		exit_from_slide_state()
		go_to_walk_state()
		return
		
	if velocity.x == 0:
		exit_from_slide_state()
		go_to_duck_state()
	
func exit_from_slide_state():
	set_large_collider()
	
func go_to_wall_state():
	status = PlayerState.wall
	anim.play("wall")
	velocity = Vector2.ZERO
	jump_count = 0	

func wall_state(delta):
	velocity.y += wall_acceleration * delta
	
	if left_wall_detector.is_colliding():
		anim.flip_h = true
		direction = 1
	elif right_wall_detector.is_colliding():
		anim.flip_h = false
		direction = -1
	else:
		go_to_fall_state()
		return
	
	if is_on_floor():
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_jump_velocity * direction
		go_to_jump_state()
		return
	
func exit_from_wall_state():
	pass
	
func go_to_dead_state():
	if status == PlayerState.dead:
		return
	
	status = PlayerState.dead
	anim.play("dead")
	
	Globals.coins = 0
	Globals.score = 0
	
	velocity.x = 0
	
	await anim.animation_finished
	
	get_tree().change_scene_to_file("res://prefabs/game_over.tscn")
	
func dead_state(delta):
	apply_gravity(delta)
		
func move(delta):
	update_direction()
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration * delta)

func update_direction():
	direction = Input.get_axis("left", "right")
	if direction < 0:
		anim.flip_h = true
	elif direction > 0: 
		anim.flip_h = false
	
func can_jump() -> bool:
	return jump_count < max_jump_count

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func set_small_collider(): 
	collision_shape.shape.height = 20.5
	
	hitbox_collision_shape.shape.size.y = 10
	hitbox_collision_shape.position.y = 4
	
func set_large_collider():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 22
	collision_shape.position.y = 1
	collision_shape.position.x = 1
	
	hitbox_collision_shape.shape.size.y = 15
	hitbox_collision_shape.position.y = 0.5

func _on_hitbox_area_entered(area: Area2D) -> void:
	if status == PlayerState.dead: return
	
	if area.is_in_group("Enemies"):
		hit_enemy(area)
		return
	elif area.is_in_group("LethalArea"):
		hit_lethal_area(area)
		return
	elif area.is_in_group("Projects"):
		hit_project(area)
		return
		
var jumped_on_death := false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if status == PlayerState.dead: return
	
	if body.is_in_group("LethalArea"):
		if not jumped_on_death:
			go_to_jump_state()
			jumped_on_death = true
		go_to_dead_state()
		return

func hit_enemy(area: Area2D):
	if velocity.y > 0:
		area.get_parent().take_damage()
		go_to_jump_state()
		return
	else:
		take_damage(40, 40)
		return
				
func hit_project(_area: Area2D):
	take_damage(30, 20)
	return
	
func hit_lethal_area(_area: Area2D):
	take_damage(40, 60)
	return

func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
func can_fall_one_way_terrain() -> bool:
	return one_way_block_detector.is_colliding()
	
func fall_one_way_terrain():
	set_collision_mask_value(8, false)
	
	go_to_fall_state()
	
	await get_tree().create_timer(0.2).timeout
	
	exit_fall_one_way_terrain()
	
func exit_fall_one_way_terrain():
	set_collision_mask_value(8, true)
	
func take_damage(x: float, y: float):
	if status == PlayerState.dead: return
	
	if left_danger_detector.is_colliding():
		receive_damage(Vector2(x, -y))
	elif right_danger_detector.is_colliding():
		receive_damage(Vector2(-x, y))
		
func receive_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if status != PlayerState.dead:
		
		Globals.player_life -= 1
		if Globals.player_life > 0:
			if knockback_force != Vector2.ZERO:
				knockback_vector = knockback_force
				
				var knockback_tween := get_tree().create_tween()
				knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
				anim.modulate = Color(1, 0, 0, 1)
				knockback_tween.tween_property(anim, "modulate", Color(1,1,1,1), duration)
		else: 
			go_to_dead_state()
			
func drop_plataform():
	if Input.is_key_pressed(KEY_SPACE) and Input.is_key_pressed(KEY_DOWN) :
		position.y +=1
	
	
