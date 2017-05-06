extends Node2D

var seconds = 0
var doug_scene
var has_dialogue = true
var current_scene

func skip_dialogue():
	if has_dialogue:
		get_node("text").set_bbcode("[center]... wait... was I an ogre?[/center]")
		has_dialogue = false
	else:
		current_scene.queue_free()
		get_tree().change_scene_to(doug_scene)
	
func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		skip_dialogue()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	# Preload main scene
	doug_scene = preload("res://rooms/doug/doug.tscn")
	set_process_input(true)
	set_process(true)

func _process(delta):
    # Add up seconds passed
	seconds += delta
	if (seconds >= 5 && has_dialogue) || seconds >= 10:
		skip_dialogue()