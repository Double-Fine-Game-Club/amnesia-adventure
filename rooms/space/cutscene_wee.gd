extends Node2D

var seconds = 0
var space_scene
var has_dialogue = true

func skip_dialogue():
	if has_dialogue:
		get_node("text").set_bbcode("")
		has_dialogue = false

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed && has_dialogue == false:
		get_tree().change_scene_to(space_scene)

func _ready():
	# Preload main scene
	space_scene = preload("res://rooms/space/cutscene_final.tscn")
	set_process_input(true)
	set_process(true)

func _process(delta):
    # Add up seconds passed
	seconds += delta
	if (seconds >= 2 && has_dialogue) || seconds >= 10:
		skip_dialogue()