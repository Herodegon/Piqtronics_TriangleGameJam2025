extends Control

@export var cover_color: Color
@export var cover_opacity: float = 0.5
@export var type: int
@export var good: int

#-27 to 
func set_type(t: int):
	type = t
	$Type_text.text = "C%d" % t
func set_break_pos(p: int):
	$Break.position.y = -13
	$Break.position.x = p

func set_color(c: Color):
	cover_color = c
	cover_color.a = cover_opacity
	$Cover.color = c
	$Backplate.color = c
	$Break.color = c
func set_opacity(a: float):
	cover_color.a = a
	$Cover.color = cover_color

func set_state(s: int):
	good = s
	if good == 1:
		$Break.visible = false
	else:
		$Break.visible = true


func _get_drag_data(_at_position):
	return self
	

func randomize(s: int):
	var colors = [Color.BLUE, Color.DARK_GREEN, Color.DARK_RED, Color.DARK_VIOLET, Color.DARK_GOLDENROD]
	var color_choice = colors[randi() % colors.size()]
	set_color(color_choice)
	
	set_opacity(cover_opacity)
	
	var t = ((randi() % 9) + 1) * 10
	set_type(t)	
	
	var break_pos = randi() % 61 - 40
	set_break_pos((break_pos))
	
	
	if s == 2:
		set_state(randi() % 2)
	else:
		set_state(s)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.