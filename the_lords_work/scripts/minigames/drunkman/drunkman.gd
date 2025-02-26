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

func generate_piss(num_lines):
	for i in range(num_lines):
		draw_piss(5, 1, randi() % 10 + 5)

func draw_piss(num_bezier_points, bake_interval, piss_width):
	var line = Line2D.new()
	line.material = piss_material
	line.default_color = Color.YELLOW
	line.width = piss_width
	line.points = generate_piss_points(num_bezier_points, bake_interval)
	$SubViewportContainer/SubViewport.add_child(line)

func generate_bezier_point(point_range, max_radius):
	var p = Vector2(randf_range(0, point_range.x), randf_range(0, point_range.y))
	var angle = randf() * 2 * PI
	var radius = randf() * max_radius
	
	var i = p + Vector2.from_angle(angle) * radius

	angle = randf() * 2 * PI
	radius = randf() * max_radius
	var o = p + Vector2.from_angle(angle) * radius
	return [p, i, o]
	

func generate_piss_points(num_bezier_points, bake_interval):
	var curve: Curve2D = Curve2D.new()
	for i in range(num_bezier_points):
		var points = generate_bezier_point($SubViewportContainer/SubViewport.size - Vector2i(-100, -100), 20)
		curve.add_point(points[0], points[1], points[2])
	curve.bake_interval = bake_interval

	return curve.get_baked_points()


func _ready():
	piss_material = CanvasItemMaterial.new()
	piss_material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	draw_material = CanvasItemMaterial.new()
	draw_material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	erase_material = CanvasItemMaterial.new()
	erase_material.blend_mode = CanvasItemMaterial.BLEND_MODE_SUB
	generate_piss(5)

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
