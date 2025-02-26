extends Node2D

# current Line2D object
var active_line

# materials used for pen and eraser
var draw_material
var erase_material

# operating modes
enum mode {
	draw = 0,
	erase,
	undo,
	count,
}
var current_mode = mode.draw
var piss_material

func io_point_helper(point, max_control_radius):
	var angle = randf() * PI
	var radius = randf() * max_control_radius
	var out_point = point + Vector2.from_angle(angle) * radius/2
	var in_point = point - Vector2.from_angle(angle) * radius/2
	return [in_point, out_point]

func generate_io_points(point, max_control_radius, top_left, bottom_right):
	var points = io_point_helper(point, max_control_radius)
	var in_point = points[0]
	var out_point = points[1]

	while (
			out_point.x < top_left.x
			or out_point.x > bottom_right.x 
			or out_point.y < top_left.y 
			or out_point.y > bottom_right.y 
			or in_point.x < top_left.x 
			or in_point.x > bottom_right.x 
			or in_point.y < top_left.y 
			or in_point.y > bottom_right.y
		):
		points = io_point_helper(point, max_control_radius)
		in_point = points[0]
		out_point = points[1]
	return [in_point, out_point]

func generate_piss_curve_continuous(num_points, top_left=Vector2(0,0), bottom_right=Vector2(1920,996), max_point_dist=500, max_control_radius=7, bake_interval=0.1):
	var curve = Curve2D.new()
	var last_point = Vector2(randf_range(top_left.x, bottom_right.x), randf_range(top_left.y, bottom_right.y))
	var in_point = Vector2(0, 0)
	var out_point = Vector2(0, 0)
	curve.add_point(last_point, out_point, in_point)

	for i in range(num_points-1):
		var next_point = last_point + Vector2.from_angle(randf_range(0, 2 * PI)) * randf_range(0, max_point_dist)
		while (next_point.x < top_left.x or next_point.x > bottom_right.x or next_point.y < top_left.y or next_point.y > bottom_right.y):
			next_point = last_point + Vector2.from_angle(randf_range(0, 2 * PI)) * randf_range(0, max_point_dist)
		var io_points = generate_io_points(next_point, max_control_radius, top_left, bottom_right)
		in_point = io_points[0]
		out_point = io_points[1]
		curve.add_point(next_point, in_point, out_point)
		
		last_point = next_point
	curve.bake_interval = bake_interval
	return curve

func generate_piss(num_lines, points_per_line = 10):
	for i in range(num_lines):
		var curve: Curve2D = generate_piss_curve_continuous(points_per_line)
		curve.bake_interval = 0.1
		var line = Line2D.new()
		line.material = piss_material
		line.default_color = Color.YELLOW
		line.width = randf() * 10 + 5
		var points = curve.get_baked_points()
		line.points = points
		$SubViewportContainer/SubViewport.add_child(line)

func _ready():
	piss_material = CanvasItemMaterial.new()
	piss_material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	draw_material = CanvasItemMaterial.new()
	draw_material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	erase_material = CanvasItemMaterial.new()
	erase_material.blend_mode = CanvasItemMaterial.BLEND_MODE_SUB
	generate_piss(10)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				if current_mode == mode.undo:
					undo_last()
					return
				active_line = Line2D.new()
				# alternating between draw/erase mode
				if current_mode == mode.draw:
					active_line.default_color = Color(randf(), randf(), randf(), 1)
					active_line.material = draw_material
				elif current_mode == mode.erase:
					active_line.default_color = Color(0, 0, 0, 1)
					active_line.material = erase_material
				active_line.position = event.position
				active_line.width = 15
				active_line.points = [Vector2(0, 0)]
				$SubViewportContainer/SubViewport.add_child(active_line)
		else:
			# button up
			if event.button_index == MOUSE_BUTTON_RIGHT:
				switch_mode()
	elif event is InputEventScreenDrag:
		if current_mode == mode.draw or current_mode == mode.erase:
			var points = active_line.points
			points.append(event.position - active_line.position)
			active_line.points = points
	pass

func undo_last():
	var count = $SubViewportContainer/SubViewport.get_child_count()
	if count > 0:
		print("Undo. Current stroke count:", count)
		$SubViewportContainer/SubViewport.get_child(count - 1).queue_free()
	pass

func switch_mode():
	current_mode = (current_mode+1) % mode.count
	match(current_mode):
		mode.draw:
			$Label.text = "Draw Mode. Right click to switch"
		mode.erase:
			$Label.text = "Eraser Mode. Right click to switch"
		mode.undo:
			$Label.text = "Undo Mode. Left click to Undo, Right click to switch"
	pass
