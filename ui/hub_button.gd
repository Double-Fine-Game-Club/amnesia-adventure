var vm
var root

func button_clicked():
	# play a clicking sound here?
	pass

func hub_button_pressed():
	button_clicked()
	vm.load_file("res://game/hub.esc")

func close():
	root.load_menu(Globals.get("ui/main_menu"))
	
func input(event):
	if event.is_pressed() && !event.is_echo() && event.is_action("menu_request"):
		if root.get_current_scene() extends preload("res://globals/scene.gd"):
			close()

func menu_collapsed():
	close()

func _ready():
	get_node("hub_button").connect("pressed", self, "hub_button_pressed")
	vm = get_tree().get_root().get_node("vm")
	set_process_input(true)

	root = get_node("/root/main")
	root.menu_open(self)
