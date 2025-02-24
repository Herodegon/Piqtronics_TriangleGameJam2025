extends Node2D

@export var cover_color: Color
@export var cover_opacity: float
@export var type: int
@export var state: bool

func set_type(t: int):
	type = t
	$Type_text.text = "C%d" % t

func set_color(c: Color):
	cover_color = c
	cover_color.a = cover_opacity
	$Cover.color = c
func set_opacity(a: float):
	cover_color.a = a
	$Cover.color = cover_color

func set_state(s: bool):
	state = s
	$Wire.frame

func randomize():
	var colors = [Color.BLUE, Color.GREEN, Color.RED, Color.PURPLE, Color.YELLOW]
	var color_choice = colors[randi() % colors.size()]
	set_color(color_choice)
	var t = ((randi() % 9) + 1) * 10
	set_type(t)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
