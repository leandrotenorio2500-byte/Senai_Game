extends CharacterBody2D

enum MachineState {
	idle,
	dead,
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox



var status: MachineState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		MachineState.idle:
			idle_state(delta)
		MachineState.dead:
			dead_state(delta)
		
	move_and_slide()
	
func go_to_idle_state():
	status = MachineState.idle
	anim.play("idle")
	
func go_to_dead_state():
	status = MachineState.dead
	anim.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
func idle_state(_delta):
	if velocity.x == 0:
		go_to_idle_state()
		return
		
func dead_state(_delta):
	pass
	
func take_damage():
	go_to_dead_state()
	
		


	
