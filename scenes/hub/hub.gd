extends Control
var current_scene

func doug_pressed():
	current_scene.queue_free()
	get_tree().change_scene("res://scenes/doug/doug.tscn")

func clock_pressed():
	current_scene.queue_free()
	get_tree().change_scene("res://scenes/clock/clock.tscn")

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	get_node("doug").connect("pressed", self, "doug_pressed")
	get_node("clock").connect("pressed", self, "clock_pressed")
	