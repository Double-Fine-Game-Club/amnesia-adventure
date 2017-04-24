extends CollisionPolygon2D

signal space_selected

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		emit_signal("space_selected")

func _ready():
	set_process_input(true)
