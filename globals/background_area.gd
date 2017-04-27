extends Area2D

export var action = "walk"
var collisionshape_click
var rectangleshape

func input(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		if (event.button_index == 1):
			prints("click event =", event)
			get_tree().call_group(0, "game", "clicked", self, get_pos() + Vector2(event.x, event.y), BUTTON_LEFT)
		elif (event.button_index == 2):
			emit_right_click()
	
		
func get_action():
	return action

func _init():
	add_user_signal("right_click_on_bg")

func _enter_tree():
	# Use background texture to set collision shape
	var bg = get_parent().get_node("background")
	if bg:
		print(bg)

	var vec = Vector2(960.0, 540.0)

	var shape = RectangleShape2D.new()
	shape.set_extents(vec)
	# What's the difference between set_pos() and set_global_pos()?
	set_pos(vec)
	add_shape(shape)

func _ready():
	connect("input_event", self, "input")
	add_to_group("background")

	
	

func emit_right_click():
	emit_signal("right_click_on_bg")
