extends Control
var has_fuse: bool
var fuse_color: Color
var fuse_type: int

func add_fuse(c: Color, t: int):
	has_fuse = true
	fuse_color = c
	fuse_type = t

func remove_fuse():
	has_fuse = false

func _can_drop_data(_at_position, data):
	if has_fuse:
		return false
	return data.color == fuse_color and data.type == fuse_type

func _drop_data(_at_position, data):
	has_fuse = true
	data.set_slot(self)


func spawn(pos: Vector2):
	self.position = pos
