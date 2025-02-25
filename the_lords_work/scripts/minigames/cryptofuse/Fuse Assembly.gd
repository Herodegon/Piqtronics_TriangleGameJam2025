extends Control
var has_contacts: bool
var has_fuse: bool
var fuse_color: Color
var fuse_type: int
@export var fuse_scene: PackedScene


func generate_slot(contacts: bool):
	has_contacts = contacts
	set_fuse_visibility(false)

func set_fuse_visibility(v: bool):
	$Fuse.visible = v
	has_fuse = v
	if v:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		mouse_default_cursor_shape = Control.CURSOR_CAN_DROP

func remove_fuse():
	set_fuse_visibility(false)

func set_fuse_type(c: Color, t: int):
	fuse_color = c
	fuse_type = t

func set_fuse(data):
	set_fuse_visibility(true)
	$Fuse.set_data(data)

func generate_random_fuse(good: int):
	$Fuse.randomize(good)
	set_fuse_visibility(true)
	return $Fuse

func generate_fuse(c: Color, t: int, good: int):
	$Fuse.set_color(c)
	$Fuse.set_type(t)
	$Fuse.set_state(good)
	$Fuse.set_break_pos(0)
	set_fuse_visibility(true)
	return $Fuse

func _get_drag_data(_at_position):
	if not has_fuse:
		return
	print("dragging")
	var preview: Control = fuse_scene.instantiate()
	preview.set_data($Fuse.get_data())
	set_drag_preview(preview)
	return $fuse

# func _gui_input(event):
# 	if event is InputEventMouseButton and event.pressed:
# 		print("Clicked on Slot!")

func _can_drop_data(_at_position, data):
	if has_fuse:
		return false
	if $Slot.has_contacts:
		return data["color"] == fuse_color and data["type"] == fuse_type
	return true

func _drop_data(_at_position, data):
	print("Dropping")
	has_fuse = true
	var parent_assembly = data.get_parent()
	parent_assembly.remove_fuse()
	set_fuse(data.get_data())
	
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Click detected at: ", event.position)
		print("Fuse Assembly size: ", size)


func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	$Slot.mouse_filter = Control.MOUSE_FILTER_PASS
	$Fuse.mouse_filter = Control.MOUSE_FILTER_PASS
	
# func _gui_input(event):
# 	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		print("Mouse clicked on slot")
# 		set_drag_preview(_get_drag_data(event.position))