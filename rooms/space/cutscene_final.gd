extends Node2D

var seconds = 0
var space_scene
var has_dialogue = true
var current_scene

func skip_dialogue():
	if has_dialogue:
		get_node("text").set_bbcode("And despite all the excitement, the best room is still a restroom.")
		has_dialogue = false
		get_node("escoria-action").activate("look", null)

		

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed && has_dialogue == false:
		get_node("escoria-action").activate("look", null)

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	set_process_input(true)
	set_process(true)

func _process(delta):
    # Add up seconds passed
	seconds += delta
	if (seconds >= 5 && has_dialogue) || seconds >= 10:
		skip_dialogue()