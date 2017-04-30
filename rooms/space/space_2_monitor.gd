extends Node2D

func global_changed(name):
	if name != "start_moving":
		return
	
	# Hide player_sham
	var player_sham = get_parent().get_node("player_sham")
	player_sham.set_hidden(true)
	
	# Show player character and enable it to move
	var player = get_parent().get_node("player")
	player.set_active(true)
	player.telekinetic = false

func _ready():
	var vm = get_tree().get_root().get_node("vm")
	vm.connect("global_changed", self, "global_changed")