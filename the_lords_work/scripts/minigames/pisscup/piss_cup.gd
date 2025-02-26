extends Control

func gen_parabola_curve(p0: Vector2, v0: Vector2, g: float = 9.8) -> Curve2D:
	var curve = Curve2D.new()
	var time_of_flight = (2 * v0.y) / g
	var end_point = Vector2(p0.x + v0.x * time_of_flight, p0.y)
	var peak_time = v0.y / g
	var peak_point = Vector2(
		p0.x + v0.x * peak_time,
		p0.y + v0.y * peak_time - 0.5 * g * peak_time ** 2
	)
	# Quadratic Bézier: P0 (start), P1 (control), P2 (end)
	curve.add_point(p0)
	curve.add_point(end_point, peak_point) # Control point at the peak
	return curve

func gen_parabola_slow(p0, v0, num_points, interval, g=9.8) -> Array[Vector2]:
	# Generate a parabola with the given initial position, initial velocity, number of points, time interval, and gravity.
	var points = []
	for i in range(num_points):
		var t = i * interval
		var x = p0.x + v0.x * t
		var y = p0.y + v0.y * t - 0.5 * g * t * t
		points.append(Vector2(x, y))
	return points


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
