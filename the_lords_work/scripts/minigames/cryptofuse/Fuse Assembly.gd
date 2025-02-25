extends Control
var fuse: Control
var slot: Control
var has_contacts: bool
var has_fuse: bool
var fuse_color: Color
var fuse_type: int
@export var fuse_scene: PackedScene



func set_fuse_type(c: Color, t: int):
	fuse_color = c
	fuse_type = t

func add_fuse(f):
	self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	fuse = f
	fuse.set_anchors_preset(Control.PRESET_CENTER)
	fuse.position = Vector2(5,20)
	fuse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fuse.z_index = 0
	has_fuse = true
	add_child(f)
	#f.reparent(self)

func remove_fuse():
	self.mouse_default_cursor_shape = Control.CURSOR_CAN_DROP
	has_fuse = false
	remove_child(fuse)

func generate_random_fuse(state: int):
	fuse = fuse_scene.instantiate()
	fuse.randomize(state)
	add_fuse(fuse)
	set_fuse_type(fuse.cover_color, fuse.type)
	return fuse

func generate_fuse(c: Color, t: int, s: int):
	fuse = fuse_scene.instantiate()
	fuse.set_color(c)
	fuse.set_type(t)
	fuse.set_state(s)
	add_fuse(fuse)
	set_fuse_type(c, t)
	return fuse

func generate_slot(hc: bool):
	slot = $Box_Slot
	slot.set_anchors_preset(Control.PRESET_CENTER)
	slot.set_contacts(hc)

func spawn_random(hc: bool, s: int):
	generate_slot(hc)
	generate_random_fuse(s)

func spawn_fixed(pos: Vector2, c: Color, t: int, s: int, hc: bool):
	self.position = pos
	generate_slot(hc)
	generate_fuse(c, t, s)

func spawn_no_fuse(hc: bool):
	generate_slot(hc)
	self.mouse_default_cursor_shape = Control.CURSOR_CAN_DROP

func _get_drag_data(_at_position):
	if not has_fuse:
		return

	print("dragging")
	var preview: Control = fuse_scene.instantiate()
	preview.set_color(fuse.cover_color)
	preview.set_type(fuse.type)
	preview.set_break_pos(fuse.break_pos)
	preview.set_state(fuse.good)
	set_drag_preview(preview)
	return fuse

# func _gui_input(event):
# 	if event is InputEventMouseButton and event.pressed:
# 		print("Clicked on Slot!")

func _can_drop_data(_at_position, data):
	if has_fuse:
		return false
	if slot.has_contacts:
		return data.cover_color == fuse_color and data.type == fuse_type
	return true

func _drop_data(_at_position, data):
	print("Dropping")
	has_fuse = true
	var parent_slot = data.get_parent()
	parent_slot.remove_fuse()
	add_fuse(data)
	
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Click detected at: ", event.position)
		print("Fuse Assembly size: ", size)


func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
# func _gui_input(event):
# 	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		print("Mouse clicked on slot")
# 		set_drag_preview(_get_drag_data(event.position))