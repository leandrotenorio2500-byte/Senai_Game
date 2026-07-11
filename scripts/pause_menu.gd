extends CanvasLayer
@onready var resume_btn: Button = $VBoxContainer/ResumeBtn
@onready var title_btn: Button = $VBoxContainer/TitleBtn
@onready var toque: AudioStreamPlayer = $toque


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true

func _on_resume_btn_pressed() -> void:
	toque.play()
	visible = false
	get_tree().paused = false
	resume_btn.grab_focus()

func _on_title_btn_pressed() -> void:
	toque.play()
	get_tree().change_scene_to_file("res://prefabs/title_screen.tscn")
