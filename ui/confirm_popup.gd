var target = null
var slot = ""

func start(message, p_target, p_slot):
	get_node("message").set_text(message)
	target = p_target
	slot = p_slot
	get_node("/root/main").menu_open(self)
	show()

func button_pressed(p_confirm):
	if target != null:
		target.call_deferred(slot, p_confirm)


	close()

func menu_collapsed():
	close()


func close():
	get_node("/root/main").menu_close(self)
	queue_free()

func input(event):
	if event.is_action("menu_request") && event.is_pressed() && !event.is_echo():
		button_pressed(false)

func _ready():
	get_node("yes").connect("pressed", self, "button_pressed", [true])
	get_node("no").connect("pressed", self, "button_pressed", [false])