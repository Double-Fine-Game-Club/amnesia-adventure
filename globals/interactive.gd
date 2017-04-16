export(Script) var animations

var vm
var terrain
var walk_path
var walk_context
var moved
var last_scale = Vector2(1, 1)
var last_dir = 0
var animation
var state = ""
var walk_destination
var path_ofs
var pose_scale = 1
var task
var sprites = []

export var speed = 300
export var scale_on_map = false
export var light_on_map = false setget set_light_on_map

func set_light_on_map(p_light):
	light_on_map = p_light
	if light_on_map:
		_update_terrain()
	else:
		modulate(Color(1, 1, 1, 1))


func _get_dir(angle):
	if animations == null:
		return -1
	var deg = rad2deg(angle) + 180
	var dir = -1
	var i = 0
	for ang in animations.dir_angles:
		if deg < ang:
			dir = i
			break
		i+=2
	return dir

func walk_stop(pos):
	set_pos(pos)
	walk_path = []

	if animation != null && animation.is_playing():
		animation.stop()
	set_state(state)

	task = null
	_update_terrain()

	if walk_context != null:
		vm.finished(walk_context)
		walk_context = null

func walk_to(pos, context = null):
	walk_path = terrain.get_path(get_pos(), pos)
	walk_context = context
	if walk_path.size() == 0:
		walk_stop(get_pos())
		set_process(false)
		task = null
		return
	moved = true
	walk_destination = walk_path[walk_path.size()-1]
	if terrain.is_solid(pos):
		walk_destination = walk_path[walk_path.size()-1]
	path_ofs = 0.0
	task = "walk"
	set_process(true)

func walk(pos, speed, context = null):
	walk_to(pos, context)

func modulate(color):
	for s in sprites:
		s.set_modulate(color)


func _process(time):

	if task == "walk":
		var to_walk = speed * last_scale.x * time
		var pos = get_pos()
		var old_pos = pos
		var next
		if walk_path.size() > 0:
			while to_walk > 0:
				var next
				if walk_path.size() > 1:
					next = walk_path[path_ofs + 1]
				else:
					next = walk_path[path_ofs]

				var dist = pos.distance_to(next)

				if dist > to_walk:
					var n = (next - pos).normalized()
					pos = pos + n * to_walk
					break
				pos = next
				to_walk -= dist
				path_ofs += 1
				if path_ofs >= walk_path.size() - 1:
					walk_stop(walk_destination)
					set_process(false)
					return

		var angle = old_pos.angle_to_point(pos)
		set_pos(pos)

		last_dir = _get_dir(angle)

		if has_node("animation"):
			if last_dir != -1 && animation.get_current_animation() != animations.directions[last_dir]:
				animation.play(animations.directions[last_dir])

		#pose_scale = animations.directions[last_dir+1]

		_update_terrain()

func _find_sprites(p = null):
	if p.is_type("Sprite") || p.is_type("AnimatedSprite") || p.is_type("TextureFrame") || p.is_type("TextureButton"):
		sprites.push_back(p)
	for i in range(0, p.get_child_count()):
		_find_sprites(p.get_child(i))

func _ready():
	if has_node("../terrain"):
		terrain = get_node("../terrain")

	_find_sprites(self)

	if get_tree().is_editor_hint():
		return
	if has_node("animation"):
		animation = get_node("animation")
	vm = get_node("/root/vm")
