extends Control

var vm
var item_list = []
var page = 0

var actions = []

var page_max
var page_size
var current_action = ""

func change_page(dir):
	page += dir
	if page < 0:
		page = 0
	if page > page_max:
		page = page_max
	sort_items()

func open():
	if is_visible():
		return
	sort_items()
	show()
	get_node("animation").play("show")


func close():
	if !is_visible():
		return
	if get_node("animation").is_playing():
		return
	#printt("closing inventory")
	print_stack()
	get_node("animation").play("hide")
	get_node("look").set_pressed(false)
	current_action = ""
	print("inventory close")

func toggle():
	if is_visible():
		close()
	else:
		open()

func anim_finished():
	if get_node("animation").get_current_animation() == "hide":
		hide()

func sort_items():
	var items = get_node("items")
	var slots = get_node("slots")
	var count = 0
	var focus = false
	for i in range(0, items.get_child_count()):
		var c = items.get_child(i)
		if !vm.inventory_has(c.global_id):
			c.hide()
			continue
		if count >= page_size * (page+1):
			#printt("past page", count, page_size, page)
			c.hide()
		elif count >= page_size * page:
			var slot = count - page_size * page
			c.show()
			printt("showing item", c.global_id, slots.get_child(slot).get_global_pos())
			#printt("no focus")
			c.set_global_pos(slots.get_child(slot).get_global_pos())
			#c.set_focus_mode(Control.FOCUS_NONE)
			if !focus:
				#c.grab_focus()
				focus = true
		else:
			c.hide()
		count += 1
	page_max = int(count / page_size)

	if count > 0 && page > page_max:
		page -= 1
		sort_items()

func inventory_changed():
	printt("** inventory changed")
	if is_visible():
		printt("sorting")
		sort_items()

func global_changed(name):
	if name.find("i/") != 0:
		return
	inventory_changed()

func input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.pressed:
		toggle()

	if event.type == InputEvent.MOUSE_MOTION:
		#printt("mouse motion on alpha", get_node("../../..").pending_command)
		if get_node("../../..").pending_command != "" || vm.drag_object != null:
			toggle()

func get_action():
	return current_action

func look_toggled(pressed):
	if pressed:
		current_action = "look"
	else:
		current_action = "use"
	get_tree().call_group(0, "game", "clear_action")

func _input(event):
	if !vm.can_interact():
		return
	if event.is_pressed() && event.is_action("inventory_toggle"):
		toggle()

func log_button_pressed():
	close()
	get_tree().call_group(0, "game", "open_log")
	
func _on_open_inventory_signal(open):
	if (open):
		open()
	else:
		close()

func action_pressed(n):
	current_action = n
	for but in actions:
		but.set_pressed(but.get_name() == n)

func _ready():
	vm = get_tree().get_root().get_node("vm")
	vm.connect("inventory_changed", self, "inventory_changed")
	vm.connect("open_inventory", self, "_on_open_inventory_signal")
	vm.connect("global_changed", self, "global_changed")
	page_size = get_node("slots").get_child_count()
	sort_items()
	get_node("arrow_prev").connect("pressed", self, "change_page", [-1])
	#get_node("arrow_left").set_focus_mode(Control.FOCUS_NONE)
	get_node("arrow_next").connect("pressed", self, "change_page", [1])
	#get_node("arrow_right").set_focus_mode(Control.FOCUS_NONE)
	var items = get_node("items")
	for i in range(0, items.get_child_count()):
		var c = items.get_child(i)
		#printt("c path is ", c.get_name(), c.get_filename())
		c.inventory = true
		c.use_action_menu = false
		c.hide()
	items.show()
	set_focus_mode(Control.FOCUS_NONE)
	#get_node("mask").set_focus_mode(Control.FOCUS_NONE)
	set_process_input(true)

	var acts = get_node("actions")
	actions = []
	for i in range(acts.get_child_count()):
		var c = acts.get_child(i)
		actions.puah_back(c)
		c.connect("pressed", self, "action_pressed", [c.get_name()])

	#get_node("log_button").connect("pressed", self, "log_button_pressed")

	add_to_group("game")

	call_deferred("sort_items")
