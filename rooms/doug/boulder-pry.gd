extends Timer

var count = 0
var current_scene
var event = InputEvent()

func _on_Timer_timeout():
	current_scene.queue_free()
	get_tree().change_scene("res://rooms/doug/doug-cave.tscn")

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		current_scene.queue_free()
		get_tree().change_scene("res://rooms/doug/doug-cave.tscn")

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	set_process_input(true)
	set_process(true)

func _process(delta):
	pass