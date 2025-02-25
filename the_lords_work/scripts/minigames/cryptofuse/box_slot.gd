extends Control
var has_contacts: bool

func set_contacts(c: bool):
	has_contacts = c
	if c:
		$Contacts.visible = true
	else:
		$Contacts.visible = false

func spawn(hc: bool):
	set_contacts(hc)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE