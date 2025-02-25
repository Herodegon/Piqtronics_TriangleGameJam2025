extends Node2D
@export var empty: bool

func set_variant(e: bool):
	if e:
		$Slot.visible = false
		$SlotEmpty.visible = true
	else:
		$Slot.visible = true
		$SlotEmpty.visible = false
	empty = e
func spawn(e: bool, pos: Vector2):
	set_variant(e)
	self.position = pos
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
