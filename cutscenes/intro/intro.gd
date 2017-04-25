extends Sprite

var count = 0
var current_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func _on_Timer_timeout():
	count += 1
	get_node("DFAF").queue_free() 
	
func _on_Timer2_timeout():
	get_node("Godot").queue_free() 

func _on_Timer3_timeout():
	current_scene.queue_free()
	get_tree().change_scene("res://rooms/hub/hub.tscn")
