extends Control

var vm
var root

func hub_button_pressed():
	vm.load_file("res://game/hub.esc")

func close():
	root.load_menu(Globals.get("ui/main_menu"))
	
func input(event):
	pass

func menu_collapsed():
	close()

func _ready():
	get_node("hub_button").connect("pressed", self, "hub_button_pressed")
	vm = get_tree().get_root().get_node("vm")
	set_process_input(true)

	root = get_node("/root/main")
