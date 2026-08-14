extends Control

@export var active_color: Color = Color("ffffff")
@export var inactive_color: Color = Color("666666")

@onready var bg: ColorRect = $Bg

func set_active(value: bool) -> void:
	bg.color = active_color if value else inactive_color
