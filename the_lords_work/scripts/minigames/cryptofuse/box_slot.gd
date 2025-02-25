extends Control
var fuse: Control
var has_contacts: bool
var has_fuse: bool
var fuse_color: Color
var fuse_type: int
@export var fuse_scene: PackedScene

func set_contacts(c: bool):
	has_contacts = c
	if c:
		$Contacts.visible = true
	else:
		$Contacts.visible = false

func set_fuse_type(c: Color, t: int):
	fuse_color = c
	fuse_type = t


func add_fuse(f):
	fuse = f
	has_fuse = true
	add_child(f)
	f.reparent(self)

func remove_fuse():
	has_fuse = false
	remove_child(fuse)

func _get_drag_data(_at_position):
	if not has_fuse:
		return

	print("dragging")
	var preview = fuse_scene.instantiate()
	preview.set_color(fuse.cover_color)
	preview.set_type(fuse.type)
	preview.set_break_pos(fuse.break_pos)
	preview.set_state(fuse.good)
	set_drag_preview(preview)
	return fuse


func _can_drop_data(_at_position, data):
	print("Checking can drop")
	if has_fuse:
		return false
	if has_contacts:
		return data.cover_color == fuse_color and data.type == fuse_type
	return true

func _drop_data(_at_position, data):
	print("Dropping")
	has_fuse = true
	var parent_slot = data.get_parent()
	parent_slot.remove_fuse()
	add_fuse(data)
	


func spawn(hc: bool, pos: Vector2):
	has_fuse = false

	set_contacts(hc)
	self.position = pos

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP

# func _gui_input(event):
# 	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		print("Mouse clicked on slot")
# 		set_drag_preview(_get_drag_data(event.position))