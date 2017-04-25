extends Node2D

var seconds = 0
var cutscene_pipe_2
	
func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		get_tree().change_scene_to(cutscene_pipe_2)

func _ready():
	# Preload main scene
	cutscene_pipe_2 = preload("res://rooms/space/cutscene_pipe_2.tscn")
	set_process_input(true)
	set_process(true)

func _process(delta):
    # Add up seconds passed
	seconds += delta
	if (seconds >= 5) || seconds >= 10:
		get_tree().change_scene_to(cutscene_pipe_2)