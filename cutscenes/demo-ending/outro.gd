extends Sprite

var count = 0
var current_scene
var event = InputEvent()

func _on_Timer_timeout():
	count += 1
	get_node("ending").queue_free() 
	
func _on_Timer2_timeout():
	current_scene.queue_free()
	get_tree().quit()

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		current_scene.queue_free()
		get_tree().quit()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	set_process_input(true)
	set_process(true)

func _process(delta):
	pass