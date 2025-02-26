extends Path2D


var bezier_points = []
var path_points = []
@onready var piss_follower: PathFollow2D = $PissFollower


func generate_curve(num_points):
	curve = Curve2D.new()
	
	for i in range(num_points):
		bezier_points.append(Vector2(randf_range(0, 1920), randf_range(0, 1080)))
		curve.add_point(bezier_points[i])

func generate_path(num_points):
	var progress_interval = 1.0 / num_points
	var progress = 0
	for i in range(num_points):
		path_points.append(piss_follower.position)
		progress += progress_interval
		piss_follower.progress_ratio = progress

func generate_points(num_bezier_points, num_points):
	generate_curve(num_bezier_points)
	generate_path(num_points)
	return path_points


	