extends Control

var vm
var root
var confirm_popup = null
var labels = []

func load_autosave():
	vm.load_autosave()

func button_clicked():
	# play a clicking sound here?
	pass

func newgame_pressed():
	button_clicked()
	if root.get_current_scene() extends preload("res://globals/scene.gd"):
		confirm_popup = get_node("/root/main").load_menu("res://ui/confirm_popup.tscn")
		confirm_popup.start("UI_NEW_GAME_CONFIRM",self,"start_new_game")
	else:
		start_new_game(true)
		
func start_new_game(p_confirm):
	if !p_confirm:
		return
	vm.load_file("res://game/game.esc")

func save_pressed():
	button_clicked()
	get_node("/root/main").load_menu(Globals.get("ui/savegames"))

func settings_pressed():
	button_clicked()
	root.load_menu(Globals.get("ui/settings"))

func credits_pressed():
	button_clicked()
	root.load_menu(Globals.get("ui/credits"))

func close():
	root.menu_close(self)
	queue_free()

func input(event):
	if event.is_pressed() && !event.is_echo() && event.is_action("menu_request"):
		if root.get_current_scene() extends preload("res://globals/scene.gd"):
			close()

func menu_collapsed():
	close()

func _on_exit_pressed():
	button_clicked()
	confirm_popup = get_node("/root/main").load_menu("res://ui/confirm_popup.tscn")
	confirm_popup.start("UI_QUIT_CONFIRM",self,"_quit_game")
	
func _quit_game(p_confirm):
	if !p_confirm:
		return
	get_tree().quit()

func language_changed():
	for l in labels:
		l.set_text(l.get_name())
		printt("label for ", l.get_name(), TranslationServer.translate(l.get_name()))

func _find_labels(p = null):
	if p == null:
		p = self
	if p.is_type("Label"):
		labels.push_back(p)
	for i in range(0, p.get_child_count()):
		_find_labels(p.get_child(i))

func _on_language_selected(lang):
	vm.settings.text_lang=lang
	TranslationServer.set_locale(vm.settings.text_lang)
	get_tree().call_group(0, "ui", "language_changed")
	vm.save_settings()

func _ready():
	printt("** locale is ", TranslationServer.get_locale())
	get_node("new_game").connect("pressed", self, "newgame_pressed")
	get_node("exit").connect("pressed", self, "_on_exit_pressed")
	get_node("settings").connect("pressed", self, "settings_pressed")
	get_node("credits").connect("pressed",self,"credits_pressed")
	get_node("GoBack").connect("pressed",self,"close")
	vm = get_tree().get_root().get_node("vm")
	set_process_input(true)

	root = get_node("/root/main")
	root.menu_open(self)

	_find_labels()

	add_to_group("ui")

	if !Globals.get("platform/exit_button"):
		get_node("exit").hide()
