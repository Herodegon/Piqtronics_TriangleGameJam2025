extends Control
var fuse: Control
var has_contacts: bool
var has_fuse: bool
var fuse_color: Color
var fuse_type: int

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

func remove_fuse():
	has_fuse = false
	remove_child(fuse)

func _can_drop_data(_at_position, data):
	if has_fuse:
		return false
	return data.color == fuse_color and data.type == fuse_type

func _drop_data(_at_position, data):
	has_fuse = true
	var parent_slot = data.get_parent()
	parent_slot.remove_fuse()
	add_fuse(data)
	


func spawn(hc: bool, pos: Vector2):
	has_fuse = false

	set_contacts(hc)
	self.position = pos
